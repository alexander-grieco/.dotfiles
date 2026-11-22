# Boot, locale, networking, Nix settings and housekeeping, firmware.
{ ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true; # default, stated explicitly

  # Locale / time
  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  nixpkgs.config.allowUnfree = true;

  # Flakes on permanently (the first build passes these on the command line).
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # `sudo nixos-rebuild` reads the flake as root, but ~/.dotfiles belongs to
  # alex; without this, git refuses to open it ("not owned by current user").
  programs.git = {
    enable = true;
    config.safe.directory = "/home/alex/.dotfiles";
  };

  # Nix store housekeeping
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  # Automatic upgrades are OFF with flakes: upgrading means rewriting
  # flake.lock in your repo, which an unattended root job would do as root.
  # Update by hand instead:
  #   nix flake update && sudo nixos-rebuild switch   # then commit flake.lock
  system.autoUpgrade.enable = false;

  # Framework BIOS/firmware updates: run `fwupdmgr refresh && fwupdmgr update`
  services.fwupd.enable = true;
}
