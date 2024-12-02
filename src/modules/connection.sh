#!/usr/bin/env bash
######################################################
# LOAD HELPER SCRIPT
HELPER_PATH="./src/utils/helper.sh"
HELPER_MISSING="utils.sh can not be loaded"

if [ ! -f $HELPER_PATH ]; then
    echo -e "::error::ABORT-$HELPER_MISSING\n"
    exit 1
fi

source $HELPER_PATH

# -- check if HELPER is loaded --
if ! declare -f green_log > /dev/null; then
  HELPER_ERROR="$HELPER_PATH exists but can not be loaded"
  echo >&2 -e "\033[0;31m[-] $HELPER_ERROR\033[0m"
  if [ "${GITHUB_REPOSITORY-}" ]; then 
    echo -e "::error::ABORT-$HELPER_ERROR\n"
    exit 1
  fi
fi

green_log "$HELPER_PATH loaded successfully"
######################################################

# -- check if utils is loaded --
if declare -f green_log > /dev/null; then
  green_log "utils.sh has been loaded"
else
  message="utils.sh can not be loaded"
  echo >&2 -e "\033[0;31m[-] $message\033[0m"
  if [ "${GITHUB_REPOSITORY-}" ]; then 
    echo -e "::error::ABORT-$message\n"
    exit 1
  fi
fi

# Check github connection stable or not:
check_connection() {
	wget -q $(curl -s "https://api.github.com/repos/revanced/revanced-patches/releases/tags/v4.17.0" | jq -r '.assets[] | select(.name == "patches.json") | .browser_download_url') || rm -f "patches.json"
	if [ -f patches.json ]; then
		echo "internet_error=0" >> $GITHUB_OUTPUT
		green_log "Github connection OK"
		rm -f "patches.json"
	else
		echo "internet_error=1" >> $GITHUB_OUTPUT
		red_log "Github connection not stable!"
	fi
}
check_connection
