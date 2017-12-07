repo_root = "/home/andy/mlsp_project/forensic-audio-analysis/"

import sys
sys.path.append(repo_root)
sys.path.append(repo_root + "/scrapers")

import youtube
import audio
import features
import glob
import numpy as np
from sklearn.externals import joblib

'''
Instructions:

Enter the URL of a Youtube video with either a boat or a helicopter
in it. Run the script and it will produce a prediction.

'''

# Enter URL here (just the part after the watch?v=)
test_URL = "TP55UHP99LA"

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

file_list = [] # A list of dictionaries of each feature type

for file_name in files:
    print(file_name)
    
    file_dict = {}

    raw = audio.import_wav(file_name)

    # Generate features
    file_dict["cnn"] = features.gen_cnn(raw, use_gpu=True)
        
    file_dict["corr"] = np.transpose(features.gen_correlogram(raw_audio=raw))
    
    file_list.append(file_dict)
    
# Run classifiers
print("============================")
print("Running classification...")
print("============================")

# Helper function
def weightedMjorityVoting(clf_weights={}, clfs_pred={}):#currently using only one clf which is based on cnn features
	##Weights of classifer is used to make majority decision.
	## clfs_pred is a dict containing predictions from each classifier, all classifiers should have same number of predictions
	maj_sum = 0
	for clf in clfs_pred.keys():
		y = 1 if clfs_pred[clf] == 1 else -1 #making a 0 prediction which is a helicopter to -1 to make majority decison easily
		maj_sum += y * clf_weights[clf]

	return [1 if maj_sum >= 0 else 0]

# Load saved classifiers
cnnClf = joblib.load(repo_root + 'scripts/cnnLR.pkl') # Trained on CNN features using LR with L1 norm
corrClf = joblib.load(repo_root + 'scripts/Corr_LR_L1_.pkl') # Trained on correlogram features using LR with L1 norm

# Weights are equal to each classifier's accuracy
clf_weights = {"cnn": 0.62, "corr": 0.67}

prediction = []

for file_dict in file_list:
    # Perform classifications with each individual classifier
    cnnPrediction, cnnPredProb = cnnClf.predict(file_dict["cnn"]), cnnClf.predict_proba(file_dict["cnn"])
    
    corrPrediction, corrPredProb = corrClf.predict(file_dict["corr"]), corrClf.predict_proba(file_dict["corr"])
    corr_single = round(np.sum(corrPrediction) / corrPrediction.size)
    
    clfs_pred = {'cnn':cnnPrediction, 'corr': corr_single}
    
    print(clfs_pred)
    
    # Combine predictions using weighted average
    prediction += weightedMjorityVoting(clf_weights, clfs_pred)

print("My prediction is ", prediction)
