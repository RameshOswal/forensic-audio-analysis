% %% read audio
% path = 'resources/heli_and_boat_short/heli6_short.wav';
% [ms_deltas] = modspec_fn(path);
% 

%% generate test set heli

myDir = 'resources/audio_data/heli/test'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  if k == 1
      modspec_heli_test = modspec_fn(fullFileName);
  else
      modspec_heli_test = [modspec_heli_test; modspec_fn(fullFileName)];
  end
  % all of your actions for filtering and plotting go here
end
cd output_mats;
save('modspec_heli_test.mat','modspec_heli_test');
cd ..;
%% generate train set heli

myDir = 'resources/audio_data/heli/train'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  if k == 1
      modspec_heli_train = modspec_fn(fullFileName);
  else
      modspec_heli_train = [modspec_heli_train; modspec_fn(fullFileName)];
  end
  % all of your actions for filtering and plotting go here
end
cd output_mats;
save('modspec_heli_train.mat','modspec_heli_train');
cd ..;
%% generate train set boat

myDir = 'resources/audio_data/boat/train'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  if k == 1
      modspec_boat_train = modspec_fn(fullFileName);
  else
      modspec_boat_train = [modspec_boat_train; modspec_fn(fullFileName)];
  end
  % all of your actions for filtering and plotting go here
end
cd output_mats;
save('modspec_boat_train.mat','modspec_boat_train');
cd ..;
%% generate test set boat

myDir = 'resources/audio_data/boat/test'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  if k == 1
      modspec_boat_test = modspec_fn(fullFileName);
  else
      modspec_boat_test = [modspec_boat_test; modspec_fn(fullFileName)];
  end
end
cd output_mats;
save('modspec_boat_test.mat','modspec_boat_test');
cd ..;


