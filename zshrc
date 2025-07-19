# Path
export PATH=/opt/local/bin:/opt/local/sbin:$PATH


ZIM_HOME=~/.zim
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh


# Use macOS keychain for SSH key
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
fi
# Add key to keychain (one-time setup)
if ! ssh-add -l > /dev/null 2>&1; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 > /dev/null 2>&1
fi


# Proxy settings for http and https traffic via SOCKS5H for all applications
export http_proxy=socks5h://127.0.0.1:7890
export https_proxy=socks5h://127.0.0.1:7890
export HTTP_PROXY=socks5h://127.0.0.1:7890 # Uppercase for some apps
export HTTPS_PROXY=socks5h://127.0.0.1:7890 # Uppercase for some apps


source ~/fzf.zsh


# Change the current working directory when exiting Yazi.
# Use y to start, and press q to quit. If don't want to change directory, press Q to quit.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


# Set up aliases
alias python=python3
alias pip=pip3
alias pip3='uv pip'

alias ios-backups='ls -la ~/Library/Application\ Support/MobileSync/Backup/ && du -sh ~/Library/Application\ Support/MobileSync/Backup/*'

alias pydoc="uv run python -m pydoc"

alias activate='source .venv/bin/activate'


# Set Neovim as the default editor for command-line tools
export EDITOR="/opt/local/bin/nvim"
export VISUAL="$EDITOR"


# uv path added automatically
. "$HOME/.local/bin/env"


# Initialize Starship prompt
eval "$(starship init zsh)"

# Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
    zle end-of-line
fi
}
zle -N _sgpt_zsh
bindkey ^l _sgpt_zsh
# Shell-GPT integration ZSH v0.2
