# This doesn't seem to work....
# znap eval starship 'starship init zsh --print-full-init'
# znap prompt

##
# Load your plugins with `znap source`.
#
znap source marlonrichert/zsh-autocomplete
znap source marlonrichert/zsh-edit

# No special syntax is needed to configure plugins. Just use normal Zsh
# statements:

znap source marlonrichert/zsh-hist
bindkey '^[q' push-line-or-edit
bindkey -r '^Q' '^[Q'

ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting


##
# Cache the output of slow commands with `znap eval`.
#

# If the first arg is a repo, then the command will run inside it. Plus,
# whenever you update a repo with `znap pull`, its eval cache gets regenerated
# automatically.
znap eval trapd00r/LS_COLORS "$( whence -a dircolors gdircolors ) -b LS_COLORS"

# The cache gets regenerated, too, when the eval command has changed. For
# example, here we include a variable. So, the cache gets invalidated whenever
# this variable has changed.
znap source marlonrichert/zcolors
znap eval   marlonrichert/zcolors "zcolors ${(q)LS_COLORS}"

# Combine `znap eval` with `curl` or `wget` to download, cache and source
# individual files:
znap eval omz-git 'curl -fsSL \
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh'

############################################################################################################################################
# ZSH Configs
############################################################################################################################################
# To get rid of annoying part in prompt
DEFAULT_USER=`whoami`
DISABLE_MAGIC_FUNCTIONS=true

#### gopass configuration
export GPG_TTY=$(tty)

# removing stupid pasting thing
zstyle ':urlglobber' url-other-schema
