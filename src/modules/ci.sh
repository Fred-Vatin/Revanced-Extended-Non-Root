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
# Check new patch:
get_date() {
	json=$(wget -qO- "https://api.github.com/repos/$1/releases")
	case "$2" in
		latest)
			updated_at=$(echo "$json" | jq -r 'first(.[] | select(.prerelease == false) | .assets[] | select(.name | test("'$3'")) | .updated_at)')
			;;
		prerelease)
			updated_at=$(echo "$json" | jq -r 'first(.[] | select(.prerelease == true) | .assets[] | select(.name | test("'$3'")) | .updated_at)')
			;;
		*)
			updated_at=$(echo "$json" | jq -r 'first(.[] | select(.tag_name == "'$2'") | .assets[] | select(.name | test("'$3'")) | .updated_at)')
			;;
	esac
	echo "$updated_at"
}

checker(){
	local date1 date2 date1_sec date1_sec repo=$1 ur_repo=$repository check=$3
	date1=$(get_date "$repo" "$2" "^(.*\\\.jar|.*\\\.rvp)$")
	date2=$(get_date "$ur_repo" "all" "$check")
	date1_sec=$(date -d "$date1" +%s)
	date2_sec=$(date -d "$date2" +%s)
	if [ -z "$date2" ] || [ "$date1_sec" -gt "$date2_sec" ]; then
		echo "new_patch=1" >> $GITHUB_OUTPUT
		green_log "New patch, building..."
	elif [ "$date1_sec" -lt "$date2_sec" ]; then
		echo "new_patch=0" >> $GITHUB_OUTPUT
		green_log "Old patch, not build."
	fi
}
checker $1 $2 $3
