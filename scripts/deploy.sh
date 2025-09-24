#!/bin/bash
set -x
set -e

REPO_DIR="/home/ec2-user/sample.daytrader7"
REPO_URL="https://github.com/narayan1989-bais/sample.daytrader7.git"

# Remove existing directory if it exists
if [ -d "$REPO_DIR" ]; then
  echo "Removing existing directory $REPO_DIR"
  rm -rf "$REPO_DIR"
fi

# Clone fresh repo
echo "Cloning repository"
git clone "$REPO_URL" "$REPO_DIR"

# Run Maven install
echo "Running Maven install"
cd "$REPO_DIR"
#mvn install

# Kill any process on port 9082
PORT=9082
PID=$(lsof -ti tcp:$PORT)
if [ ! -z "$PID" ]; then
  echo "Killing process on port $PORT with PID $PID"
  kill -9 $PID
  sleep 2
fi

# Start Liberty server
echo "Starting Liberty server"
cd daytrader-ee7
nohup mvn liberty:run > liberty.log 2>&1 &
