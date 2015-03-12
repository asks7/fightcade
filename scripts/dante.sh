#!/bin/bash

cd "${0%/*}"

[ -z $1 ] && exit 1

SERVER=$1
PORT=$2

[ "${2}" = "" ] && PORT="8080"

# socksify config
declare -x HTTP_CONNECT_PROXY="http://${SERVER}:${PORT}"

echo "Proxy: ${HTTP_CONNECT_PROXY}"

socksify python main.py 2>/dev/null

if [ $? = 0 ]
then
	rm $HOME/fightcade*.log* -v
	exit 0
fi

exit 1

