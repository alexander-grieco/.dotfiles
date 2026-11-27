# General packages that need no configuration beyond being installed.
# Anything needing real setup (services, options) gets its own module.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go # also lets Mason build Go-based tools (gopls, etc.)

    # Inspecting data and APIs
    jq # JSON (Caddy admin API, Tailscale/Vault output)
    yq-go # YAML (compose files)

    # Networking
    dnsutils # dig, nslookup
    wget
    lsof # what's listening / holding a port: lsof -i :8443
    tcpdump # packet capture, for when a connection silently fails

    # System
    btop # process / CPU / memory / disk overview
    ncdu # find what's using disk space (Docker images, volumes)
    tree # directory listings

    # Docker
    lazydocker # terminal UI for containers, logs and stats
  ];
}
