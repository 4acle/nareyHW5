#!/bin/bash
# Description: A Bash script to control User LED3 on the BeagleBone.
# It accepts command line arguments to turn the LED on, off, or blink it n times.
# Usage: bash led-hw5.sh [on|off|blink n|flash|status]
# Example Invocation: 
#   To blink the LED 5 times: ./led-hw5.sh blink 5
#   To turn the LED off: ./led-hw5.sh off
#   To flash the LED: sudo ./led-hw5.sh flash
#   To check LED status: ./led-hw5.sh status

LED3_PATH=/sys/class/leds/beaglebone:green:usr3

# Example bash function
function removeTrigger
{
  echo "none" >> "$LED3_PATH/trigger"
}

echo "Starting the LED Bash Script"
if [ $# -eq 0 ]; then
  echo "There are no arguments. Usage is:"
  echo -e " bashLED Command \n  where command is one of "
  echo -e "   on, off, flash or status  \n e.g. bashLED on "
  exit 2
fi
echo "The LED Command that was passed is: $1"
if [ "$1" == "on" ]; then
  echo "Turning the LED on"
  removeTrigger
  echo "1" >> "$LED3_PATH/brightness"
elif [ "$1" == "off" ]; then
  echo "Turning the LED off"
  removeTrigger
  echo "0" >> "$LED3_PATH/brightness"
elif [ "$1" == "blink" ]; then
  if [ $# -eq 2 ]; then
    echo "Blinking the LED $2 times"
    removeTrigger
    for ((i=0; i<$2; i++)); do
      echo "1" >> "$LED3_PATH/brightness"
      sleep 1
      echo "0" >> "$LED3_PATH/brightness"
      sleep 1
    done
  else
    echo "Usage: ./led-hw5.sh blink [n], where n is the number of blinks."
    exit 2
  fi
elif [ "$1" == "flash" ]; then
  echo "Flashing the LED"
  removeTrigger
  echo "timer" >> "$LED3_PATH/trigger"
  sleep 1
  echo "100" >> "$LED3_PATH/delay_off"
  echo "100" >> "$LED3_PATH/delay_on"
elif [ "$1" == "status" ]; then
  cat "$LED3_PATH/trigger";
fi
echo "End of the LED Bash Script"
