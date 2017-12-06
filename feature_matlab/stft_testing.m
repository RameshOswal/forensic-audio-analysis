%% generate test set heli

myDir = 'resources/audio_used/heli/test'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  if k == 1
      stft_heli_test = call_stft(fullFileName);
  else
      stft_heli_test = [stft_heli_test; call_stft(fullFileName)];
  end
  % all of your actions for filtering and plotting go here
end
cd output_mats;
save('stft_heli_test.mat','stft_heli_test');
cd ..;
%% generate train set heli

myDir = 'resources/audio_used/heli/train'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  if k == 1
      stft_heli_train = call_stft(fullFileName);
  else
      stft_heli_train = [stft_heli_train; call_stft(fullFileName)];
  end
  % all of your actions for filtering and plotting go here
end
cd output_mats;
save('stft_heli_train.mat','stft_heli_train');
cd ..;
%% generate train set boat

myDir = 'resources/audio_used/boat/train'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  if k == 1
      stft_boat_train = call_stft(fullFileName);
  else
      stft_boat_train = [stft_boat_train; call_stft(fullFileName)];
  end
  % all of your actions for filtering and plotting go here
end
cd output_mats;
save('stft_boat_train.mat','stft_boat_train');
cd ..;
%% generate test set boat

myDir = 'resources/audio_used/boat/test'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  if k == 1
      stft_boat_test = call_stft(fullFileName);
  else
      stft_boat_test = [stft_boat_test; call_stft(fullFileName)];
  end
end
cd output_mats;
save('stft_boat_test.mat','stft_boat_test');
cd ..;









%% Undecimated frame 1
test = 1;
AUDIO_PATH = 'resources/audio_used/heli/train/5goYPsUoyQ0_020.wav';
if test == 1
    s_vects = call_stft(AUDIO_PATH);
%     [x,fs] = audioread(AUDIO_PATH);
%     x2 = mean(x,2);
%     D = 1;
%     x2s = decimate(x2,D);
%     fs = fs/D;
%     figure;
%     nw  = round(.03*fs);
%     w = hamming(nw);
%     spectrogram(x2s(1:2*fs),w,round(nw/2),[],fs,'yaxis');
%     title('not downsampled');
%     colormap jet
end