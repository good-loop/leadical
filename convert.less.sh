# !/bin/env bash

WATCH=$1
USER=`whoami`
GOTINOTIFYTOOLS=`which inotifywait`
WEB=/home/$USER/winterwell/mydata/web

for file in $WEB/style/*.less; do
		if [ -e "$file" ]; then
			echo -e "converting $file"
			lessc "$file" "${file%.less}.css"
		else
			echo "no less files found"
			exit 0
		fi
done

if [[ $WATCH == 'watch' ]]; then
	if [ "$GOTINOTIFYTOOLS" = "" ]; then
    	echo "In order to watch and continuously convert less files, you will first need to install inotify-tools on this system"
    	echo ""
    	echo "run sudo apt-get install inotify-tools in order to install"
    	exit 0
	else
	while true
	do
		inotifywait -r -e modify,attrib,close_write,move,create,delete $WEB/style && \
		for file in $WEB/style/*.less; do
			if [ -e "$file" ]; then
				echo -e "converting $file"
				lessc "$file" "${file%.less}.css"
			else
				echo "no less files found"
				exit 0
			fi
		done
	done
	fi
fi