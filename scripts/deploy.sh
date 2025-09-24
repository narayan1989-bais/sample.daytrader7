#!/bin/bash
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

# Build the project
echo "Building the project"
cd "$REPO_DIR"
mvn clean install

# Start Liberty server
echo "Starting Liberty server"
cd daytrader-ee7
nohup mvn liberty:run > liberty.log 2>&1 &

echo "Server started successfully."
