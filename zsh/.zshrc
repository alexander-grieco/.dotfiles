# . /usr/local/opt/asdf/asdf.sh
export STARSHIP_CONFIG=~/starship.toml
eval "$(starship init zsh)"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# End Nix

# Completions
autoload -Uz compinit
compinit

autoload -U +X bashcompinit
bashcompinit

complete -C "$(command -v aws_completer)" aws
# Completions end
#
# Apparently this needs to come after the completion config above
[[ -f ~/.zsh/downloads.zsh ]] && source ~/.zsh/downloads.zsh
[[ -f ~/.zsh/exports.zsh ]] && source ~/.zsh/exports.zsh
[[ -f ~/.zsh/export-secret.zsh ]] && source ~/.zsh/export-secret.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/gcp.zsh ]] && source ~/.zsh/gcp.zsh
[[ -f ~/.zsh/znap.zsh ]] && source ~/.zsh/znap.zsh

# Source Dynamic gitconfig settings
if [[ -v GITHUB_EMAIL ]]; then
  gse
else
  echo "Be sure to set GITHUB_EMAIL env var and re-source"
fi


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

# peon-ping quick controls
alias peon="bash /Users/alex/.claude/hooks/peon-ping/peon.sh"
[ -f /Users/alex/.claude/hooks/peon-ping/completions.bash ] && source /Users/alex/.claude/hooks/peon-ping/completions.bash

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/alex/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/alex/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/alex/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/alex/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
