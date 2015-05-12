#!/bin/bash

cd "${0%/*}"

[ ! -x `which socksify` ] && exit 1

. ggpo/scripts/shell-functions.sh
find_python

socksify_init () {
	[ "${1}" = "" ] && exit 1 || SERVER="${1}"
	[ "${2}" = "" ] && PORT="8080" || PORT="${2}"

	export UPNP_IGD

	case ${1} in
		*:* )
			export HTTP_CONNECT_PROXY="http://${SERVER}"
		;;
		* )
			export HTTP_CONNECT_PROXY="http://${SERVER}:${PORT}"
		;;
	esac
	echo -e "\e[1mConnect: ${HTTP_CONNECT_PROXY}\e[m"
	return
}

socksify_ggpo () {
	socksify ${PYTHON} ./main.py 1>/dev/null 2>/dev/null
}

unset ALL_PROXY NO_PROXY
unset all_proxy http_proxy https_proxy no_proxy socks_proxy

[ -f $HOME/fightcade.log ] && rm $HOME/fightcade*.log

ARG=${@}

case ${ARG} in
	*-f* )
		socksify_init ${2} ${3}
		socksify_ggpo
	;;
	*-l* )
		socksify_init "127.0.0.1" "8001"
		socksify_ggpo
	;;
	*-n* )
		${PYTHON} ./main.py 1>/dev/null 2>/dev/null &
	;;
	[0-9]* )
		socksify_init ${1} ${2}
		socksify_ggpo &
	;;
	* )
		echo dante.sh
	;;
esac

exit 0

