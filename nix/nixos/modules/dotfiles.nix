# Symlinks the listed files/folders out of ~/.dotfiles (cloned by hand during
# bootstrap; this config lives inside it). Not linked: bin, mac, macos, nix.
# The repo stays a normal git checkout: edit, commit and `git pull` as usual.
# To stop controlling something, delete its line.
{ lib, ... }:

let
  user = "alex";
  home = "/home/${user}";
  repoDir = "${home}/.dotfiles";

  # "path in home" = "path in repo"
  links = {
    # scripts
    ".local/bin" = "bin/.local/bin";

    # cargo (only the config; ~/.cargo also holds downloaded crates)
    ".cargo/config.toml" = "cargo/.cargo/config.toml";

    # config
    ".config/nvim" = "config/.config/nvim";
    ".config/k9s" = "config/.config/k9s";
    ".config/herdr" = "config/.config/herdr";
    ".config/ghostty" = "config/.config/ghostty";

    # git
    ".gitconfig" = "git/.gitconfig";
    ".gitignore-global" = "git/.gitignore-global";

    # starship (your .zshrc sets STARSHIP_CONFIG=~/starship.toml)
    "starship.toml" = "starship/starship.toml";

    # terraform
    ".terraformrc" = "terraform/.terraformrc";

    # tmux
    ".tmux.conf" = "tmux/.tmux.conf";

    # zsh
    ".zshrc" = "zsh/.zshrc";
    ".zsh" = "zsh/.zsh";
  };
in
{
  # Real parent dirs, then one symlink per entry. "L+" REPLACES whatever is at
  # the target (file, whole directory, or a symlink pointing elsewhere), so
  # every listed path always matches the repo after boot / nixos-rebuild switch.
  systemd.tmpfiles.rules =
    [
      "d ${home}/.config 0755 ${user} users - -"
      "d ${home}/.local 0755 ${user} users - -"
      "d ${home}/.cargo 0755 ${user} users - -"
      "d ${home}/.claude 0755 ${user} users - -"
      # /etc/nixos -> this flake, so a plain `sudo nixos-rebuild switch` works
      "L+ /etc/nixos - - - - ${repoDir}/nix/nixos"
    ]
    ++ lib.mapAttrsToList (dest: src: "L+ ${home}/${dest} - - - - ${repoDir}/${src}") links;
}
