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
if ! declare -f green_log >/dev/null; then
	HELPER_ERROR="$HELPER_PATH exists but can not be loaded"
	echo >&2 -e "\033[0;31m[-] $HELPER_ERROR\033[0m"
	if [ "${GITHUB_REPOSITORY-}" ]; then
		echo -e "::error::ABORT-$HELPER_ERROR\n"
		exit 1
	fi
fi

green_log "$HELPER_PATH loaded successfully"
######################################################

# display help function
show_help() {
	echo ""
	blue_log "Usage: $0 [--check <number>] [--set]"
	blue_log "Use one or the other option."
	echo ""
	blue_log "--check"
	blue_log "- type: variable containing a number > 0."
	blue_log "- Returns a boolean and if false, abort workflow"
	echo ""
	blue_log "--set"
	blue_log "- type: boolean, default: true"
	blue_log "- Returns the next_tag in \$GITHUB_OUTPUT"
}

# Use getopt to process args
OPTIONS=$(getopt -o hc: --long help,check:,set -- "$@")
if [ $? -ne 0 ]; then
	echo "OPTIONS ERROR"
	show_help
	abort "Unvalid argument"
fi

eval set -- "$OPTIONS"

# init vars
CHECK=""
SET=false

# read options
while true; do
	case "$1" in
	-h | --help)
		show_help
		abort "setTag.sh needs one of these arguments above"
		;;
	--check)
		# if is empty or null
		if [ -z "$2" ]; then
			show_help
			abort "--check is empty. It requires a positiver integer argument."
		fi
		if is_positive_integer "$2"; then
			CHECK=$2
			echo "check_tag=$CHECK" >>$GITHUB_OUTPUT

			green_log "Check next_tag OK with value: $CHECK"
			exit 0
		else
			show_help
			abort "--check requires a non-negative integer argument."
		fi
		;;
	--set)
		SET=true
		shift
		;;
	--)
		shift
		break
		;;
	*)
		echo "Unknown option: $1"
		show_help
		abort "setTag.sh needs one of these arguments above"
		;;
	esac
done

# when option --set is used
if [ "$SET" = true ]; then
	echo "[--set] option is used"

	# Get last tag from the repo
	TAG=$(gh release list -L 1 | awk -F '\t' '{print $3}')
	if [ -z "$TAG" ]; then TAG=0; fi

	# Calculer le prochain tag
	NEXT_TAG=$((TAG + 1))

	# Afficher et enregistrer le prochain tag
	green_log "NEXT_TAG=$NEXT_TAG"
	echo "NEXT_TAG=$NEXT_TAG" >>$GITHUB_ENV
	echo "next_tag=$NEXT_TAG" >>$GITHUB_OUTPUT
fi
