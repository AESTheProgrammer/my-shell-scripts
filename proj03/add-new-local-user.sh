#!/bin/bash

# Make sure it is executed as root or using sudo command.
echo "$(date) --------------------------------- $(date)" 1>&2
if [[ "${UID}" -ne 0 ]]
then
    echo 'Please run with sudo or as root' 1>&2
    exit -1
fi

# Make sure at least supply one arugment.
NUMBER_OF_PARAMETERS="${#}"
if [[ "${NUMBER_OF_PARAMETERS}" -eq 0 ]]
then
    echo "Usage: ${0} USER_NAME [USER_NAME]..." 1>&2 
    exit 1
fi

# Set comment and username.
USER_NAME=${1}
COUNT=1
shift
COMMENT="${@}"

# Creat the accout.
# check if the account was built.
useradd -c ${COMMENT} -m ${USER_NAME} &> /dev/null
if [[ "${?}" -ne 0 ]]
then
    echo 'Account was not created.' 1>&2
    exit 1
fi

# Creat a random password and set it to new user.
TOKENS='~!@#$%^&*)('
SPECIAL_CHARACTER=$(echo ${TOKENS} | fold -w1 | shuf | head -c1)
PASSWORD="${SPECIAL_CHARACTER}$(echo ${RANDOM}$(date +%s%N)${RANDOM} | sha256sum | head -c10)"

(echo ${PASSWORD}; echo ${PASSWORD}) | passwd ${USERNAME}

# Ask for new password next the user login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username and password and hostname to the new user.
echo "$(date) --------------------------------- $(date)" 1>&2 ./log.log
echo '------------------------------'
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Comment: ${COMMENT}"
echo "Host: ${HOSTNAME}"
echo '------------------------------'
