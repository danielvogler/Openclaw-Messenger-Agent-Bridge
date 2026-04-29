#!/usr/bin/env bash

set -e

echo "Configuring Mac to never sleep (requires sudo password)..."
sudo pmset -a sleep 0 displaysleep 10 disksleep 0 ttyskeepawake 1
echo "Mac sleep disabled! It will now run 24/7."
