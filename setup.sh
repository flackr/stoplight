#!/usr/bin/env bash

# Schedule regular reboot around midnight
HOURS=$[24-10#`date '+%H'`]
SECS=$[$HOURS*60*60]
if [ $DEBUG ]; then
  echo "Schedule reboot in $HOURS hours."
else
  (sleep $SECS && reboot) &
fi

DIR=$(dirname $0)
cd $DIR
source util.sh
setup

# Wait for connection
connected
while [ $? -eq 1 ]
do
  connected
done

git pull
if [ $? -eq 0 ]
then
  for i in {1..2}
  do
    light $GREEN 1
    sleep 0.5
    light $GREEN 0
    sleep 0.5
  done
else
  for i in {1..2}
  do
    light $RED 1
    sleep 0.5
    light $RED 0
    sleep 0.5
  done
fi
./stoplight.sh
