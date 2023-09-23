#!/bin/bash

# This script generates a random password
# This user can set the password length with -l and add aspecial char with -s.
# Verbose mode can be enabled with -v.

usage(){
    echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
    echo 'Generate a random password.'
    echo '  -l LENGTH specify passwd length'
    echo '  -s Append a special char to the passwd'
    echo '  -v Increase verbosity'
    exit 1
}

log() {
    local MESSAGE="${@}";
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo "${MESSAGE}"
    fi
}

# Set a default password length
LENGTH=48

# vl:s Each letter represents a single option. If an option is followed by a colon (:), it indicates that the option requires an argument.
# so l option needs an argument
while getopts vl:s OPTION
do
    case ${OPTION} in
        v)
            VERBOSE='true'
            log 'Verbose mode on.'
            ;;
        l)
            LENGTH=${OPTARG}
            ;;
        s)
            USE_SPECIAL_CHAR='true'
            ;;
        ?)
            usage
            ;;
    esac
done


echo "number of args: ${#}"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"
# OPTIND: keep track of the index of the next command-line argument to be processed, used with getopts
echo "OPTIND: ${OPTIND}"

shift "$(( OPTIND -1 ))"

echo "number of args: ${#}"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

# if invalid input return 1
if [[ ${#} -ne 0 ]]
then 
    usage
fi


log 'Generating a password'
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# append apecial char if -s
if [[ "${USE_SPECIAL_CHAR}" = 'true' ]]
then  
    SPECIAL_CHAR=$(echo '!@#$%^&*()-+=' | fold -w1 | shuf | head -c1)
    PASSWORD="${PASSWORD}${SPECIAL_CHAR}"
fi

echo "Password: ${PASSWORD}"

exit 0
