#!/usr/bin/env bash

source build.sh

set -euo pipefail

PROGRAM="tmux"

if ! command -v ${PROGRAM} >/dev/null; then
  echo "This script requires ${PROGRAM} to be installed and on your PATH ..."
  exit 1
fi

IP=127.0.0.1

ID0=138
ID1=202
ID2=10
ID3=74

PORT0=4710
PORT1=4711
PORT2=4712
PORT3=4713

tmux new -s peers -d
tmux send-keys -t peers "./build/peer $IP $PORT0 $ID0" C-m            # new DHT with node 138
tmux split-window -h -t peers
tmux send-keys -t peers "./build/peer $IP $PORT1 $ID1 $IP $PORT0" C-m # 202 sends join to 138
tmux select-pane -t :.+
tmux split-window -v -t peers
tmux send-keys -t peers "./build/peer $IP $PORT2 $ID2 $IP $PORT1" C-m #  10 sends join to 202
tmux select-pane -t :.+
tmux split-window -v -t peers
tmux send-keys -t peers "./build/peer $IP $PORT3 $ID3 $IP $PORT1" C-m #  74 sends join to 202
tmux split-window -h -t peers
tmux send-keys "sleep 10 && echo 'Hello World' | ./build/client $IP $PORT1 SET /cat.txt && sleep 1 && ./build/client $IP $PORT1 GET /cat.txt" C-m
tmux select-layout tiled
tmux attach -t peers
