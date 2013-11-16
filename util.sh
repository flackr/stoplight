#!/usr/bin/env bash

RED=4
YELLOW=17
GREEN=22

function setup()
{
  echo $RED > /sys/class/gpio/export
  echo $YELLOW > /sys/class/gpio/export
  echo $GREEN > /sys/class/gpio/export

  echo out > /sys/class/gpio/gpio$RED/direction
  echo out > /sys/class/gpio/gpio$YELLOW/direction
  echo out > /sys/class/gpio/gpio$GREEN/direction
  echo 0 > /sys/class/gpio/gpio$RED/value
  echo 0 > /sys/class/gpio/gpio$YELLOW/value
  echo 0 > /sys/class/gpio/gpio$GREEN/value
}

function light()
{
  echo $2 > /sys/class/gpio/gpio$1/value
}

function connected {
  ERROR=0
  # Verify we have a correct IP.
  if [ `ifconfig wlan0 | grep -c "192.168"` -eq 0 ]
  then
    ERROR=1
  fi

  # And verify that a DNS server has been set.
  if [ `cat /etc/resolv.conf | grep -c nameserver` -eq 0 ]
  then
    ERROR=1
  fi
  return $ERROR
}

function connect {
  light $RED 0
  light $YELLOW 0
  light $GREEN 0
  (while [ true ]; do light $YELLOW 0; sleep 1; light $YELLOW 1; sleep 1; done) &
  BLINKPID=$!
  ifconfig wlan0 down
  ifconfig wlan0 up
  iwconfig wlan0 essid GoogleGuest
  sleep 15
  dhcpcd wlan0
  sleep 10
  kill $BLINKPID
  light $YELLOW 0
}

