#!/bin/bash

# Display what the user typed on the commandline 
echo "This command will execute: ${0}"

# Display the path and the filename of the script
echo "You used $(dirname ${0}) as the path to the $(basename ${0}) script."

# Tell them how many arguments they passed in
# (Inside the script they are parameters, ouside they are arugments.)
NUMBER_OF_PARAMETERS="${#}"
echo "You supplied ${NUMBER_OF_PARAMETERS} argument(s) on the command line."

# Make sure they at least supply one argument.
if [[ "${NUMBER_OF_PARAMETERS}" -eq 0 ]];then
    echo "Usage: ${0} USER_NAME [USER_NAME]..."
    exit 1
fi

# Generate and diplay a password for each paraemter.
for USER_NAME in ${@}
do 
    PASSWORD="$(date +%s%N | sha256sum | head -c48)"
    echo "${USER_NAME}: ${PASSWORD}"
done
