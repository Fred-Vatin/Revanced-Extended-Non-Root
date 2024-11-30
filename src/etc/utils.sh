#!/bin/bash

echoOK() { echo -e "\033[0;32m[+] ${1}\033[0m"; }

echoErr() {
	echo >&2 -e "\033[0;31m[-] ${1}\033[0m"
	if [ "${GITHUB_REPOSITORY-}" ]; then echo -e "::error::utils.sh [-] ${1}\n"; fi
}

abort() {
	echoErr "ABORT: ${1-}"
	exit 1
}
