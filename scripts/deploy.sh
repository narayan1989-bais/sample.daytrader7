#!/bin/bash
set -e  # Exit on error

REPO_DIR="/home/ec2-user/sample.daytrader7"
REPO_URL="https://github.com/narayan1989-bais/sample.daytrader7.git"

# Remove folder if exists
if [ -d "$REPO_DIR" ]; then
  echo "Removing existing folder $REPO_DIR"
  rm -rf "$REPO_DIR"
fi

# Clone fresh repo
echo "Cloning repository..."
git clone "$REPO_URL" "$REPO_DIR"

# Build the project
echo "Building project with Maven..."
cd "$REPO_DIR"
mvn clean install

# Kill any process on port 9082
PORT=9082
PID=$(lsof -ti tcp:$PORT)
if [ -n "$PID" ]; then
  echo "Killing process on port $PORT with PID $PID"
  kill -9 "$PID"
  sleep 2
fi

# Start Liberty server
echo "Starting Liberty server..."
cd "$REPO_DIR/daytrader-ee7"
nohup mvn liberty:run > liberty.log 2>&1 &

echo "Deployment completed successfully."
