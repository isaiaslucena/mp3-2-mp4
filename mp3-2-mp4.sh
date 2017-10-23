#!/bin/bash

OIFS="$IFS"
IFS=$'\n'

function convtrack() {
	cover=$(ls -S ${1} | egrep -i ".jpg|.jpeg|.png" | head -n 1)
	for track in $(ls ${1} | grep -i ".mp3") ; do
		trackname=$(echo ${track} | awk -F ".mp3" -F ".MP3" '{print $1}')
		ffmpeg -loop 1 -i ${1}${cover} -i ${1}${track} -shortest -s 640x480 -c:a copy -tune stillimage -preset veryfast -y ${1}"conv/"${trackname}".mp4"
	done
}

cdirs=$(ls -d */ | egrep -v "conv")

if [[ -z "${cdirs}" ]] ; then
	convtrack
else
	for cdir in ${cdirs} ; do
		mkdir -p ${cdir}"/conv"
		convtrack "${cdir}"
	done
fi

