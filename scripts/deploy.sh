#!/bin/bash

cd /home/ec2-user/sample.daytrader7

echo "Pulling latest changes"
git pull origin master

echo "Running Maven install"
#mvn install

# Kill any process on 9082
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
