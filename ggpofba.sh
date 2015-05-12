#!/bin/sh
#

cd "${0%/*}"

. ggpo/scripts/shell-functions.sh
find_python

PARAM=${1+"$@"}

THIS_SCRIPT_PATH=`readlink -f $0 2>/dev/null || pwd`
THIS_SCRIPT_DIR=`dirname ${THIS_SCRIPT_PATH}`

FBA="./ggpofba.py"

[ ! -x ${FBA} ] && {
	FBA="${THIS_SCRIPT_DIR}/ggpofba.py"
}

[ ! -x ${FBA} ] && {
	echo "Can't find ggpofba"
	exit 1
}

echo ${PARAM} | grep "^fightcade://challenge-.*@" >/dev/null

[ $? -eq 0 ] && {
	quark=$(echo ${PARAM} | cut -f 1 -d "@" | cut -f 3 -d "/")
	games=$(echo ${PARAM} | cut -f 2 -d "@")
	PARAM="quark:stream, ${games}, ${quark}, 7001 -w"
}

[ ! -x /usr/bin/pulseaudio ] || [ ! -x /usr/bin/pacmd ] || [ ! -x /usr/bin/pactl ] && {
	${PYTHON} ${FBA} ${PARAM} &
	exit 0
}

tot=$(/usr/bin/pacmd list-sink-inputs | grep ">>>.*sink input(s) available." | head -n 1 | awk '{print $2}')

[ -z "${tot}" ] && tor=99

[ ${tot} -eq 0 ] && {
	VOL=$(/usr/bin/pacmd dump | grep "^set-sink-volume" | tail -n 1 | awk '{print $3}')
	/usr/bin/pulseaudio -k
	/usr/bin/pulseaudio --start
}

${PYTHON} ${FBA} ${PARAM} &

[ ${tot} -eq 0 ] && {
	sleep 1s
	/usr/bin/pactl set-sink-volume 0 ${VOL}
}

