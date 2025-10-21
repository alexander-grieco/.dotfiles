# . /usr/local/opt/asdf/asdf.sh
export STARSHIP_CONFIG=~/starship.toml
eval "$(starship init zsh)"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# End Nix
[[ -f ~/.zsh/downloads.zsh ]] && source ~/.zsh/downloads.zsh
[[ -f ~/.zsh/exports.zsh ]] && source ~/.zsh/exports.zsh
[[ -f ~/.zsh/export-secret.zsh ]] && source ~/.zsh/export-secret.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh
[[ -f ~/.zsh/znap.zsh ]] && source ~/.zsh/znap.zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/gcp.zsh ]] && source ~/.zsh/gcp.zsh

# Source Dynamic gitconfig settings
if [[ -v GITHUB_EMAIL ]]; then
  gse
else
  echo "Be sure to set GITHUB_EMAIL env var and re-source"
fi

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

autoload -U +X bashcompinit && bashcompinit

eval "$(zoxide init zsh)"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# pnpm
export PNPM_HOME="/Users/alex/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# kubectl completions
# If you get tired of slowness: kubectl completion zsh;
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
