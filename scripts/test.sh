#!/bin/bash

cd "${0%/*}"

if [ ! -x "$(pwd)/fightcade" ]
then
	echo "$(pwd)/fightcade"
	exit 1
fi

init () {
	[ "${1}" = "" ] && exit 1 || SERVER="${1}"
	[ "${2}" = "" ] && PORT="8080" || PORT="${2}"

	case ${1} in
		*:* )
			export HTTP_CONNECT_PROXY="http://${SERVER}"
			echo -e "Proxy: ${HTTP_CONNECT_PROXY}"
		;;
		* )
			export HTTP_CONNECT_PROXY="http://${SERVER}:${PORT}"
			echo -e "Proxy: ${HTTP_CONNECT_PROXY}"
		;;
	esac
	return
}

unset ALL_PROXY NO_PROXY
unset all_proxy http_proxy https_proxy no_proxy socks_proxy



