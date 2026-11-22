{ ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = false;
    useRoutingFeatures = "server"; # only for subnet router / exit node
    # Route acceptance deliberately OFF: a node on the tailnet advertises this
    # server's own LAN, and accepting it routes LAN traffic (incl. SSH replies)
    # through tailscale0. Only re-enable with that subnet excluded.
  };

  # Anything arriving over the tailnet is allowed; everything else stays
  # closed unless explicitly opened.
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
