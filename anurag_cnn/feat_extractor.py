import librosa as lib
import numpy as np
from . import network_architectures as netark
import torch.nn.functional as Fx
import torch
from torch.autograd import Variable
import sys,os
from collections import OrderedDict
from . import extractor as exm

usegpu = True

n_fft = 1024
hop_length = 512
n_mels = 128
trainType = 'weak_mxh64_1024'
pre_model_path = os.path.join(os.path.dirname(__file__), 'mx-h64-1024_0d3-1.17.pkl')
featType = 'layer18' # or layer 19 -  layer19 might not work well
globalpoolfn = Fx.avg_pool2d # can use max also
netwrkgpl = Fx.avg_pool2d # keep it fixed

def load_model(netx,modpath):
    #load through cpu -- safest
    state_dict = torch.load(modpath,map_location=lambda storage, loc: storage)
    new_state_dict = OrderedDict()
    for k, v in state_dict.items():
        if 'module.' in k:
            name = k[7:]
        else:
            name = k
        new_state_dict[name] = v
    netx.load_state_dict(new_state_dict)

def getFeat(extractor,inpt, pool=False):
    # return pytorch tensor 
    extractor.eval()
    indata = Variable(torch.Tensor(inpt),volatile=True)
    if usegpu:
        indata = indata.cuda()

    pred = extractor(indata)
    print(pred.size())
    if pool:
        if len(pred.size()) > 2:
            gpred = globalpoolfn(pred,kernel_size=pred.size()[2:])
            gpred = gpred.view(gpred.size(0),-1)

        return gpred
    else:
        return pred

srate = 44100 # Audio should use sample rate 44100
pool = True # If pooling enabled, will generate one vector per audio clip
def main(raw_audio, use_gpu = True):
    y = raw_audio
        
    mel_feat = lib.feature.melspectrogram(y=y,sr=srate,n_fft=n_fft,hop_length=hop_length,n_mels=128)
    inpt = lib.power_to_db(mel_feat).T
    
    #quick hack for now
    if inpt.shape[0] < 128:
        inpt = np.concatenate((inpt,np.zeros((128-inpt.shape[0],n_mels))),axis=0)
    

    # input needs to be 4D, batch_size X 1 X inpt_size[0] X inpt_size[1]
    inpt = np.reshape(inpt,(1,1,inpt.shape[0],inpt.shape[1]))
    #print(inpt.shape)

    netType = getattr(netark,trainType)
    netx = netType(527,netwrkgpl)
    load_model(netx,pre_model_path)
    global usegpu
    usegpu = use_gpu # Updating the usegpu variable based on passed value	
    if usegpu:
        netx.cuda()
    
    feat_extractor = exm.featExtractor(netx,featType)
    
    pred = getFeat(feat_extractor,inpt, pool)

    #numpy arrays
    feature = pred.data.cpu().numpy()
    #print(feature.shape)

    # prediction for each segment in each column
    return feature


if __name__ == '__main__':
    if len(sys.argv) < 2:
        raise ValueError(' You need to give filename as first argument..Duhhh!!')
    if not os.path.isfile(sys.argv[1]):
        raise ValueError('give me a audio file which exist!!!')
    
    result = main(sys.argv[1])
    print(result)
