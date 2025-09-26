#!/bin/bash

LIBERTYLOG=liberty.log

echo "Cloning repo"
git clone https://github.com/narayan1989-bais/sample.daytrader7.git
if [ $? -ne 0 ]; then
  echo "Git clone failed!"
  exit 1
fi

echo "Running mvn install"
cd sample.daytrader7
mvn install
if [ $? -ne 0 ]; then
  echo "Maven install failed!"
  exit 1
fi

echo "Changing directory to daytrader-ee7 and starting Liberty server"
cd daytrader-ee7 || { echo "Failed to cd to daytrader-ee7"; exit 1; }
mvn liberty:run > $LIBERTYLOG 2>&1 &

echo "Liberty server started, logs at $LIBERTYLOG"
