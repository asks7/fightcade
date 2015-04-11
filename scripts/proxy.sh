#!/bin/bash

cd "${0%/*}"

[ -f $HOME/fightcade.log ] && rm $HOME/fightcade*.log -v

function socksify_init () {
	[ "${1}" = "" ] && exit 1 || SERVER=${1}
	[ "${2}" = "" ] && PORT="8080" || PORT=${2}

	export SOCKS_DIRECTROUTE_FALLBACK=yes

	case ${1} in
	*:* )
		export SOCKS_SERVER=${SERVER}
		echo -e "Proxy: \e[92m${SOCKS_SERVER}\e[m"
	;;
	* )
		export SOCKS_SERVER="${SERVER}:${PORT}"
		export SOCKS_DIRECTROUTE_FALLBACK=yes
		echo -e "Proxy: \e[92m${SOCKS_SERVER}\e[m"
	esac
	return
}

case ${1} in
	"-f" )
		socksify_init ${2} ${3}
		socksify ./main.py
	;;
	[0-9]* )
		socksify_init ${1} ${2}
		socksify ./main.py 2>/dev/null &
	;;
	*:* )
		socksify_init ${1}
		socksify ./main.py 2>/dev/null &
	;;
	* )
		echo "usage: proxy.sh [option] ... [arg] ..."
	;;
esac

exit 0

