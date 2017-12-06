repo_root = "/home/andy/mlsp_project/forensic-audio-analysis/"

import sys
sys.path.append(repo_root)

import audio
import features
import glob
import numpy as np

# Set aside test files
#test_files = ["tLhQ2FEH4d0", "v55hojInS9c", "WRViiWdfDsA", "wXoZ7P-d0H4", "x6i3VgPVDNQ", "44Ml2WN2sE0", "72qNna11Znw", "AEHqXfkbIZU", "b2glfO1LL78", "Bky6CenOORY"]

# Process each category of sound
for use in ("test", "train"):
    for cat in ("heli", "boat"):
        path = repo_root + "downloads/no_talking/" + cat + "/" + use
        
        files = glob.glob(path + "/*.wav")

        # Generate features
        for file in files:
            print("Loading " + file)
            raw = audio.import_wav(file)

            # Generate cnn features
            cnn = features.gen_cnn(raw, use_gpu=True)
            
            print(cnn.shape)

            # Export for classification
            #test = False
            #for test_file in test_files:
            #    if test_file in file:
            #        test= True
            #        break
            
            print("Saving: test")
            with open(path + '/features_cnn.csv', 'ab') as f_handle:
                np.savetxt(f_handle, cnn, fmt='%.6e', delimiter=',')

        # Assign labels manually
        #Y = np.zeros((obs_count, 1))

        print("Nice!")
