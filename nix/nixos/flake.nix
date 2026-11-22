{
  description = "Alex's NixOS machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # Reuse our nixpkgs instead of downloading nixos-hardware's own copy.
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, nixos-hardware, ... }:
    {
      # Name must match networking.hostName: a plain `sudo nixos-rebuild switch`
      # picks the configuration named after the machine's hostname.
      nixosConfigurations.framework-pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/framework-pc/configuration.nix
          nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
        ];
      };
    };
}
