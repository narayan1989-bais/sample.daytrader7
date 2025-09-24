#!/bin/bash
set -e

# Remove existing folder if it exists
if [ -d "sample.daytrader7" ]; then
  rm -rf sample.daytrader7
fi

git clone https://github.com/narayan1989-bais/sample.daytrader7.git
cd sample.daytrader7
mvn clean install

cd daytrader-ee7
nohup mvn liberty:run > liberty.log 2>&1 &
echo "Liberty server started in the background."
