#!/bin/bash

REPO_DIR="/home/ec2-user/sample.daytrader7"
REPO_URL="https://github.com/narayan1989-bais/sample.daytrader7.git"

if [ ! -d "$REPO_DIR" ]; then
  git clone "$REPO_URL" "$REPO_DIR"
else
  cd "$REPO_DIR"
  git pull origin master
fi

# Build the project
cd "$REPO_DIR"
mvn clean install

# Kill process on port 9082 if running
PORT=9082
PID=$(lsof -ti tcp:$PORT)
if [ -n "$PID" ]; then
  kill -9 $PID
  sleep 2
fi

# Run Liberty server
cd "$REPO_DIR/daytrader-ee7"
nohup mvn liberty:run > liberty.log 2>&1 &

echo "Server started successfully."
