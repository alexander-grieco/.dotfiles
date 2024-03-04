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

# Terraform
alias tf="terraform"

# GCP
alias gcc="gcloud container clusters"
