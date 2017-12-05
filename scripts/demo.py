import sys
sys.path.append('./scrapers')

import youtube
import audio
import features
import glob
import numpy as np

'''
Instructions:

Enter the URL of a Youtube video with either a boat or a helicopter
in it. Run the script and it will produce a prediction.

'''

# Enter URL here (just the part after the watch?v=)
test_URL = "GUulA_5eTPI"

# Download the audio to a temp location
print("Downloading Youtube audio...")
#youtube.download_audio(test_URL, filename=test_URL)
files = glob.glob("./downloads/*.wav")
audio.split_clips(files)

files = glob.glob("./downloads/processed/*.wav")

print("Generating features...")
for file_name in files:
    print(file_name)

    raw = audio.import_wav(file_name)

    # Generate features
    cnn = features.gen_cnn(raw, use_gpu=True)

    with open('./downloads/features_cnn.csv', 'ab') as f_handle:
        np.savetxt(f_handle, cnn, fmt='%.6e', delimiter=',')
    
# Run classifiers
print("Running classification...")
prediction = 10

print("My prediction is %i" % prediction)
