#!/bin/bash
set -e
exec > /home/ec2-user/deploy-debug.log 2>&1
echo "Starting deploy.sh at $(date)"

APP_DIR="/home/ec2-user/sample.daytrader7"
LIBERTY_LOG="$APP_DIR/liberty.log"

## Ensure ec2-user owns the app directory so we can delete it
if [ -d "$APP_DIR" ]; then
  echo "Changing ownership of $APP_DIR to ec2-user"
  sudo chown -R ec2-user:ec2-user "$APP_DIR"
  
  echo "Removing old application directory"
  rm -rf "$APP_DIR"
fi

echo "Cloning repository"
git clone https://github.com/narayan1989-bais/sample.daytrader7.git "$APP_DIR"

echo "Running Maven install"
cd "$APP_DIR"
mvn install

echo "Starting Liberty server"
cd daytrader-ee7
nohup mvn liberty:run > "$LIBERTY_LOG" 2>&1 &

echo "Deployment completed at $(date)"
