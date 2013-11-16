#!/usr/bin/env bash

DIR=$(dirname $0)
cd $DIR
source util.sh
setup

connected
while [ $? -eq 1 ]
do
  connect
  connected
done

git pull
./stoplight.sh
