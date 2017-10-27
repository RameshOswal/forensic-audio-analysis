% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

[x, fs] = audioread('Cessna 172 - Engine Change Start Up.wav');

start_pos = 800000;
count_frames = 8000;

figure;
subplot(1,2,1);
r = start_pos: start_pos + count_frames;
t = r./fs;
xin = x(r,1);
plot(t, xin);
xlabel('Seconds');
ylabel('Amplitude');
title('Input (fs = 44100 Hz)');
subplot(1,2,2);
modspecgram(xin,fs, 'fmax', 2500, 'mfmax', 800 );

%% Calculate stats
period_frames = 800;
period = 800/fs; %frames * frames/s
frequency = 1/period;
