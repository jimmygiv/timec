#!/bin/bash
splash='
 _______                    
 /_  __(_)___ ___  ___  _____
  / / / / __ `__ \/ _ \/ ___/
 / / / / / / / / /  __/ /__  
/_/ /_/_/ /_/ /_/\___/\___/ 
'
nc='\e[0m'
red='\e[0;31m'
green='\e[0;32m'
blue='\e[1;34m'

function color() {
 text=$1
 choice=$2
 if [[ $choice == "green" ]]; then printf "$green$text\n$nc"
 elif [[ $choice == "blue" ]]; then printf "$blue$text\n$nc"
 elif [[ $choice == "red" ]]; then printf "$red$text\n$nc"
 fi
}

color "$splash" "green"

#------------------------------------------------------CEHCK DEPENDENCIES
if [[ $(whoami) != "root" ]]; then
  echo "Needs to be root to setup."
  exit
fi

if [[ ! $(which python3) ]]; then
  read -p "[*] Python3 not installed. Install now? (y/n)" resp
  if [[ $resp == "y" ]]; then
    apt install python3 -y
  else
    exit
  fi
fi

color "[*] Checking dependant files" "blue"

files=('timec.init' 'timec.py')
for file in ${files[@]}; do
  if [[ ! -f ./$file ]]; then
    color "[*] Missing $file. Please ensure it's in this directory" "red"
    exit
  fi
done
#------------------------------------------------------Setup service/repair/check
#Is already file
color "[*] Moving things into place"
if [[ -f /etc/init.d/timec ]]; then
  hash="0870cb9a57db53a74dc10fe4160f6e9b"
  genhash=$(md5sum /etc/init.d/timec | cut -d ' ' -f1)
  if [[ ! $genhash == $hash ]]; then read -p "Repair /etc/init.d/timec? (y/n) " resp

    if [[ $resp == "y" ]]; then 
      cp timec.init /etc/init.d/timec
    fi
  fi
else
  cp ./timec.init /etc/init.d/timec
fi

if [[ -f /usr/sbin/timec ]]; then
  hash="9af3ad15336dc0f3f22caf2e73d3f18f"
  if [[ ! $(md5sum /usr/sbin/timec | cut -d ' ' -f1) == $hash ]]; then
    read -p "Repair /usr/sbin/timec? (y/n)" resp
    if [[ $resp == "y" ]]; then cp timec.py /usr/sbin/timec; fi
  fi
else
  cp ./timec.py /usr/sbin/timec
fi

update-rc.d timec defaults
service timec start
#Service check
color "[*] Checking services" "blue"
service_check=$(systemctl status timec.service)

if [[ $service_check != *"running"* ]]; then systemctl status timec.service; fi


