#!/bin/bash


exec > /home/ec2-user/deploy-debug.log 2>&1
set -x

echo "Starting deploy.sh script at $(date)"

LIBERTYLOG=/home/ec2-user/liberty.log
APP_DIR=/home/ec2-user/sample.daytrader7

echo "Starting deployment..." > $LIBERTYLOG
date >> $LIBERTYLOG

# Remove any previous deployment (optional – you can let CodeDeploy overwrite too)
if [ -d "$APP_DIR" ]; then
  echo "Removing existing application directory..." >> $LIBERTYLOG
  rm -rf "$APP_DIR"
fi

# CodeDeploy will copy new files now – no need to clone manually

# Wait until CodeDeploy places files (this script runs AfterInstall, so it should be ready)
if [ ! -f "$APP_DIR/pom.xml" ]; then
  echo "ERROR: Application folder missing or deployment failed!" >> $LIBERTYLOG
  exit 1
fi

echo "Building project..." >> $LIBERTYLOG
cd "$APP_DIR" || exit 1
mvn install >> $LIBERTYLOG 2>&1
if [ $? -ne 0 ]; then
  echo "Maven build failed!" >> $LIBERTYLOG
  exit 1
fi

echo "Starting Liberty server..." >> $LIBERTYLOG
cd "$APP_DIR/daytrader-ee7" || exit 1
nohup mvn liberty:run >> $LIBERTYLOG 2>&1 &

echo "Liberty server started at $(date)" >> $LIBERTYLOG
