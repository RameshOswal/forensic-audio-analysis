repo_root = "/home/andy/mlsp_project/forensic-audio-analysis/"

import sys
sys.path.append(repo_root)
sys.path.append(repo_root + "/scrapers")

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
download_path = repo_root + "downloads/demo/"

print("============================")
print("Downloading Youtube audio...")
print("============================")
youtube.download_audio(test_URL, location=download_path, filename=test_URL)
files = glob.glob(download_path + "*.wav")
audio.split_clips(files, location=download_path + "processed/")

files = glob.glob(download_path + "processed/*.wav")

print("============================")
print("Generating features...")
print("============================")
for file_name in files:
    print(file_name)

    raw = audio.import_wav(file_name)

    # Generate features
    cnn = features.gen_cnn(raw, use_gpu=True)

    with open(download_path + "features_cnn.csv", "ab") as f_handle:
        np.savetxt(f_handle, cnn, fmt='%.6e', delimiter=',')
    
# Run classifiers
print("============================")
print("Running classification...")
print("============================")
prediction = 10

print("My prediction is %i" % prediction)
