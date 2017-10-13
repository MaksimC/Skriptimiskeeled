#!/bin/bash

# $1 - is the folder argument
# $2 - is the group argument

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


if [ -n "$1" ]
# test if command line arguments exists(not empty)
    then userFolder=$1
    echo "Folder $1 will be created"
    else
    echo "!!!To-be created folder is not inserted. Restart script with correct arguments.
 1st argument - Folder. 2nd argument - Group"
    exit 1
fi

if [ -n "$2" ]
# test if command line arguments exists(not empty)
    then userGroup=$2
    echo "Group $2 will be created"
    else
    lines=$LINES
    echo "!!!To-be created group is not inserted. Restart script with correct arguments.
 1st argument - Folder. 2nd argument - Group"
    exit 1
fi

#check if folder exists
test -d $1 > /dev/null 2>&1
RESULT=$

if [ $RESULT == 0 ]
    then
    echo "Folder already exists. Skipping to next step"
    else
    echo "Folder does not exist. Ttrying to create folder."
    sudo mkdir -p -v $1 > /dev/null 2>&1
    if [ $? != 0 ]
        then
        echo 'Error when creating folder'
        exit 1
    fi
fi

# tests if group exists
getent group | cut -d: -f1 | grep $2 > /dev/null 2>&1
RESULT=$

if [ $RESULT == 0 ]
    then
    echo "Group already exists. Skipping to next step"
    else
    echo "Group does not exist. Ttrying to create group."
    sudo addgroup $2 > /dev/null 2>&1
    if [ $? != 0 ]
		then
		echo 'Error when creating group'
		exit 1
	fi
fi

sudo cp /etc/samba/smb.conf /etc/samba/smb1.conf


