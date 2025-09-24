#!/bin/bash

WORKDIR=/home/ec2-user/sample.daytrader7

# Remove existing folder if it exists
if [ -d "$WORKDIR" ]; then
  echo "Removing existing directory $WORKDIR"
  rm -rf "$WORKDIR"
fi

# Clone fresh repo
echo "Cloning repository"
git clone https://github.com/narayan1989-bais/sample.daytrader7.git "$WORKDIR"

cd "$WORKDIR"

echo "Running Maven install"
#mvn clean install

# Kill any process on port 9082
PORT=9082
PID=$(lsof -ti tcp:$PORT)
if [ ! -z "$PID" ]; then
  echo "Killing PID $PID"
  kill -9 $PID
  sleep 2
fi

echo "Starting Liberty server"
cd daytrader-ee7
nohup mvn liberty:run > liberty.log 2>&1 &
