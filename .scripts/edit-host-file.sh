#!/bin/bash

if grep -Fxq "## Begin Local Host ##" /etc/hosts;
then
    sudo sed -e "/## Begin Local Host ##/,/## End Local Host ##/d" -i .backup /etc/hosts
    echo "Old Values Erased"
fi

sudo echo $'\n\n## Begin Local Host ##\n::1 wordpress.local #Local Site\n127.0.0.1 wordpress.local #Local Site\n::1 phpmyadmin.local #Local Site\n127.0.0.1 phpmyadmin.local #Local Site\n## End Local Host ##' >> /etc/hosts