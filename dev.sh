#!/usr/bin/env bash
set -euo pipefail

PORT=${1:-1313}

# Initial build
echo "Building forest..."
forester build forest.toml

# Start server in background
echo "Starting server on http://localhost:$PORT"
cd output && python3 -m http.server "$PORT" &
SERVER_PID=$!
cd ..

# Cleanup on exit
trap "kill $SERVER_PID 2>/dev/null || true" EXIT

# Watch for changes and rebuild
echo "Watching for changes... (Ctrl+C to stop)"
fswatch -o trees/ assets/ forest.toml | while read -r; do
  echo "Rebuilding..."
  forester build forest.toml
  echo "Done."
done
