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

if [ -f $HOME/fightcade.log ]
then
	rm $HOME/fightcade*.log
fi

. ggpo/scripts/shell-functions.sh
find_python

ARG=${@}

case ${ARG} in
	*"-f"* )
		init ${2} ${3}
		socksify ${PYTHON} ./main.py
	;;
	*"-s"* )
	;;
	[0-9]* )
		init ${1} ${2}
		socksify ${PYTHON} ./main.py 2>/dev/null &
	;;
	* )
		echo "usage: dante.sh [option] ... [arg] ..."
		echo "Options:"
		echo -e "-f\t: foreground run"
		echo ${ARG}
	;;
esac

exit 0

