# zsh as login shell, using the ~/.zshrc linked from dotfiles.
{ pkgs, ... }:

{
  programs.zsh = {
    enable = true; # required: NixOS refuses a zsh login shell without it

    # Your .zshrc lets znap run compinit; skip NixOS's global compinit in
    # /etc/zshrc so it doesn't run twice. Completion files from Nix packages
    # are still added to fpath (enableCompletion stays on).
    enableGlobalCompInit = false;

    # Starship draws the prompt; don't load NixOS's default prompt theme.
    promptInit = "";
  };

  # Install fzf
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  users.users.alex.shell = pkgs.zsh;

  # # fzf's Ctrl-R / Ctrl-T / Alt-C bindings and ** completion. Replaces the
  # # ~/.fzf.zsh your exports.zsh sources on macOS (that file doesn't exist here).
  # programs.fzf = {
  #   keybindings = true;
  #   fuzzyCompletion = true;
  # };

  # Things .zshrc / .zsh/downloads.zsh expect to find.
  environment.systemPackages = with pkgs; [
    starship # otherwise downloads.zsh tries a curl | sh install on every shell
    zoxide # plain package: .zshrc already runs `zoxide init zsh` itself
    fzf
    git
    curl
  ];
}
