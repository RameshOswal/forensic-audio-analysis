import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt

x,fs = librosa.load('resources/heli_and_boat_short/heli/heli0_short.wav', sr = 44100, mono = True)
nw = int(np.round(.02*fs))
stft_mag = np.abs(librosa.core.stft(x, nw, int(np.round(nw/2)), window = 'hamming'))
librosa.display.specshow(librosa.amplitude_to_db(stft_mag, ref = np.max), y_axis = 'log', x_axis = 'time');

print(stft_mag.shape)
