# . /usr/local/opt/asdf/asdf.sh
export STARSHIP_CONFIG=~/starship.toml
eval "$(starship init zsh)"

[[ -f ~/.zsh/downloads.zsh ]] && source ~/.zsh/downloads.zsh
[[ -f ~/.zsh/exports.zsh ]] && source ~/.zsh/exports.zsh
[[ -f ~/.zsh/export-secret.zsh ]] && source ~/.zsh/export-secret.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh
[[ -f ~/.zsh/znap.zsh ]] && source ~/.zsh/znap.zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/gcp.zsh ]] && source ~/.zsh/gcp.zsh

# ASDF settings
. "$HOME/.asdf/asdf.sh"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit


source <(kubectl completion zsh)

autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/nomad nomad

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
