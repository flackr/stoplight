#!/usr/bin/env bash

source util.sh
setup

sleep 60

while [ true ]
do
  curl -s "http://chromium-build.appspot.com/p/chromium-status/current" > /tmp/treestatus.txt
  if [ $? -gt 0 ]
  then
    light $RED 1
    light $YELLOW 1
    light $GREEN 0

    # On an error, verify still connected.
    connected
    if [ $? -eq 1 ]
    then
      connect
    fi
  else
    if [ `grep -c "div class=\"status-message closed" /tmp/treestatus.txt` -gt 0 ]
    then
      light $RED 1
      light $YELLOW 0
      light $GREEN 0
    elif [ `grep -c "div class=\"status-message throttled" /tmp/treestatus.txt` -gt 0 ]
    then
      light $RED 0
      light $YELLOW 1
      light $GREEN 0
    elif [ `grep -c "div class=\"status-message open" /tmp/treestatus.txt` -gt 0 ]
    then
      light $RED 0
      light $YELLOW 0
      light $GREEN 1
    else
      light $RED 1
      light $YELLOW 0
      light $GREEN 1
    fi
  fi
  sleep 10
done

