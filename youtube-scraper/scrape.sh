#!/usr/bin/env bash

# Check arguments
if [ $# -eq 0 ]
then
	#echo "Please enter a URL"
	#exit 1
fi

# Parse out the spreadsheet

# Search for youtube videos based on spreadsheet
RESULT="$(python search.py --q cessna)"

echo $RESULT

exit 0

# Download audio from each video
IFS=',' read -ra ADDR <<< "$IN"
for i in "${ADDR[@]}"; do
	youtube-dl --extract-audio --audio-format wav -o "./downloads/%(title)s_%(format)s.%(ext)s" $i
done

