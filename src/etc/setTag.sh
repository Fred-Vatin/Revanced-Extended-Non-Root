#!/bin/bash
source ./utils.sh

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
