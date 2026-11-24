# framework-pc: Framework Desktop home server.
{ ... }:

{
  imports = [
    ./hardware-configuration.nix # generated on this machine; copy it in
    ../../modules/base.nix
    ../../modules/users.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
    ../../modules/docker.nix
    ../../modules/desktop.nix
    ../../modules/neovim.nix
    ../../modules/shell.nix
    ../../modules/dotfiles.nix
    ../../modules/swap.nix
  ];

  networking.hostName = "framework-pc";

  # Do NOT change after install. See `man configuration.nix`.
  system.stateVersion = "26.05";
}
