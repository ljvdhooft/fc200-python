#!/bin/sh
# Installs the hub as a launchd agent for the current user. Run it yourself.
set -eu
hub_dir=$(cd "$(dirname "$0")/.." && pwd)
dest="$HOME/Library/LaunchAgents/nl.fc200.hub.plist"
mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
sed -e "s|@HUB_DIR@|$hub_dir|g" -e "s|@HOME@|$HOME|g" "$hub_dir/launchd/nl.fc200.hub.plist" > "$dest"
launchctl bootout "gui/$(id -u)" "$dest" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$dest"
echo "installed $dest"
