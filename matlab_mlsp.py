import matlab.engine
import numpy as np

def gen_modspec(file_name=""):

    eng = matlab.engine.start_matlab()

    eng.addpath('/home/andy/mlsp_project/forensic-audio-analysis/feature_matlab')
    eng.addpath('/home/andy/mlsp_project/forensic-audio-analysis/feature_matlab/toolboxes/gammatonegram')

    #spec = eng.call_stft(file_name)
    mod_spec = eng.modspec_fn(file_name)

    eng.quit()

    #spectrogram = np.array(spec)
    mod_spec = np.array(mod_spec)

    return mod_spec
