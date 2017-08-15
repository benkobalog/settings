export PS1="\[$(tput bold)\]\[\033[38;5;47m\]\u@\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;134m\]\w\\n\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]==>  \[$(tput sgr0)\]"


set-title () {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

mcd () {
    mkdir -p $1
    cd $1
}
