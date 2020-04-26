#!/bin/bash

if [ $UID != 0 ]; then
  echo "Please run this script using sudo or as root. Aborting"
  exit 1
fi

echo "Insert your guest tools media and press enter"
read kp

if [ ! -f /dev/cdrom ]; then
  echo "No media found! Aborting."
  exit 1
fi

mount -o exec /dev/cdrom
cd /media/cdrom0/
echo "Starting install of Guest tools in non-interactive mode"
Linux/install.sh -n

if [ $? != 0 ]; then
  echo "Something bad happened. Did not succeed!"
  exit 1
fi

echo "Press enter to reboot the system. Continue with step 2 script."
reboot
