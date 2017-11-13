#!/usr/bin/env python

import sys
sys.path.append('../scrapers')

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
            if row[5] == "H":
                print(row[3])

                # Search for parsed term
                results = youtube_search(row[3], 5)

                for result in results:
                    print(result)

                    # Download audio
                    download_audio(result, filename=result)
