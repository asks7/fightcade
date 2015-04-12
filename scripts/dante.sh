#!/bin/bash

cd "${0%/*}"

if [ ! -x "$(pwd)/fightcade" ]
then
	echo "$(pwd)/fightcade"
	exit 1
else
	PYTHON="$(pwd)/fightcade"
fi

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

unset ALL_PROXY NO_PROXY
unset all_proxy http_proxy https_proxy no_proxy socks_proxy

case ${1} in
	"-f" )
		socksify_init ${2} ${3}
		socksify ${PYTHON}
	;;
	[0-9]* )
		socksify_init ${1} ${2}
		socksify ${PYTHON} 2>/dev/null &
	;;
	* )
		echo "usage: dante.sh [option] ... [arg] ..."
		echo "Options:"
		echo -e "-f\t: foreground run"
	;;
esac

if [ $? = 0 ]
then
	[ -f $HOME/fightcade.log ] && rm $HOME/fightcade*.log -v
fi

exit 0

