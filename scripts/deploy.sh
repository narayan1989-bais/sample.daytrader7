#!/bin/bash
set -e
set -x

REPO_DIR="/home/ec2-user/sample.daytrader7"
REPO_URL="https://github.com/narayan1989-bais/sample.daytrader7.git"

# Kill any process on port 9082
PORT=9082
PID=$(lsof -ti tcp:$PORT)
if [ -n "$PID" ]; then
  echo "Killing process on port $PORT with PID $PID"
  kill -9 $PID
  sleep 2
fi

# Remove existing directory if it exists
if [ -d "$REPO_DIR" ]; then
  echo "Removing existing directory $REPO_DIR"
  rm -rf "$REPO_DIR"
fi

# Clone fresh repo
echo "Cloning repository"
git clone "$REPO_URL" "$REPO_DIR"

# Fix permissions so ec2-user can write to all files/folders
sudo chown -R ec2-user:ec2-user "$REPO_DIR"
chmod -R u+rwX "$REPO_DIR"

# Remove all 'target' directories to clean stale build files
find "$REPO_DIR" -type d -name target -exec rm -rf {} +

# Build the project
echo "Running Maven clean install"
cd "$REPO_DIR"
mvn clean install

# Start Liberty server
echo "Starting Liberty server"
cd "$REPO_DIR/daytrader-ee7"
nohup mvn liberty:run > liberty.log 2>&1 &

echo "Server started successfully."
