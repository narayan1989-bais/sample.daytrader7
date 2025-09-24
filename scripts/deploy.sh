#!/bin/bash
set -x

echo "Starting deploy script..." > /home/ec2-user/deploy.log
date >> /home/ec2-user/deploy.log

# Remove old repo
rm -rf /home/ec2-user/sample.daytrader7
echo "Removed old repo" >> /home/ec2-user/deploy.log

# Clone fresh repo
git clone https://github.com/narayan1989-bais/sample.daytrader7.git /home/ec2-user/sample.daytrader7
echo "Cloned repo" >> /home/ec2-user/deploy.log

# Build project
cd /home/ec2-user/sample.daytrader7
mvn clean install >> /home/ec2-user/deploy.log 2>&1

## Start Liberty server
cd daytrader-ee7
nohup mvn liberty:run > /home/ec2-user/liberty.log 2>&1 &

echo "Liberty started" >> /home/ec2-user/deploy.log
