# Enable colors and change prompt:
autoload -U colors && colors	# Load colors

# Find and set branch name var if in git repository.
function git_branch_name() {
	branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
	if [[ $branch == "" ]];
	then
		:
	else
		echo "${branch} "
	fi
}

# Enable substitution in the prompt.
setopt prompt_subst

# Setup prompt (doing it through a function is required for git branch to work)
function prompt() {
	BASE="%F{147}%n@%m %f[%F{219}%~%f] %F{34}$(git_branch_name)%f"
	case $TERM in
		xterm*|xfce4-terminal*)
		PS1="$BASE✨ ";;
	*)
		PS1="$BASE%# ";;
	esac

}
precmd_functions+=(prompt)

setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in config directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zsh_history

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Load syntax highlighting; should be last.
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
