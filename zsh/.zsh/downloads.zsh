# find out which distribution we are running on
LFILE="/etc/os-release"
if [[ -f $LFILE ]]; then
  _distro="linux"
else
  _distro="macos"
fi


# Download Fonts
[[ -d ~/.config/envman/ ]] ||
  curl -sS https://webi.sh/nerdfont | sh && source ~/.config/envman/PATH.env

# Download Tmux plugin manager
[[ -d ~/.tmux/plugins/tpm ]] ||
  git clone --depth 1 -- \
    git@github.com:tmux-plugins/tpm.git ~/.tmux/plugins/tpm

# Download Catppuccin Theme
[[ -d ~/.utils/catppuccin/iterm ]] ||
  git clone --depth 1 -- \
    git@github.com:catppuccin/iterm.git ~/.utils/catppuccin/iterm/

# Install Starship if not already installed
if ! [ -x "$(command -v starship)" ]; then
  curl -sS https://starship.rs/install.sh | sh
fi

# Download Znap, if it's not there yet.
[[ -f ~/.utils/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.utils/zsh-snap
##
# Source Znap at the start of your .zshrc file.
#
source ~/.utils/zsh-snap/znap.zsh

