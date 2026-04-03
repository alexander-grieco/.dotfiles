#!/usr/bin/env bash

# Sesh startup script - creates multiple windows in a new session
# This runs when connecting to a session via sesh

echo "Sesh startup script running..." >> /tmp/sesh-startup.log
date >> /tmp/sesh-startup.log

# Get current session name
SESSION=$(tmux display-message -p '#S')
echo "Session name: $SESSION" >> /tmp/sesh-startup.log

# Window 1: Neovim
tmux rename-window -t $SESSION:1 "editor"
tmux send-keys -t $SESSION:1 "nvim ." C-m

# Window 2: Terminal
tmux new-window -t $SESSION:2 -n "terminal"

# Select the editor window
tmux select-window -t $SESSION:1

echo "Sesh startup script completed" >> /tmp/sesh-startup.log
