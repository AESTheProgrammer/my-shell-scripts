#!/bin/bash

# Redirect STDOUT to a file.
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

# Redirect STDIN to a program
read LINE < ${FILE}
echo "LINE constains: ${LINE}"

# Redirect STDOUT to a file, overwriting the file.
head -n3 /etc/passwd > ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDOUT to a file, appending to the file.
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDIN to a program, using FD 0.
read LINE 0< ${FILE}
echo '------------'
echo "LINE Contains: ${LINE}"

# Redirect STDOUT to a file using FD 1, overwriting the file.
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDERR to a file using FD 2.
ERR_FILE="/tmp/data.err"
head -n3 /etc/passwd /fakefile 2> ${ERR_FILE}
echo "Conetents of ${ERR_FILE}:"
cat ${ERR_FILE}

# Redirect STDERR and STDOUT to a file.
head -n3 /etc/passwd /fakefile 2> ${ERR_FILE} 1> ${FILE}
cat ${ERR_FILE} ${FILE}

# Redirect STDERR and STDOUT to the same file.
echo '---------------------------------------1'
head -n3 /etc/passwd /fakefile |& cat -n # Pipe both STDOUT and STDERR.
echo '---------------------------------------2'
echo "$(head -n3 /etc/passwd /fakefile) ${?}" 1> out.out 2>&1 | cat -n
echo '---------------------------------------3'
head -n3 /etc/passwd /fakefile | cat -n # Pipe only STDOUT.

# Clean up!
rm ${FILE}
rm ${ERR_FILE}

