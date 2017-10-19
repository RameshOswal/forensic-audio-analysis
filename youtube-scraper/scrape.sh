#!/usr/bin/env bash

# Check input
if [ $# -eq 0 ]
then
	#echo "Please enter a URL"
	#exit 1

	# Download example for now
	youtube-dl --extract-audio --audio-format best -o "./downloads/%(title)s_%(format)s.%(ext)s" https://www.youtube.com/watch?v=LyUJIC6I7ic
else
	# Download audio from videos
	youtube-dl --extract-audio --audio-format best -o "./downloads/%(title)s_%(format)s.%(ext)s" $1
fi

