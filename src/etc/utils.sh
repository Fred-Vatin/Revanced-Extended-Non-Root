#!/usr/bin/env bash

green_log() {
	if [ "${GITHUB_REPOSITORY-}" ]; then
		echo -e "::notice::\033[0;32m${1}\033[0m\n"
	else
		echo -e "\033[0;32m[+] ${1}\033[0m"
	fi
}

blue_log() { echo -e "\033[0;34m ${1}\033[0m"; }

warn_log() {
	if [ "${GITHUB_REPOSITORY-}" ]; then
		echo -e "::warning::\033[0;33m${1}\033[0m\n"
	else
		echo -e "\033[0;33m[!] ${1}\033[0m"
	fi
}

error_log() {
	echo >&2 -e "\033[0;31m[-] ${1}\033[0m"
	if [ "${GITHUB_REPOSITORY-}" ]; then echo -e "::error::\033[0;31m${1}\033[0m\n"; fi
}

abort() {
	error_log "ABORT: ${1-}"
	exit 1
}

# check if value is positive number
is_positive_integer() {
	case $1 in
	'' | *[!0-9]*)
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
