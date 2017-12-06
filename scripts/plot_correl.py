repo_root = "/home/andy/mlsp_project/forensic-audio-analysis/"

import sys
sys.path.append(repo_root)

import audio
import features
import glob
import numpy as np

download_path = repo_root + "downloads/demo/"
files = glob.glob(download_path + "processed/*.wav")

for file_name in files:
    print(file_name)

    raw = audio.import_wav(file_name)

    # Generate features
    corr = features.gen_correlogram(raw, plot=True)
