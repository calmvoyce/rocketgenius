#!/bin/bash

if [ -f /etc/hosts.backup ]; then
	sudo rm /etc/hosts.backup
fi

if grep -Fxq "## Begin Local Host ##" /etc/hosts;
then
    sudo sed -e "/## Begin Local Host ##/,/## End Local Host ##/d" -i .backup /etc/hosts
    echo "Old Values Erased"
fi

sudo cat hosts >> /etc/hosts