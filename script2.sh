#!/bin/bash

# test if package is installed.
# if installed it will return 0, if not return 1

dpkg -s samba > /dev/null 2>&1
INSTALLED=$?

if [ $INSTALLED == 0 ]
    then
    echo "Samba was already installed, skipping to next step"
    else
    sudo apt-get update && sudo apt -y install samba > /dev/null 2>&1

#if package was not installed successfully, we will get 1 as exit code
    SUCCESS=$?
    if [ $SUCCESS != 0 ]
        then
        echo "Error occured when installing Samba"
        else
        echo "Samba was successfully installed"
        exit 1
    fi
fi

#check if folder exists
test -d $1 > /dev/null 2>&1
RESULT=$

if [ $RESULT == 0 ]
    then
    echo "Folder exists"
    else
    echo "Folder does not exist"
fi
