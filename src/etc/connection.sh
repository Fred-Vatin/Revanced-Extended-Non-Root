#!/usr/bin/env bash

source ./src/etc/utils.sh

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
