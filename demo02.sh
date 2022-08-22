#!/bin/bash

echo "Your UID is ${UID}"

# `id -un` == $(id -un)
USER_NAME=$(id -un)
echo "Your username is ${USER_NAME}"

# Display if the user is the root user or not.
# Root is always assigned the UID of 0
if [[ "${UID}" -eq 0 ]]
then
    echo 'You are the root.'
else 
    echo 'You are not the root.'
fi
