import librosa
import numpy as np
import matplotlib.pyplot as plt

# Parameters
sampling_rate = 44100 # All clips will be converted to this rate
duration = None # Clips will be trimmed to this length (seconds)

def import_wav(file, plot=False):
    # Import raw data
    raw_data = librosa.load(file, sr=sampling_rate, mono=False, duration=duration)
    
    # Only use one channel
    if raw_data[0].shape[0] == 2:
        raw_data = (raw_data[0][0], raw_data[1])
    
    if plot:
        plt.plot(raw_data[0])
        plt.show()

    return raw_data
