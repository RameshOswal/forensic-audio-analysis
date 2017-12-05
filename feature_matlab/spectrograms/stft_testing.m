%% read audio

samp_rate = 44100;
[x,fs] = audioread('resources/heli_and_boat_short/boat6_short.wav'); %5 x 51143 gives 2 second long in each row
x2 = mean(x,2);
if fs ~= samp_rate
    x2 = resample(x2,samp_rate,fs);
    fs = samp_rate;
end
[s_vects, spec_size] =call_stft(x2, fs);

%% test output
figure; 
imagesc(reshape(s_vects(1,:),spec_size));
title('test output');
colormap jet;
%% Examples (first is decimated, second is not)
AUDIO_PATH = 'resources/heli_and_boat_short/boat5_short.wav';

[x,fs] = audioread(AUDIO_PATH);
x2 = mean(x,2);
D = 3;
x2s = decimate(x2,D);
fs = fs/D;

nw  = round(.03*fs);
w = hamming(nw);
spectrogram(x2s(1:2*fs),w,round(nw/2),[],fs,'yaxis')
colormap jet

[x,fs] = audioread('resources/heli_and_boat_short/heli6_short.wav');
x2 = mean(x,2);
D = 1;
x2s = decimate(x2,D);
fs = fs/D;
figure;
nw  = round(.03*fs);

w = hamming(nw);
spectrogram(x2s(1:2*fs),w,round(nw/2),[],fs,'yaxis')
colormap jet


