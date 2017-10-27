import sys
sys.path.append("../scrapers")
from youtube import download_audio

# URLs; first 10 are helicopters, next 10 are boats
heli_urls = ["0xkIupOHK-4" # Helicopters
        , "NRd-yMT_5NE"
        , "z71jqRyJhU8"
        , "qxKyHGjPKcI"
        , "MNEIgklBTSg"
        , "fI5Im9yLl-o"
        , "u4s1T0uztF8"
        , "Rxl6GzX3AUQ"
        , "Sji6NLvyLns"
        , "Xb7lSqbJYog"]
        
boat_urls = ["8_fUAZBNoVo" # Boats and ships
        , "lSVGBQkl3a4"
        , "iMYGbovQglU"
        , "Gj-Wjx6KglU"
        , "SNq6ypgqKfM"
        , "g9LOVc0sSls"
        , "8HoOP5Llf00"
        , "kBelwHMfBzY"
        , "7hhmVyNLgtU"
        , "WRfjIXofIh8"]

for idx, url in enumerate(heli_urls):
    download_audio(url, filename="heli"+str(idx))

for idx, url in enumerate(boat_urls):
    download_audio(url, filename="boat"+str(idx))
