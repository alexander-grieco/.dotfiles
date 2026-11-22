# NOTE: ports published with `-p`/`ports:` BYPASS the NixOS firewall.
# Publish as "127.0.0.1:8080:80" and expose via `tailscale serve` or a
# reverse proxy, rather than "8080:80" (which is open to the whole LAN).
{ ... }:

{
  virtualisation.docker = {
    enable = true;

    autoPrune = {
      enable = true;
      dates = "weekly";
    };

    daemon.settings = {
      # Default json-file logs grow forever; cap them.
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
      # data-root = "/srv/docker"; # uncomment if images/volumes go on a second disk
    };
  };
  # `docker compose` (v2) is bundled with nixpkgs' docker package already.
}
