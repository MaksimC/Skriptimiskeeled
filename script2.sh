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
    echo "Folder $1 requested to be created"
    else
    echo "!!!To-be created folder is not inserted. Restart script with correct arguments.
 1st argument - Folder. 2nd argument - Group"
    exit 1
fi

if [ -n "$2" ]
# test if command line arguments exists(not empty)
    then userGroup=$2
    echo "Group $2 requested to be created"
    else
    lines=$LINES
    echo "!!!To-be created group is not inserted. Restart script with correct arguments.
 1st argument - Folder. 2nd argument - Group"
    exit 1
fi

#check if folder exists
if ([ -d /var/data/$1 ])

    then
    echo "Folder already exists. Skipping to next step"
    else
    echo "Folder does not exist. Trying to create folder."
    sudo mkdir -p -v /var/data/$1 > /dev/null 2>&1
    if [ $? != 0 ]
        then
        echo 'Error when creating folder'
        exit 1
        else
        echo "Folder /var/data/$1 created"
    fi
fi

# tests if group exists
if (getent group $2)
    then
    echo "Group already exists. Skipping to next step"
    else
    echo "Group does not exist. Trying to create group."
    sudo groupadd $2 > /dev/null 2>&1
    if [ $? != 0 ]
        then
        echo "Error when creating group"
        exit 1
        else
        echo "Group $2 created"
    fi
fi

sudo cp /etc/samba/smb.conf /etc/samba/smb1.conf
sudo chmod 777 /etc/samba/smb1.conf
echo "Copy of 'smb.conf' is created with name 'smb1.conf'"

echo "[$1]" >> /etc/samba/smb1.conf
echo "comment=Labori kaust" >> /etc/samba/smb1.conf
echo "path=/var/data/$1" >> /etc/samba/smb1.conf
echo "writable=yes" >> /etc/samba/smb1.conf
echo "valid users=@$2" >> /etc/samba/smb1.conf
echo "force group=$2" >> /etc/samba/smb1.conf
echo "browsable=yes" >> /etc/samba/smb1.conf
echo "create mask=0664" >> /etc/samba/smb1.conf
echo "directory mask=0775" >> /etc/samba/smb1.conf

#test if new samba conf file is flawless
if(testparm -s /etc/samba/smb1.conf)
    then
    sudo cp /etc/samba/smb1.conf /etc/samba/smb.conf
    sudo /etc/init.d/smbd reload
    else
    echo "Error in smb1 conf file. Checkfor solutions."
fi
