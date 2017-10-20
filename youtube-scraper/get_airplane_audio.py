#!/usr/bin/env python

from youtube import *
import csv

class options:
    q = "cessna"
    max_results = 25

if __name__ == "__main__":
    # Import and parse CSV
    prefix = "../../avfanatic_"

    # Columns:
    # 4(3) = Name
    # 6(5) = Category

    with open(prefix+"aircrafttypes.csv") as f:
        reader = csv.reader(f)

        for row in reader:
            if row[5] == "A":
                print(row[3])
                options.q = row[3]
                options.max_results = 1

                # Search for parsed term
                results = youtube_search(options)

                for result in results:
                    print(result)

                    # Download audio
                    download_audio(result)
