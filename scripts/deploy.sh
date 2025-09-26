#!/bin/bash

LOGFILE=/home/ec2-user/deploy.log
LIBERTYLOG=/home/ec2-user/liberty.log

echo "Starting deploy script..." > $LOGFILE
date >> $LOGFILE

# Remove old repo
rm -rf /home/ec2-user/sample.daytrader7
echo "Removed old repo" >> $LOGFILE

# Clone fresh repo as ec2-user
sudo -u ec2-user git clone https://github.com/narayan1989-bais/sample.daytrader7.git /home/ec2-user/sample.daytrader7
if [ $? -ne 0 ]; then
  echo "Git clone failed!" >> $LOGFILE
  exit 1
fi
echo "Cloned repo" >> $LOGFILE

# Build entire project (runs mvn install on root)
cd /home/ec2-user/sample.daytrader7 || exit 1
sudo -u ec2-user mvn install >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
  echo "Maven install failed!" >> $LOGFILE
  exit 1
fi
echo "Maven install succeeded" >> $LOGFILE

# Kill any running Liberty server
sudo -u ec2-user pkill -f "mvn liberty:run" || true
echo "Killed any existing Liberty server" >> $LOGFILE

# Start Liberty server in daytrader-ee7 folder
cd /home/ec2-user/sample.daytrader7/daytrader-ee7 || exit 1
sudo -u ec2-user nohup mvn liberty:run > $LIBERTYLOG 2>&1 &
echo "Liberty server started" >> $LOGFILE
