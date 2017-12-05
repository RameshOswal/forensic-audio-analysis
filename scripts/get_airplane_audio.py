#!/usr/bin/env python

from youtube import *
import csv

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

                # Search for parsed term
                results = youtube_search(row[3], 1)

                for result in results:
                    print(result)

                    # Download audio
                    download_audio(result)
