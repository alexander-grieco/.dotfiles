# Neovim with an unmodified, portable config (~/.config/nvim from dotfiles).
# NixOS only provides the editor and the system tools the config shells out to.
{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # sets EDITOR=nvim
    viAlias = true;
    vimAlias = true;
  };

  # Lets prebuilt Linux binaries (Mason's LSPs/formatters, etc.) run on NixOS,
  # which otherwise lacks the standard /lib64/ld-linux loader they expect.
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    git # lazy.nvim / plugin managers clone plugins
    gcc # treesitter parser compilation
    gnumake # e.g. telescope-fzf-native
    tree-sitter # CLI, needed by newer nvim-treesitter versions
    unzip # Mason extracts downloads
    ripgrep # telescope / fzf-lua live grep
    fd # file finding
    nodejs # Mason installs many LSPs via npm
    python3 # some Mason packages use pip
    stow # for the symlinking done for dotfiles
  ];
}
