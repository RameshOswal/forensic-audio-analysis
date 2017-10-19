#!/usr/bin/env bash

# Check input
if [ $# -eq 0 ]
then
	echo "Please enter a URL"
	exit 1
fi


youtube-dl --extract-audio --audio-format mp3 -o "./downloads/%(title)s_%(format)s.%(ext)s" $1
