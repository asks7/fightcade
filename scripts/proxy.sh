#!/bin/sh

cd "${0%/*}"

[ -z $1 ] && exit 1

export SERVER=${1}
export PORT=${2}

[ -f $HOME/fightcade.log ] && rm $HOME/fightcade*.log

[ "${2}" = "" ] && PORT="1080"

export URL="${SERVER}:${PORT}"

# proxy
unset ALL_PROXY NO_PROXY
unset all_proxy http_proxy https_proxy socks_proxy no_proxy

# socksify config
export UPNP_IGD
export SOCKS_SERVER=${URL}
export SOCKS_DIRECTROUTE_FALLBACK=yes

echo "Socks: ${SERVER}:${PORT}"

socksify ./main.py 2>/dev/null &

