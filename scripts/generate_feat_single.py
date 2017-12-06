repo_root = "/home/andy/mlsp_project/forensic-audio-analysis/"

import sys
sys.path.append(repo_root)
sys.path.append(repo_root + "/scrapers")

import youtube
import audio
import features
import glob
import numpy as np
import random

'''
Instructions:

Enter the URL of a Youtube video with either a boat or a helicopter
in it. Run the script and it will produce a prediction.

'''

# Enter URL here (just the part after the watch?v=)
if(len(sys.argv) == 3 and sys.argv[2] in ("h", "b")):
    test_URL = sys.argv[1]
    label = sys.argv[2]
else:
    #test_URL = "GUulA_5eTPI"
    print("Improper arguments!")
    sys.exit()

# Download the audio to a temp location
download_path = repo_root + "downloads/continuous/"

print("============================")
print("Downloading Youtube audio...")
print("============================")
youtube.download_audio(test_URL, location=download_path + "raw/", filename=test_URL)
files = glob.glob(download_path + "raw/*.wav")
audio.split_clips(files, location=download_path + "split/")

files = glob.glob(download_path + "split/" + test_URL + "*.wav")

print("============================")
print("Generating features...")
print("============================")

# Assign test or train
random.seed()
if random.random() > 0.8:
    usage = "train"
else:
    usage = "test"

for file_name in files:
    print(file_name)

    raw = audio.import_wav(file_name)

    # Generate features
    cnn = features.gen_cnn(raw, use_gpu=True)

    with open(download_path + "features/" + test_URL + "." + label + ".cnn.csv", "ab") as f_handle:
        np.savetxt(f_handle, cnn, fmt='%.6e', delimiter=',')
        
    #corr = features.gen_correlogram(raw)

    #with open(download_path + "features/" + test_URL + "." + label + ".corr.csv", "ab") as f_handle:
    #    np.savetxt(f_handle, corr, fmt='%.6e', delimiter=',')

