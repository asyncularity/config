## /* $Id: .zshrc,v 1.24 2003/03/12 10:05:57 dmorris Exp $ */

###################
## ENV Variables ##
###################
export RPROMPT=$'[%{\e[1;34m%}%n%{\e[0m%}|%U%m%u]'
export PROMPT=$'%{\e[0;32m%}%~%{\e[0m%} # '
export EDITOR=emacs
export PAGER=less
export ZBEEP='\e[?5h\e[?5l'
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
export DIRSTACKSIZE=16
export NO_AT_BRIDGE=1
export GOPATH=${HOME}/go
export GOBIN=${GOPATH}/bin

path=($path /usr/local/bin /bin /usr/bin)
path=($path /usr/local/sbin /sbin /usr/sbin)
path=(/usr/local/go/bin $path)
path=($GOBIN $path)
path=($path ~/.local/bin)
path=($path ~/anaconda3/bin)

ulimit -c unlimited
umask 002
###################
## ENV Variables ##
###################


##################
## key binds    ##
##################
### Allow 8 bit keys
stty pass8 # && bindkey -m
[[ $TERM = "xterm" ]] && stty pass8 # && bindkey -me

bindkey -s "^o"   '; myls \r'
bindkey -s "^b"   'cd ..\r'
bindkey -s "^f"   'popd\r'
#bindkey -s "^N^e" 'cd /etc\r'
#bindkey  "^N" undefined-key
#bindkey  "^S" undefined-key
bindkey  "^p"   undo
bindkey  "^j"   end-of-line
bindkey  "^u"   forward-char
bindkey  "^[u"  forward-word
bindkey  "^e"   backward-char
bindkey  "^[e"  backward-word
bindkey  "^n^z" describe-key-briefly
bindkey  "^w"   transpose-chars
bindkey  "^[w"  transpose-words
##################
## key binds    ##
##################


#########################
## aliases & functions ##
#########################
ls --color 1>/dev/null 2>&1
if [ $? -eq 0 ] ; then
    alias myls="ls -ldh --color *(N/) ; ls -lh --color *(^/) 2> /dev/null"
else
    alias myls="ls -ldh *(N/) ; ls -lh *(^/) 2> /dev/null"
fi
alias grep="egrep"
alias g="egrep"
alias x="xargs"
alias f="find"
alias h='history'
alias la="ls -al --color"
alias df='df -h'
alias du1='du -hs *(/)' ## du with depth 1
alias ssh='ssh -X -A -o "StrictHostKeyChecking=no"'
alias al="alias|less"
alias more="less"
alias monoff="/bin/sh -c \"sleep 1 && xset dpms force off\""
alias bindings='egrep "bindkey" ~/.zshrc| egrep -v "grep|stty" | \more'
alias noupper='rename "y/A-Z/a-z/"'
alias nospace='rename "s/ /_/g"'
alias nowrap='tput rmam'
alias wrap='tput smam'
alias startx="ssh-agent startx"
alias v1='export TERM=vt100'
alias v2='export TERM=vt220'
alias vx='export TERM=xterm-color'
alias "deb-apts"="apt-cache search"
alias "deb-aptsh"="apt-cache show $@"
alias "deb-pkg-size"="dpkg-query -W --showformat='\${Installed-Size} \${Package}\n' | sort -n -r"
alias delchar="stty -a | grep ' erase' | sed 's/.* erase = \(.?*\); .*/\1/'"
alias fixhistory="cd ~/ ; mv .zsh_history .zsh_history_bad ; strings .zsh_history_bad > .zsh_history"

if [ -f "`which dog 2>&1`" ]; then
    alias cat="dog"
fi

if [ -f "`which netcat 2>&1`" ]; then
    alias nc="netcat"
fi

evaluate-command() {
  # If param is a function, returns the array:
  #    ( "param() { actualDefinition }", param )
  # else, return an array containing the command + options, for instance
  #    ( ls -F --color )
  # The result is returned via $reply
  local command=$1
  if whence -v $command | grep -q "function" ; then
    # join function def. lines with ' ;'
    functionDef=${(pj: ;:)${(f)"$(whence -f $command)"}}
    # add a call to that function in the end
    reply="$functionDef ; $command"
  else # alias, or binary: put all elements in an array
    set -A reply `whence $command`
  fi
}

s() { # somewhat smarter sudo
  local debug=off
  [[ $1 = -d ]] && local debug=on && shift
  evaluate-command $1 # result is returned in $reply
  shift
  set -A command $reply "\"$@\"" # add *quoted* args
  set -A expandedCommand $~command # nice trick do expansion on an array
  unset reply
  [[ $debug = on ]] && print -l -- "$expandedCommand[@]" && print =================
  sudo zsh -c "$expandedCommand"
}

nth ()     { awk "{print \$${1}}"; }
e-clean () { find ${1:-.} -regex '.*~$' -o -regex '.*/\.?#.*' | xargs -i{} \rm -f "{}" }
mfind ()   { find ${2:-.} -type f -exec grep -iH ${1} "{}" \; 2> /dev/null }
topall ()  { top `ps aux | grep $1 | grep -v grep | awk '{print "-p " $2}'` }
capwords (){ rename 's/\b([a-z])/\u$1/g' $* }
sshrm ()   { sed -i "/$1/d" ~/.ssh/known_hosts }
psg ()     { ps aux | \grep -i "$1" | \grep -v "grep -i $1" }

upd ()     { 
    if [ -f ~/.ssh/authorized_keys ] ; then
        cp ~/.ssh/authorized_keys  ~/.ssh/authorized_keys.back
    fi
    if [ -f ~/.ssh/authorized_keys2 ] ; then
        cp ~/.ssh/authorized_keys2 ~/.ssh/authorized_keys2.back
    fi
    rsync -rlptvz --exclude '.git' -e ssh dmorris@metaloft.com:~/config/ ~/
    if [ ! diff ~/.ssh/auuthorized_keys ~/.ssh/authorized_keys.back >/dev/null 2>&1 ] ; then
      cat ~/.ssh/authorized_keys.back >> ~/.ssh/authorized_keys
    fi 
    if [ ! diff ~/.ssh/authorized_keys2 ~/.ssh/authorized_keys2.back >/dev/null 2>&1 ] ; then
      cat ~/.ssh/authorized_keys2.back >> ~/.ssh/authorized_keys2
    fi 
}

find () {
	dir=${1:-.}
	[ $# -gt 0 ] && shift
	local printArg
	[[ "$@" = *-print* ]] || printArg="-print"
	command find "$dir" -path '*/.git' -prune -o $@ $printArg
}

zsrc () {
	autoload -U zrecompile
	[ -f ~/.zshrc ] && zrecompile -p ~/.zshrc
	[ -f ~/.zcompdump ] && zrecompile -p ~/.zcompdump
	[ -f ~/.zshrc.zwc.old ] && rm -f ~/.zshrc.zwc.old
	[ -f ~/.zcompdump.zwc.old ] && rm -f ~/.zcompdump.zwc.old
	source ~/.zshrc
}

backupHistory() {
    local backupDir=~/.zsh_hist/`hostname`
    local backupFileBasename="zsh_history"
    local backupFileBasePath=${backupDir}/${backupFileBasename}
    local backupFile=${backupFileBasePath}-`date --iso-8601=seconds`
    # save a copy
    mkdir -p $backupDir
    cp ~/.zsh_history ${backupFile}
    # now remove all but latest 5
    local -a files
    files=(`find ${backupDir} -name "${backupFileBasename}*" | sort`)
    rm -f $files[1,-6]
}

reload-ssh-agent() {
    local user=`whoami`
    local t_agent_pid="`ps -U $user | grep '[s]sh-agent' | awk '{print $1}'`"

    if [ -z "${t_agent_pid}" ]; then echo "no agent" ; return ; fi
    
    ## nothing to do 
    if [ "${SSH_AGENT_PID}x" = "${t_agent_pid}x" ]; then return ; fi

    ## Update the SSH_AUTH_SOCK
    local t_auth_sock=`find /tmp/ -maxdepth 2 -path '*ssh-*' -name 'agent.*' -user ${USER} 2>/dev/null | head -n 1`
    if [ -z "${t_auth_sock}" ]; then echo "no sock" ; return ; fi
    
    export SSH_AUTH_SOCK=${t_auth_sock}
    export SSH_AGENT_PID=${t_agent_pid}
    echo "updated (agent pid: ${t_agent_pid})"
}

start-ssh-agent() {
    ssh-agent
    reload-ssh-agent
}

if [ -x "`which lesspipe 2>&1`" ] ; then
    eval $(lesspipe)
fi

#########################
## aliases & functions ##
#########################





###############
## options   ##
###############


autoload -U compinit
compinit -C
zmodload -i zsh/complist
autoload -U insert-files
zle -N insert-files
autoload -Uz vcs_info

#
# Unwanted options
#
setopt NO_printexitvalue
setopt NO_correct
setopt NO_correct_all
setopt NO_menu_complete
setopt NO_auto_menu
setopt NO_auto_remove_slash
setopt NO_auto_cd
setopt NO_auto_menu
setopt NO_beep
setopt NO_check_jobs
setopt NO_list_rows_first
setopt NO_menucomplete
setopt NO_multios
setopt NO_nomatch
setopt NO_notify
setopt NO_print_exit_value
setopt NO_pushd_minus
setopt NO_singlelinezle
#setopt NO_clobber

setopt clobber
setopt noflowcontrol
setopt no_beep
setopt auto_cd
setopt nopromptcr
setopt prompt_subst
setopt auto_list
setopt nohup
setopt dvorak
setopt nocheckjobs
setopt ignore_eof
setopt auto_name_dirs
setopt auto_pushd
setopt autolist
#setopt bare_glob_qual
setopt cdable_vars
setopt complete_in_word
setopt extended_glob
setopt glob_complete
setopt hash_cmds
setopt hash_dirs
setopt ksh_option_print
setopt list_packed
setopt mark_dirs
setopt nohup
unsetopt path_dirs
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home
setopt rc_expand_param
setopt rc_expandparam
setopt rc_quotes
setopt autopushd 
setopt pushdminus 
setopt pushdsilent 
setopt pushdtohome 
setopt pushdignoredups

#
# History Options
#
#setopt hist_allow_clobber 
#setopt hist_reduce_blanks
#setopt share_history
#setopt append_history
#setopt hist_ignore_all_dups 
#setopt extended_history
#setopt hist_allow_clobber
#setopt hist_ignore_space
#setopt NO_hist_save_no_dups
#setopt hist_reduce_blanks
#setopt hist_verify
#setopt append_history
#setopt inc_append_history
setopt append_history
setopt extended_history
setopt hist_allow_clobber
setopt hist_ignore_space
setopt NO_hist_save_no_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history

###############
## options   ##
###############

##################
## completion   ##
##################
compdef _sudo s
#compdef '_alternative _command_names _aliases _functions' s

# Some functions, like _apt and _dpkg, are very slow. add caching 
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# Prevent CVS files/directories from being completed
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
# Hostnames from history
otherHosts=(`awk '/;(connect|run|ssh) [a-z][^@]+$/ {print $3}' ~/.zsh_history | /bin/grep -vE (esg|ps-|c-5) | sort -u` $_hosts)
zstyle '*' hosts $otherHosts
#  Ignore completion functions for commands you don't have:
zstyle ':completion:*:functions' ignored-patterns '_*' 
#  With commands like `rm' it's annoying if one gets offered the same
#  filename again even if it is already on the command line.  
zstyle ':completion:*:rm:*' ignore-line yes 
precmd() {
    vcs_info
}

# Fix for NIS auto completion
zmodload -i zsh/parameter
_comp_setup+=$'\ntypeset -a userdirs'

##################
## completion   ##
##################


# Xauthority mess
if [ $USER = "dmorris" ] && [ -f ~/.Xauthority ] ; then
    chmod 666 ~/.Xauthority
    export XAUTHORITY=~/.Xauthority
fi

# Naming the window
case $TERM in
  screen)
    preexec() { print -Pn "\ek%n@%m $1\e\\" }
    precmd() { print -Pn "\ek%n@%m\e\\" }
    ;;
  vt*)
    ;;
  *)
    ;;
esac

if [ "`delchar`" != '^?' ] ; then
    echo "WARNING: bad delete key: `delchar`";
fi

if [ "$SSH_AUTH_SOCKx" = "x" ] ; then
    reload-ssh-agent
elif [ ! -e "$SSH_AUTH_SOCK" ] ; then 
    reload-ssh-agent
fi

DEFSHELL="`getent passwd $LOGNAME | cut -d: -f7`"
if ! echo $DEFSHELL | grep -q zsh ; then
    echo "Do you wish to change the default shell to zsh? y/n"
    read se
    case $se in
        [Yy]* )
            echo "Enter your password to change shell."
            chsh -s `which zsh`;;
        * )
    esac
fi
