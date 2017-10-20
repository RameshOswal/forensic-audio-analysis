#!/usr/bin/env python

import requests
import api_keys

def freesound_search(query):
    # Inputs
    URL = "https://freesound.org/apiv2/search/text"
    PARAMS = {'query': query,
              'token': api_keys.freesound_key}

    # Submit query
    response = requests.get(url = URL, params = PARAMS)

    data = response.json()

    return data

if __name__ == "__main__":
    data = freesound_search("Thunder")

    print(data["count"])
