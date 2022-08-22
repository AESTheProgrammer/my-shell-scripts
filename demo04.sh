#!/bin/bash

# A radnom number as a password.
PASSWORD="${RANDOM}"
echo ${PASSWORD}

# Three random numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo ${PASSWORD}

# Use date and 2 random number 
PASSWORD="${RANDOM}$(date +%s)${RANDOM}"
echo ${PASSWORD}

# Use nano seconds date with 2 random number
PASSWORD="${RANDOM}$(date +%s%N)${RANDOM}"
echo ${PASSWORD}

# Use sha256 and date
PASSWORD="$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c20)"
echo ${PASSWORD}

# Append a special character to the password.
SPECIAL_CHARACTER=$(echo '~!@#$%^&*' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHARACTER}"

