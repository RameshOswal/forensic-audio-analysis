#!/usr/bin/python

from apiclient.discovery import build
from apiclient.errors import HttpError
from oauth2client.tools import argparser

from subprocess import run

import api_keys

def download_audio(url, filename="%(title)s_%(format)s", location="./downloads/"):
    ''' Download audio 

        url: video ID (the part after www.youtube.com/watch?v=)
        filename: name of file; default is the video name and the audio format
        location: include an ending slash!
    '''
    print("URL: " + url + " Output: " + location + filename)
        
    run(["youtube-dl", "--extract-audio", "--no-overwrites", "--audio-format", "wav", "-o", location + filename + ".%(ext)s", url])

def youtube_search(query, max_results=25):
  DEVELOPER_KEY = api_keys.youtube_key
  YOUTUBE_API_SERVICE_NAME = "youtube"
  YOUTUBE_API_VERSION = "v3"

  youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION,
    developerKey=DEVELOPER_KEY)

  # Call the search.list method to retrieve results matching the specified
  # query term.
  search_response = youtube.search().list(
    q=query,
    part="id,snippet",
    maxResults=max_results
  ).execute()

  results = []

  # Add each result to the appropriate list, and then display the lists of
  # matching videos, channels, and playlists.
  for search_result in search_response.get("items", []):
    if search_result["id"]["kind"] == "youtube#video":
      #print(search_result["snippet"]["title"])
      results.append(search_result["id"]["videoId"])

  return results

