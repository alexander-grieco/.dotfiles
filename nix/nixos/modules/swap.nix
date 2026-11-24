{ lib, ... }:

{
  # Replaces the swap entry from hardware-configuration.nix with encrypted swap
  # (new random key each boot). Must be by-partuuid: encryption wipes the
  # partition's filesystem UUID, so a by-uuid path would stop existing.
  swapDevices = lib.mkForce [
    {
      device = "/dev/disk/by-partuuid/c31b14af-1b19-4bdd-ad03-a27593134a53";
      randomEncryption.enable = true;
    }
  ];
}
