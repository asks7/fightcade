#!/bin/bash

cd "${0%/*}"

[ -z $1 ] && exit 1

SERVER=${1}
PORT=${2}

[ "${2}" = "" ] && PORT="1080"

declare -x \
SOCKS_SERVER="${SERVER}:${PORT}" \
SOCKS_DIRECTROUTE_FALLBACK=yes

echo "Socks: ${SERVER}:${PORT}"

socksify python main.py 2>/dev/null

if [ $? = 0 ]
then
	rm $HOME/fightcade*.log* -v
	exit 0
fi

exit 1

