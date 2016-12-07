#!/bin/bash
SESSION=$USER
tmux -2 new-session -d -s $SESSION

tmux split-window -h
tmux select-pane -t 0
tmux send-keys "cd Projects/relevant; sh -c 'npm run build:dev:client' " C-m
tmux select-pane -t 1
tmux send-keys "cd Projects/relevant; HOT_RAILS_PORT=3500 npm run hot-assets " C-m

tmux new-window -t $SESSION:2 -n "DEV"
tmux select-window -t   $SESSION:2
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "cd Projects/relevant" C-m
tmux send-keys "REACT_ON_RAILS_ENV=HOT bin/rails s -b 0.0.0.0" C-m
tmux select-pane -t 1
tmux send-keys "cd Projects/relevant" ENTER

tmux -2 attach-session -t $SESSION
