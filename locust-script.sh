#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or use sudo" 
   exit 1
fi

if [ "$#" -ne 1 ]
then
  echo "You need to pass the logged in username."
  exit 1
fi

git clone https://github.com/swapnil106111/automation-script.git

cd automation-script/

sudo mkdir /home/$1/.kolibri/test

sudo cp index.html /home/$1/.kolibri/test/

sudo bash script_2.sh $1

sudo service nginx restart


