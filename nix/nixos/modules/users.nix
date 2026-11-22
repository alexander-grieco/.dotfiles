{ ... }:

{
  users.users.alex = {
    isNormalUser = true;
    description = "Alex Grieco";
    extraGroups = [
      "networkmanager"
      "wheel"
      "root"
      "docker" # docker group = effectively root on this box
    ];
    # Public key kept in the repo (flakes can't read ~/.ssh). Public keys only.
    openssh.authorizedKeys.keyFiles = [
      ../keys/github_ed25519.pub
    ];
  };
}
