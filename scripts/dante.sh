#!/bin/bash

cd "${0%/*}"

[ -f $HOME/fightcade.log ] && rm $HOME/fightcade*.log

function init_socksify () {
	[ "${1}" = "" ] && exit 1 || SERVER=${1}
	[ "${2}" = "" ] && PORT='8080' || PORT=${2}
	export HTTP_CONNECT_PROXY="http://${SERVER}:${PORT}"
	echo -e "\e[92m${HTTP_CONNECT_PROXY}\e[m"
	return
}

# config
unset ALL_PROXY NO_PROXY
unset all_proxy http_proxy https_proxy socks_proxy no_proxy

case $1 in
	"-f" )
		init_socksify ${2} ${3}
		socksify ./main.py
	;;
	[0-9]* )
		init_socksify ${1} ${2}
		socksify ./main.py 2>/dev/null &
	;;
	*)
		echo "usage: dante.sh [option] ... [arg] ..."
		echo -e "-f\t:foreground run"
	;;
esac

exit 0

