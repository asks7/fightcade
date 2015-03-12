#!/bin/sh
#

WINE=`which wine`

echo $WINE

FBA="ggpofba-ng.exe"
PARAM=${1+"$@"}

#
echo ${PARAM} |grep "^fightcade://challenge-.*@" > /dev/null

if [ $? -eq 0 ]
then
	quark=$(echo ${PARAM} |cut -f 1 -d "@" |cut -f 3 -d "/")
	games=$(echo ${PARAM} |cut -f 2 -d "@")
	PARAM="quark:stream, ${games}, ${quark}, 7000 -w"
fi

# 
if [ $(uname -s) = "Linux" ]
then
	tot=$(ps ax |grep ggpofba-ng.exe |grep quark |wc -l)

	# resets pulseaudio
	if [ $tot -eq 0 ]
	then
		VOL=$(pacmd dump |grep "^set-sin-volume" |tail -n 1 |awk '{print $3}')
		/usr/bin/pulseaudio --kill
		/usr/bin/pulseaudio --start
	fi

	#${WINE} ${FBA} quark:direct, ${ROM}, ${PORT1}, ${IP}, ${PORT2}, ${IP2} &
	echo $PARAM > ggpofba.log
	WINEDEBUG=-all \
	${WINE} ${FBA} ${PARAM} &

	if [ $tot -eq 0 ]
	then
		sleep 1
		pactl set-sink-volume 0 ${VOL}
	fi
fi

exit 1

