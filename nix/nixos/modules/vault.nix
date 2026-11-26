{ pkgs, lib, ... }:

let
  user = "alex";
  vaultAddr = "http://127.0.0.1:8200";

  policyDir = ./vault-policies;

  # Get all policy files in nix/nixos/modules/${policyDir}/ folder
  policies = lib.mapAttrs' (file: _: lib.nameValuePair (lib.removeSuffix ".hcl" file) "${policyDir}/${file}") (
    lib.filterAttrs (file: type: type == "regular" && lib.hasSuffix ".hcl" file) (builtins.readDir policyDir)
  );

  # Apply all found policy files
  writePolicies = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: file: ''
      vault policy write ${lib.escapeShellArg name} ${file}
    '') policies
  );

  # Exit quietly (success) when Vault is sealed/unreachable or we have no token,
  # so boot-time runs don't show up as failures. Rerun by hand once unsealed.
  readyCheck = ''
    if [ ! -s "$HOME/.vault-token" ]; then
      echo "No ~/.vault-token yet (run vault-bootstrap-admin first); skipping."
      exit 0
    fi
    set +e
    vault status >/dev/null 2>&1
    status=$?
    set -e
    if [ "$status" -ne 0 ]; then
      echo "Vault is sealed or unreachable (vault status exit $status); skipping."
      exit 0
    fi
  '';

  bootstrap = pkgs.writeShellApplication {
    name = "vault-bootstrap-admin";
    runtimeInputs = [ pkgs.vault-bin ];
    text = ''
      printf 'Root token (input hidden): '
      read -rs root
      echo
      export VAULT_TOKEN="$root"
      vault token lookup >/dev/null

      echo "Writing policies..."
      ${writePolicies}

      new=$(vault token create -policy=admin -orphan -period=768h \
        -display-name=${user}-admin -field=token)
      unset VAULT_TOKEN
      vault login -no-print "$new"
      echo "Logged in with a periodic admin token (saved to ~/.vault-token)."

      read -rp "Revoke the root token now? (generate a new one later with 'vault operator generate-root') [y/N] " answer
      if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        vault token revoke "$root"
        echo "Root token revoked."
      fi
    '';
  };
in
{
  environment.systemPackages = [
    pkgs.vault-bin
    bootstrap
  ];
  environment.sessionVariables.VAULT_ADDR = vaultAddr;

  # Re-applies policies whenever a policy file changes (RemainAfterExit makes
  # nixos-rebuild restart it on change). Manual rerun:
  #   sudo systemctl restart vault-policies
  systemd.services.vault-policies = {
    description = "Apply Vault policies from the NixOS config";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" "tailscaled.service" ];
    path = [ pkgs.vault-bin ];
    environment.VAULT_ADDR = vaultAddr;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = user;
    };
    script = ''
      ${readyCheck}
      ${writePolicies}
      echo "Applied policies: ${lib.concatStringsSep ", " (lib.attrNames policies)}"
    '';
  };

  # Periodic tokens expire if not renewed within their period (768h = 32 days).
  systemd.services.vault-token-renew = {
    description = "Renew the Vault admin token";
    after = [ "network-online.target" "tailscaled.service" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.vault-bin ];
    environment.VAULT_ADDR = vaultAddr;
    serviceConfig = {
      Type = "oneshot";
      User = user;
    };
    script = ''
      ${readyCheck}
      vault token renew >/dev/null
      echo "Token renewed."
    '';
  };
  systemd.timers.vault-token-renew = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true; # catch up after downtime
      RandomizedDelaySec = "1h";
    };
  };
}
