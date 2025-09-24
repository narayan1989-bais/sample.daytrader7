#!/bin/bash

APP_DIR="/home/ec2-user/sample.daytrader7"
PORT=9082

cd "$APP_DIR"

# Build your app on EC2
mvn clean install

# Restart Liberty server
PID=$(lsof -ti tcp:$PORT)
if [ ! -z "$PID" ]; then
  kill -9 $PID
  sleep 2
fi

cd "$APP_DIR/daytrader-ee7"
nohup mvn liberty:run > liberty.log 2>&1 &

echo "Deployment complete."
