#!/usr/bin/env bash
source ./src/etc/utils.sh

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

# Setup Cloudflare warp for bypass cloudflare anti ddos APKMirror:
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
sudo apt-get update && sudo apt-get install cloudflare-warp -y
sudo systemctl enable --now warp-svc.service
warp-cli --accept-tos registration new
warp-cli --accept-tos mode warp
warp-cli --accept-tos connect
sleep 3
output=$(wget -qO- https://www.cloudflare.com/cdn-cgi/trace | awk -F'=' '/ip|colo|warp/ {printf "%s: %s\n", $1, $2}')
echo "$output"
warp=$(echo "$output" | awk -F':' '/warp/ {print $2}')
if [ "$warp" = " on" ]; then
  green_log "Successful install Cloudflare Warp"
else
  red_log "Can't install Cloudflare Warp"
fi
