
# NixOS Build

## On new machine

1. Install NixOS
1. nix-shell -p git and git clone ansible repo
1. Run the nix install script to get github ssh keys and config file installed
1. clone dotfiles repo
1. Copy the machine's `hardware-configuration.nix` file at /etc/nix/hardware-configuration.nix into the repo
1. sudo git config --global --add safe.directory ~/.dotfiles
1. sudo nixos-rebuild switch --flake ~/.dotfiles/nix/nixos#framework-pc

## To update machine

1. `sudo nixos-rebuild switch`
