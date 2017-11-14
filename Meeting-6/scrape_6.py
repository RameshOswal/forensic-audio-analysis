#!/usr/bin/env python

import sys
sys.path.append('../scrapers')

from youtube import *
import csv
from subprocess import run
import glob

# First, pull some helicopter audio from Youtube
# using the aviation fanatic database
prefix = "../../avfanatic_"

# Columns:
# 4(3) = Name
# 6(5) = Category

with open(prefix+"aircrafttypes.csv") as f:
    reader = csv.reader(f)

    for row in reader:
        if row[5] == "H":
            print(row[3])

            # Search for parsed term
            results = youtube_search(row[3], 5)

            for result in results:
                print(result)

                # Download audio
                download_audio(result, filename=result, location="./downloads_heli/")

# Now find some boats using a simple query
results = youtube_search("boat engine", 25)

for result in results:
    print(result)

    # Download audio
    download_audio(result, filename=result, location="./downloads_boat/")
    
# At this point, I manually sifted through the results
# and took out anything that was not relevant (and also
# just took out a lot of extra files because the
# searches produced a lot of results).

## Helicopters
# Split each file into 10-second clips
files = glob.glob("./downloads_heli/*.wav")

for file in files:
    file_comp = file.split("/")
    file_noext = file_comp[-1][:-4]

    run(["ffmpeg", "-i", file, "-f", "segment", "-segment_time", "10", "-c", "copy", "./downloads_heli/processed/" + file_noext + "_%03d.wav"])

# Add labels for each file
with open("labels.csv", "w") as labels:

    files = glob.glob("./downloads_heli/processed/*.wav")
    writer = csv.writer(labels)
    
    for file in files:
        file_comp = file.split("/")
        file_noext = file_comp[-1][:-4]
        
        writer.writerow([file_noext, "1"])

## Boats
# Split each file into 10-second clips
files = glob.glob("./downloads_boat/*.wav")

for file in files:
    file_comp = file.split("/")
    file_noext = file_comp[-1][:-4]

    run(["ffmpeg", "-i", file, "-f", "segment", "-segment_time", "10", "-c", "copy", "./downloads_boat/processed/" + file_noext + "_%03d.wav"])

# Add labels for each file
with open("labels.csv", "a") as labels:

    files = glob.glob("./downloads_boat/processed/*.wav")
    writer = csv.writer(labels)
    
    for file in files:
        file_comp = file.split("/")
        file_noext = file_comp[-1][:-4]
        
        writer.writerow([file_noext, "0"])
