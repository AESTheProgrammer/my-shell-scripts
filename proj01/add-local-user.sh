#!/bin/bash

FILE='./users-list.txt'
# Ask for the authentication
read -p 'Enter the username to create: ' USER_NAME
read -p 'Enter name of the person who this account is for: ' COMMENT
read -p 'Enter the password to use for the account: ' PASSWORD

# Checks the file is executed by root or using sudo.
if [[ "${UID}" -ne 0 ]]then;
    echo 'Please run with sudo or as root'
    exit -1
fi

# Checks if the given username is valid
if [[ `grep "$USER_NAME" $FILE` ]];then
    echo 'Username is already in use.'
    exit -1
elif [[ ! $USER_NAME =~ ^[a-z_]([a-z0-9_-]{2,31}|[a-z0-9_-]{2,30}\$)$ ]];then
    echo 'Username format is not valid.'
    exit -1
fi

# Creat the account  
# Check if the account was built
useradd -c "${COMMENT}" -m ${USER_NAME}
if [[ "${?}" -ne 0 ]];then
    echo 'Account could not be set'
    exit -1
fi

# Take the password from the user
# Check if the password was taken properly
(echo ${PASSWORD}; echo ${PASSWORD}) | passwd ${USER_NAME}
if [[ "${?}" -ne 0 ]];then
    echo 'Account couldnot be set'
    exit -1
fi

# Display the username and password and hostname to the new user
echo '-------------------------------------'
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"
echo '-------------------------------------'

passwd -e ${USER_NAME}
echo ${USER_NAME} >> usernames_list.txt
