#!/usr/bin/env bash

green_log() { echo -e "\033[0;32m[+] ${1}\033[0m"; }

red_log() {
	echo >&2 -e "\033[0;31m[-] ${1}\033[0m"
	if [ "${GITHUB_REPOSITORY-}" ]; then echo -e "::error::utils.sh [-] ${1}\n"; fi
}

abort() {
	red_log "ABORT: ${1-}"
	exit 1
}

# check if value is positive number
is_positive_integer() {
    case $1 in
        ''|*[!0-9]*)
            # this is not a number
            return 1
            ;;
        *)
            # this is a positive number
            return 0
            ;;
    esac
}

# check if $1 is a string
is_string() {
    case $1 in
        *[![:alnum:]]*)
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}
