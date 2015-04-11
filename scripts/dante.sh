#!/bin/bash

cd "${0%/*}"

[ -f $HOME/fightcade.log ] && rm $HOME/fightcade*.log

function socksify_init {
	[ "${1}" = "" ] && exit 1 || SERVER=${1}
	[ "${2}" = "" ] && PORT="8080" || PORT=${2}
	
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

case ${1} in
	"-" )
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
		echo "usage: dante.sh [option] ... [arg] ..."
	;;
esac

exit 0

