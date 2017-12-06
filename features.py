import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt
#import anurag_cnn.feat_extractor as cnn
#from anurag_cnn.feat_extractor import usegpu
def gen_cnn(raw_audio, use_gpu=True):
    ''' Use a pre-trained CNN to extract features
    '''
    
    features = cnn.main(raw_audio[0], use_gpu)
    
    return features

def gen_mag_spec(raw_audio):
    ''' Generate a magnitude spectrogram from raw audio
    '''
    
    init_ = librosa.stft(raw_audio[0])
    D = librosa.amplitude_to_db(init_, ref=np.max)
    
    magnitude_spec = np.empty((1, 1025))
    magnitude_spec = np.vstack((magnitude_spec, D.T))
    
    D = np.insert(D, 0, 0, 1)  # First Column Padding  -- array, index, padding, axis
    D = np.insert(D, D.shape[1], 0, 1)  # Last Column Padding  -- array, index, padding, axis
    
    deltas = [np.empty((D.shape[1] - 1, D.shape[0])) for i in range(3)] 
        
    for i in range(1, D.shape[1] - 1):
        deltas[0][i] = D[:, i] - D[:, i - 1]
        deltas[1][i] = D[:, i + 1] - D[:, i]
        deltas[2][i] = D[:, i + 1] - D[:, i - 1]
    delta_stub = np.hstack((magnitude_spec, deltas[0]))
    delta_stub = np.hstack((delta_stub, deltas[1]))
    delta_stub = np.hstack((delta_stub, deltas[2]))
    
    return delta_stub[1:]

def gen_correlogram(raw_audio, plot=False, gen_csv=False):
    ''' Generates a correlogram feature vector from raw audio
        
        raw_audio: a tuple containing
            - 1 x N numpy array (the raw audio)
            - the sampling rate
        gen_csv: if True, will output a csv file in this directory with 
            feature outputs

        returns an F x M matrix of feature vectors
    '''
    # Parameters
    acf_window = 10
    count_bins = 128 # Default for librosa, may want to change

    # Generate mel spectrograms
    spec = librosa.feature.melspectrogram(raw_audio[0], sr=raw_audio[1])

    # Pad with zeros
    padding = np.zeros((count_bins, acf_window))
    spec_pad = np.concatenate((spec, padding), axis=1)

    # Generate chromagram
    #spec = librosa.feature.chroma_stft(data[0], sr=sampling_rate)
    
    # For each bin, calculate autocorrelation
    N = spec.shape[1]
    F = count_bins * min(N, acf_window)
    features = np.zeros((F, N))

    for i in range(N):
        obs = []
        for j in range(count_bins):
            #print("Len of autocorr: " + str(len(autocorr)))
            autocorr = librosa.core.autocorrelate(spec_pad[j, i:i+acf_window])[:N]
            obs.extend(autocorr)

        features[:, i] = np.transpose(obs)
        
    # Plot spectrogram
    if plot:
        plt.subplot(2, 1, 1)
        librosa.display.specshow(spec)
        plt.subplot(2, 1, 2)
        plt.plot(features[:, 0])
        plt.show()

    # Export CSV file
    if gen_csv:
        np.savetxt('correlogram.csv', features, delimiter=',')

    return np.array(features)

########### Code to compute Contsant-Q Features
def delta(a, b):
    return a-b
def constQFeatureExtractor(curr_col, prev_col, next_col):
    d1 = delta(curr_col, prev_col)
    d2 = delta(curr_col, next_col)
    dd = delta(prev_col, next_col)
    vector = np.concatenate((curr_col,d1,d2,dd))
    return vector

def gen_constantQ(raw_audio='', label=None):
##   filename - path and name of file for which we need to get the constQ spectograms
##   label = 'something' if we want to assign labels to them else None
    X = []
    Y = []
    C = librosa.cqt(raw_audio[0], sr=raw_audio[1])
    magC = np.abs(C)
    for i in range(1,magC.shape[1]-1):
        curr_col=magC[:,i]
        prev_col=magC[:,i-1]
        next_col=magC[:,i+1]
        feature_vector = constQFeatureExtractor(curr_col=curr_col, prev_col=prev_col, next_col=next_col)
        X += [feature_vector]
        #Adding str(i) which says the time interval for that particular id.
        if label != None:
            Y += [label]
    if label == None:
        return np.array(X)
    else:
        return np.array(X),np.array(Y)
     