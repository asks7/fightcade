#!/bin/bash

cd "${0%/*}"

[ ! -x "$(pwd)/fightcade" ] && exit 1

unset ALL_PROXY NO_PROXY
unset all_proxy http_proxy https_proxy no_proxy socks_proxy

init () {
	[ "${1}" = "" ] && exit 1 || SERVER="${1}"
	[ "${2}" = "" ] && PORT="1080" || PORT="${2}"

	export SOCKS_SERVER="${SERVER}:${PORT}"
	#export SOCKS_AUTOADD_LANROUTES=no
	#export SOCKS_DISABLE_THREADLOCK
	#export SOCKS_DIRECTROUTE_FALLBACK=yes
	
	echo -e "\e[1mConnect: ${SOCKS_SERVER}\e[m"
	
}

. ggpo/scripts/shell-functions.sh
find_python

init ${1} ${2}
socksify ${PYTHON} ./main.py 2>/dev/null &


