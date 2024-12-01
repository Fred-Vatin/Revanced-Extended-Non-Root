#!/usr/bin/env bash
source ./src/etc/utils.sh

# -- check if utils is loaded --
if declare -f green_log > /dev/null; then
  green_log "utils.sh has been loaded"
else
  message="utils.sh can not be loaded"
  echo >&2 -e "\033[0;31m[-] $message\033[0m"
  if [ "${GITHUB_REPOSITORY-}" ]; then 
    echo -e "::error::$message\n"
  fi
fi

# Vérifier si un tag courant est passé en paramètre
CURRENT_TAG=$1

# Obtenir le dernier tag de GitHub
TAG=$(gh release list -L 1 | awk -F '\t' '{print $3}')
if [ -z "$TAG" ]; then TAG=$CURRENT_TAG; fi

# Calculer le prochain tag
NEXT_TAG=$((TAG + 1))

# Afficher et enregistrer le prochain tag
green_log "NEXT_TAG=$NEXT_TAG"
echo "NEXT_TAG=$NEXT_TAG" >> $GITHUB_ENV
echo "next_tag=$NEXT_TAG" >> $GITHUB_OUTPUT
