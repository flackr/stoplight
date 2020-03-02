#!/usr/bin/env bash

source util.sh

while [ true ]
do
  curl -s "https://ci.chromium.org/p/chromium/g/main/console" > /tmp/treestatus.txt
  if [ $? -gt 0 ]
  then
    # delay while flashing the amber
    for v in 1 2 3 4 5 ; do
      light $RED 1
      light $YELLOW 1
      light $GREEN 1
      
      sleep 1
     
      light $RED 1
      light $YELLOW 0
      light $GREEN 1
       
      sleep 1
    done
  else
    if [ `grep -c "tree-status-closed" /tmp/treestatus.txt` -gt 0 ]
    then
      light $RED 1
      light $YELLOW 0
      light $GREEN 0
    elif [ `grep -c "tree-status-throttled" /tmp/treestatus.txt` -gt 0 ]
    then
      light $RED 0
      light $YELLOW 1
      light $GREEN 0
    elif [ `grep -c "tree-status-open" /tmp/treestatus.txt` -gt 0 ]
    then
      light $RED 0
      light $YELLOW 0
      light $GREEN 1
    elif [ `grep -c "tree-status-maintenace" /tmp/treestatus.txt` -gt 0 ]
    then
      light $RED 1
      light $YELLOW 1
      light $GREEN 0
    else
      light $RED 1
      light $YELLOW 0
      light $GREEN 1
    fi
    sleep 10
  fi
done

