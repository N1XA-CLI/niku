# Disable greeting
set -U fish_greeting ""

# Starship prompt
if status is-interactive
    set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
    starship init fish | source
end

# Format man pages
set -x MANROFFOPT -c
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Source fish_profile if exists
if test -f $HOME/.fish_profile
    source $HOME/.fish_profile
end

# Node.js (bundled ICU)
set -gx PATH /opt/node/bin $PATH

# PATH additions
for p in $HOME/.local/bin $HOME/Applications/depot_tools
    if test -d $p
        if not contains -- $p $PATH
            set -p PATH $p
        end
    end
end

#####################
### Key Bindings  ###
#####################
# Enable vim bindings
set -U fish_key_bindings fish_vi_key_bindings

# Always block cursor (disable cursor switching)
function fish_mode_prompt
    echo -n ''
end

# !! and !$ support
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

bind ! __history_previous_command
bind '$' __history_previous_command_arguments

##################
### Functions  ###
##################
# Better history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (string trim -r -c '/' $argv[1])
        set to $argv[2]
        command cp -r $from $to
    else
        command cp $argv
    end
end

# mkcd DIR
function mkcd
    mkdir -p $argv[1]; and cd $argv[1]
end

# Extract archives
function extract
    set file $argv[1]
    if test -f $file
        switch $file
            case '*.tar.bz2'
                tar xjf $file
            case '*.tar.gz'
                tar xzf $file
            case '*.bz2'
                bunzip2 $file
            case '*.rar'
                unrar x $file
            case '*.gz'
                gunzip $file
            case '*.tar'
                tar xvf $file
            case '*.tbz2'
                tar xjf $file
            case '*.tgz'
                tar xzf $file
            case '*.zip'
                unzip $file
            case '*.Z'
                uncompress $file
            case '*.7z'
                7z x $file
            case '*'
                echo "'$file' cannot be extracted via extract()"
        end
    else
        echo "'$file' is not a valid file"
    end
end

##################
### Aliases    ###
##################
# ls replacements
alias ls='eza --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.='eza -a | grep -e "^\."'

# System helpers
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Arch helpers
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'
alias pamcan='pacman'

# Shortcuts
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias jctl="journalctl -p 3 -xb"
alias ff='fastfetch'
alias py='python'
alias q='exit'
alias h='history'
alias cd='z '
alias fd='zi '
alias cpkg="sudo pacman -Rns $(pacman -Qtdq)"
alias cdep="yay -Si " #used to check dependence of any package
# clear the screen and no scroll history
#alias clear="printf '\033[2J\033[3J\033[1;1H'"
alias clear="clear && printf '\e[3J'" 

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcl='git clone'
alias gl='git log --oneline'
alias gd='git diff'
alias gpush='git push'
alias gpull='git pull'

# System control
alias wifi='nmtui'
alias i='yay -Sy --needed --noconfirm '
alias u='notify-send "Upgrading System" & yay -Syu --noconfirm '
alias s='yay -Ss'
alias lsearch='yay -Qs'
alias rc='yay -Rns'
alias r='yay -R --noconfirm '
alias shutdown='systemctl poweroff'
alias du='dust'
alias clean-dns='sudo systemd-resolve --flush-caches'

###################
### Environment ###
###################
set -gx SHELL_CONFIG_DIR $HOME/.config
#set -gx GOPATH $HOME/go
#set -gx PATH $GOPATH/bin $PATH
#set -gx CARGO_HOME $HOME/.cargo
set -gx PATH $CARGO_HOME/bin $PATH
zoxide init fish | source
