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

#CNN Classifier 62%Accuracy on dev set
testX = cnn
cnnClfWt = 0.62
cnnClf = joblib.load(repo_root + 'scripts/cnnLR.pkl') #Trained CNN features using LR with L1 norm.
cnnPrediction, cnnPredProb = cnnClf.predict(testX),cnnClf.predict_proba(testX)


def weightedMjorityVoting(clf_weights={}, clfs_pred={}):#currently using only one clf which is based on cnn features
	##Weights of classifer is used to make majority decision.
	## clfs_pred is a dict containing predictions from each classifier, all classifiers should have same number of predictions
	maj_sum = 0
	for clf in clfs_pred.keys():
		y = 1 if clfs_pred[clf] == 1 else -1 #making a 0 prediction which is a helicopter to -1 to make majority decison easily
		maj_sum += y * clf_weights[clf]

	return [1 if maj_sum >= 0 else 0]  
prediction = []
for idx in range(cnnPrediction.shape[0]):
	prediction += weightedMjorityVoting(clf_weights={'cnn':cnnClfWt}, clfs_pred={'cnn':cnnPrediction[idx]} )

print("My prediction is ", prediction)
