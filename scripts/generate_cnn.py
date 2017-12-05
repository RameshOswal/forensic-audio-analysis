import sys
sys.path.append('..')

import audio
import features
import glob
import numpy as np

# Set aside test files
test_files = ["tLhQ2FEH4d0", "v55hojInS9c", "WRViiWdfDsA", "wXoZ7P-d0H4", "x6i3VgPVDNQ", "44Ml2WN2sE0", "72qNna11Znw", "AEHqXfkbIZU", "b2glfO1LL78", "Bky6CenOORY"]

# Process each category of sound
for cat in ("heli", "boat"):
    ctr = 0
    files = glob.glob("./Meeting-6/downloads_" + cat + "/processed/*.wav")

    obs_count = 0

    # Generate features
    for file in files:
        ctr += 1
#         print(ctr)
        print("Loading " + file)
        raw = audio.import_wav(file)

        # Generate cnn features
        cnn = features.gen_cnn(raw, use_gpu=True)
        
        print(cnn.shape)

        # Export for classification
        test = False
        for test_file in test_files:
            if test_file in file:
                test= True
                break
        
        if test == True:
            print("Saving: test")
            with open('./Meeting-6/data/test/' + cat + '/features_cnn.csv', 'ab') as f_handle:
                np.savetxt(f_handle, cnn, fmt='%.6e', delimiter=',')
        else:
            print("Saving: train")
            with open('./Meeting-6/data/train/' + cat + '/features_cnn.csv', 'ab') as f_handle:
                np.savetxt(f_handle, cnn, fmt='%.6e', delimiter=',')


    # Assign labels manually
    #Y = np.zeros((obs_count, 1))

    print("Nice!")
