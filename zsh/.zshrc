[[ -f ~/.zsh/downloads.zsh ]] && source ~/.zsh/downloads.zsh
[[ -f ~/.zsh/exports.zsh ]] && source ~/.zsh/exports.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh
[[ -f ~/.zsh/znap.zsh ]] && source ~/.zsh/znap.zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/gcp.zsh ]] && source ~/.zsh/gcp.zsh

# . /usr/local/opt/asdf/asdf.sh
eval "$(starship init zsh)"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
