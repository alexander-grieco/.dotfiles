# Misc aliases
alias python="python3"
alias ll="ls -lhaG"
alias c="clear"
alias sb="source ~/.zshrc"
alias vb="vim ~/.zshrc"
alias ddd="cd $HOME/dapper"
alias cdn="cd ~/Nextcloud/Development"

# Vim
alias vim="nvim"
alias vvb="cd ~/.config/nvim && vim ."
alias v="nvim"

# SSH
alias sshq="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Git
alias gm="git checkout main && git pull origin main --rebase"
alias gbr="git branch | grep -v \"main\" | xargs git branch -D"
# alias gc="git clone --bare"

# Obsidian
# alias no="cd ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Notes"
alias no="sesh connect ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Notes"

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

# zoxide
alias z="zoxide"

# Sesh settings
# Adds keybinding and function to run sesh
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ' \
      --header ' ^a all ^d kill ^f find ^t tmux ^g configs ^x zoxide ' \
      --bind 'tab:down,btab:up' \
      --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
      --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c)' \
      --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
      --bind 'ctrl-f:change-prompt(🔎  )+reload(find ~ ~/Documents/B_Product_Development ~/Nextcloud/Development ~/Nextcloud/Development/golang/alexander-grieco ~/dapper -mindepth 1 -maxdepth 1 -type d )' \
      --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
      --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list)'
    )
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '^f' sesh-sessions
bindkey -M vicmd '^f' sesh-sessions
bindkey -M viins '^f' sesh-sessions
# End Sesh settings

if [[ $_distro == "macos" ]]; then
  alias ls="gls --color --group-directories-first"
  # alias ls="ls"
  alias cdd="cd ~/Documents/B_Product_Development/"
else
  alias ls="ls --color --group-directories-first"
fi
