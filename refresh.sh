if [ -n "$TMUX" ]; then
  function refresh {
    export $(tmux show-environment | grep "^SSH_AUTH_SOCK")
    export $(tmux show-environment | grep "^DISPLAY")
    export $(tmux show-environment | grep "^SSH_TTY")
    export $(tmux show-environment | grep "^SSH_CLIENT")
  }
else
  function refresh { }
fi
