import librosa
import numpy as np
import matplotlib.pyplot as plt
from subprocess import run

# Parameters
sampling_rate = 44100 # All clips will be converted to this rate
duration = None # Clips will be trimmed to this length (seconds)

def import_wav(file, plot=False):
    # Import raw data
    try:
        raw_data = librosa.load(file, sr=sampling_rate, mono=False, duration=duration)
    except:
        raise IOError('Give me an audio file which I can read!!')
    
    # Only use one channel
    if len(raw_data[0].shape) > 1:
        raw_data = (raw_data[0][0], raw_data[1])
    
    if plot:
        plt.plot(raw_data[0])
        plt.show()

    return raw_data

def split_clips(file_list, location="./downloads/processed/", length="10"):
    for file in file_list:
        file_comp = file.split("/")
        file_noext = file_comp[-1][:-4]

        run(["ffmpeg", "-i", file, "-f", "segment", "-segment_time", length, "-c", "copy", location + file_noext + "_%03d.wav"])
