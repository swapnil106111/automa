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

sudo rm -rf /home/$1/.kolibri/test/

sudo bash script_1.sh $1

cd ..

sudo chmod 777 automation-script/

sudo rm -rf automation-script/

sudo service nginx restart


