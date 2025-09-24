#!/bin/bash
set -x
set -e

REPO_DIR="/home/ec2-user/sample.daytrader7"
REPO_URL="https://github.com/narayan1989-bais/sample.daytrader7.git"
PORT=9082

## Kill process if running
PID=$(lsof -ti tcp:$PORT)
if [ -n "$PID" ]; then
  echo "Killing process on port $PORT with PID $PID"
  kill -9 $PID
  sleep 2
fi

# Remove existing repo directory
if [ -d "$REPO_DIR" ]; then
  echo "Removing existing directory $REPO_DIR"
  rm -rf "$REPO_DIR"
fi

# Clone fresh repo
echo "Cloning repository"
git clone "$REPO_URL" "$REPO_DIR"

# Build the project
cd "$REPO_DIR"
mvn clean install

# Start Liberty server
cd daytrader-ee7
nohup mvn liberty:run > liberty.log 2>&1 &

echo "Server started successfully."
