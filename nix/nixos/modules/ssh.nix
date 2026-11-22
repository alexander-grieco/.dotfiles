{ ... }:

{
  services.openssh = {
    enable = true;

    # Can set to false and use Tailscale ssh
    openFirewall = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
