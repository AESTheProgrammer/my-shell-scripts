#!/bin/bash
#
# This script automate process of disabling or removing a user.
#

readonly ARCHIVE_DIR='./archives'

disable_user() {
    # This function disable the user.
    USER_NAME=${1}
    chage -E 0 ${USER_NAME}

    if [[ ${?} -ne 0 ]]
    then
        echo "Couldn't disable the user ${USER_NAME}" >&2
        exit 1
    fi
    
    echo "User ${USER_NAME} is disabled."
    return 0
}

usage() {
    # This function print the usage of this script.
    echo "Usage: ${0} [-dra] USER [USER]..." >&2
    echo 'Remove or disable an account.' >&2
    echo '  -d          delete account instead of disabling them.' >&2
    echo '  -r          Removes the home directory associated with accounts(s).' >&2
    echo '  -a          Creates an archive of the home directory associated with the account(s).' >&2

    exit 1
}

create_archive() {
    # This function create a archive file from user home dir.
    local USER_NAME="${1}"
    # Checks if the directory exist.
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
        echo "Creating ${ARCHIVE_DIR} directory"
        mkdir -p ${ARCHIVE_DIR}
        if [[ ${?} -ne 0 ]]
            then 
            echo "The archive directory ${ARCHIVE_DIR} could not be created." >&2
            exit 1
        fi
    fi
        
    tar -zcvf "${USER_NAME}.tar.gz" "/home/${USER_NAME}"
    if [[ "${?}" -ne 0 ]]
    then
        echo "Couldn't create archive file for user ${USER_NAME}." >&2
        exit 1
    fi
    echo "Created archive file for user ${USER_NAME}."
    mv "${USER_NAME}.tar.gz" "${ARCHIVE_DIR}/${USER_NAME}.tar.gz"

    return 0
}

delete_user() {
    # This function remove a user.
    local USER_NAME=${1}
    local REMOVE_OPTION=${2}

    userdel ${REMOVE_OPTION} ${USER_NAME}
    if [[ "${?}" -ne 0 ]]
    then
        echo "User ${USER_NAME} was not deleted." >&2
        exit 1
    fi
    echo "Deleted user ${USER_NAME}."

    return 0
}

# Check if the script is ran as root
if [[ "${UID}" -ne 0 ]]
then
    echo 'Please run with sudo or as root.' >&2
    exit 1
fi

# Make sure atleast 1 argument is given
if [[ "${#}" -eq 0 ]]
then 
    usage
fi

# Manage the options.
while getopts dra OPTION
do
    case ${OPTION} in
        d) DELETE='true' ;;
        r) REMOVE_HOME='-r' ;;
        a) CREATE_ARCHIVE='true' ;;
        ?) usage ;;
    esac
done

# Removing options while remaining argumnets. 
# Make sure if any argument is left.
shift "$(( OPTIND - 1 ))"

if [[ "${#}" -eq 0  ]]
then
    usage
fi

for USER_NAME in "${@}"
do
    if [[ $(id -u ${USER_NAME}) -le 1000 ]]
    then 
        echo "Cannot process on user ${USER_NAME}.(UID less than or equal to 1000.)" >&2
        continue
    fi

    if [[ "${CREATE_ARCHIVE}" = 'true' ]]
    then
        create_archive $USER_NAME
    fi

    if [[ "${DELETE}" = 'true' ]]
    then
        delete_user $USER_NAME $REMOVE_HOME
    else 
        disable_user ${USER_NAME}
    fi
done

exit 0
