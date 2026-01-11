#!/bin/bash

# Development script: runs the game and restarts on file changes
# Usage: ./dev.sh

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
GAME_PID=""

# Find Godot executable
find_godot() {
    if command -v godot &> /dev/null; then
        echo "godot"
    elif [ -f "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
        echo "/Applications/Godot.app/Contents/MacOS/Godot"
    else
        echo ""
    fi
}

GODOT=$(find_godot)

if [ -z "$GODOT" ]; then
    echo "Error: Godot not found. Install via 'brew install --cask godot' or download from godotengine.org"
    exit 1
fi

echo "Using Godot: $GODOT"
echo "Watching: $PROJECT_DIR"
echo "Press Ctrl+C to stop"
echo ""

# Cleanup on exit
cleanup() {
    echo ""
    echo "Stopping..."
    if [ -n "$GAME_PID" ] && kill -0 "$GAME_PID" 2>/dev/null; then
        kill "$GAME_PID" 2>/dev/null
    fi
    exit 0
}

trap cleanup SIGINT SIGTERM

# Start the game
start_game() {
    echo "[$(date +%H:%M:%S)] Starting game..."
    "$GODOT" --path "$PROJECT_DIR" &
    GAME_PID=$!
}

# Stop the game
stop_game() {
    if [ -n "$GAME_PID" ] && kill -0 "$GAME_PID" 2>/dev/null; then
        echo "[$(date +%H:%M:%S)] Stopping game..."
        kill "$GAME_PID" 2>/dev/null
        wait "$GAME_PID" 2>/dev/null
    fi
}

# Get modification time of watched files
get_mtime() {
    find "$PROJECT_DIR" \( -name "*.gd" -o -name "*.tscn" -o -name "*.tres" \) \
        -not -path "*/.git/*" \
        -exec stat -f %m {} \; 2>/dev/null | sort -n | tail -1
}

# Initial start
start_game
LAST_MTIME=$(get_mtime)

# Watch loop
while true; do
    sleep 1

    # Check if game crashed
    if ! kill -0 "$GAME_PID" 2>/dev/null; then
        echo "[$(date +%H:%M:%S)] Game exited, restarting..."
        start_game
        LAST_MTIME=$(get_mtime)
        continue
    fi

    # Check for file changes
    CURRENT_MTIME=$(get_mtime)
    if [ "$CURRENT_MTIME" != "$LAST_MTIME" ]; then
        echo "[$(date +%H:%M:%S)] File change detected, restarting..."
        stop_game
        sleep 0.5
        start_game
        LAST_MTIME=$CURRENT_MTIME
    fi
done
