#!/bin/bash

# This script deletes a user.

# Run as root.
if [[ "${UID}" -ne 0 ]]
then
    echo 'Please run with sudo or as root.' >&2
    exit 1
fi

# Assume the first argument is the user to delete.
USER="${1}"

# Delete the user 
userdel -r ${USER} 

# Make sure the user got deleted.
if [[ "${?}" -ne 0 ]]
then
    echo "The account ${USER} was not deleted." >&2
    exit 1
fi

# Tell the user the account was deleted.
echo "The accout ${USER} was deleted."

exit 0
