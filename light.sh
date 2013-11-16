#!/usr/bin/env bash

source util.sh
PREVIOUS=$RED

function light()
{
  echo 0 > /sys/class/gpio/gpio$PREVIOUS/value
  PREVIOUS=$1
  echo 1 > /sys/class/gpio/gpio$PREVIOUS/value
}

setup

if [ $# -lt 1 ]
then
  echo "Run $0 [red|yellow|green]"
  exit 1
fi

if [[ "$1" == "red" ]]
then
  light $RED
elif [[ "$1" == "yellow" ]]
then
  light $YELLOW
elif [[ "$1" == "green" ]]
then
  light $GREEN
else
  echo "Unknown color $1, valid colors are red, green, yellow."
fi
