#!/usr/bin/env bash

set -e

echo "Adding Docker to Mac Login Items to start on boot..."
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Docker", path: "/Applications/Docker.app", hidden: true}'
echo "Docker will now launch automatically when the Mac turns on and you log in."
