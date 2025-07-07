# If you come from bash you might have to change your $PATH.
export PATH=$(pyenv root)/shims:/opt/homebrew/bin:/usr/local/bin:~/.cargo/bin:${KREW_ROOT:-$HOME/.krew}/bin:/Library/TeX/texbin:/usr/local/opt/asdf/bin:~/go/bin:$HOME/google-cloud-sdk/bin:$PATH

# Kubernetes
export KUBECONFIG=$HOME/.kube/config:$HOME/.kube/k3s-config

#### GIT ####
if [ -f ~/.ssh/github_ed25519 ]
then
  export GIT_SSH_COMMAND='ssh -i ~/.ssh/github_ed25519'
else
  export GIT_SSH_COMMAND='ssh'
fi

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height=40% --preview="cat {}" --preview-window=right:60%:wrap'

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Kubernetes
export KUBE_EDITOR="vim"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

