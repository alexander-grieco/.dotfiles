# Tasty bind-key for tmux-sessionizer
bindkey -s ^f "tmux-sessionizer\n"

if [[ $_distro == "macos" ]]; then
  alias ls="gls --color --group-directories-first"
  alias cdd="cd ~/Documents/B_Product_Development/"
else
  alias ls="ls --color --group-directories-first"
fi

alias python="python3"
alias ll="ls -lhaG"
alias c="clear"
alias sb="source ~/.zshrc"
alias vb="vim ~/.zshrc"
alias ddd="cd $HOME/dapper"

# Vim
alias vim="nvim"
alias vvb="cd ~/.config/nvim && vim ."
alias v="nvim"

# SSH
alias sshq="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Git
alias gm="git checkout main && git pull origin main --rebase"
alias gbr="git branch | grep -v \"main\" | xargs git branch -D"

# Kubernetes
alias k="kubectl"
alias kg="k get"
alias ke="k exec -it"
alias kd="k describe"
alias kl="k logs"
alias kex="k explain --recursive"
alias khelp="k api-resources"
alias k-="kubectx -"
alias kx="kubectx"

# Terraform
alias tf="terraform"

# GCP
alias gcc="gcloud container clusters"

# Dapper Specific
alias ips="kubectl port-forward svc/gips 8080:8080"
alias cips="curl http://localhost:8080/api/v1/projects"

# Special ssh
alias qssh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# zellij
alias zj="zellij"
