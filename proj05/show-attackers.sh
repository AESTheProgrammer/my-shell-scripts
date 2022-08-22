#!/bin/bash

# This script look for failed login and figure out who was 
# who was trying to hack into.

FILE="${1}"

usage() {
    echo 
}

# Checks if atleast 1 argument is given.
#if [[ ${#} -le 1 ]]
#then
#    usage
#    exit 1
#fi

# Checks if the file exist.
if [[ ! -e ${FILE} ]]
then
    echo "Cannot open the file ${FILE}." >&2
    exit 1
fi

# Saves all fails. 
ALL_LOG_FAILS="$(cat /var/log/auth.log | grep 'Failed password' | cut -d ' ' -f 10 | uniq -c)"

echo $ALL_LOG_FAILS


# Prints lines with more than 10 attempts.
echo "Count,IP,Location"
while IFS= $(read line)
do
    if [[ "$(echo $line | cut -d ' ' -f 1)" -gt 10 ]]
    then
        echo "${line}$(echo $line | cut -d ' ' -f 2 | geoiplookup)"
    fi
done <<< $ALL_LOG_FAILS
