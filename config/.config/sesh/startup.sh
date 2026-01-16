#!/usr/bin/env bash

# Sesh startup script - creates multiple windows in a new session
# This runs when connecting to a session via sesh

echo "Sesh startup script running..." >> /tmp/sesh-startup.log
date >> /tmp/sesh-startup.log

# Get current session name
SESSION=$(tmux display-message -p '#S')
echo "Session name: $SESSION" >> /tmp/sesh-startup.log

# Window 1: Claude Code
tmux rename-window -t $SESSION:1 "claude"
tmux send-keys -t $SESSION:1 "claude" C-m

# Window 2: Neovim
tmux new-window -t $SESSION:2 -n "editor"
tmux send-keys -t $SESSION:2 "nvim ." C-m

# Window 3: Terminal
tmux new-window -t $SESSION:3 -n "terminal"

# Select the first window (Claude Code)
tmux select-window -t $SESSION:1

echo "Sesh startup script completed" >> /tmp/sesh-startup.log
