#!/bin/bash

cd "${0%/*}"

[ -f $HOME/fightcade.log ] && rm $HOME/fightcade*.log -v

function socksify_init () {
	export SOCKS_DIRECTROUTE_FALLBACK=yes
	case ${1} in
	*:* )
		export SOCKS_SERVER=${1}
		echo -e "\e92m${SOCKS_SERVER}\e[m"
	;;
	* )
		export SOCKS_SERVER="${1}:${2}"
		export SOCKS_DIRECTROUTE_FALLBACK=yes
		echo -e "\e[92m${SOCKS_SERVER}\e[m"
	esac
	return 0
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
	;;
esac

exit 0

