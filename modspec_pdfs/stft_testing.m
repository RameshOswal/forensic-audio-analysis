N = 1024;
n = 0:N-1;

w0 = 2*pi/5;
x = sin(w0*n)+10*sin(2*w0*n);
s = spectrogram(x.');

spectrogram(x,'yaxis')

AUDIO_PATH = 'resources/heli_and_boat_short/boat4_short.wav';

[x,fs] = audioread(AUDIO_PATH);
x2 = mean(x,2);
D = 3;
x2s = decimate(x2,D);
fs = fs/D;

nw  = round(.03*fs);
w = hamming(nw);
figure;
spectrogram(x2s(1:2*fs),w,round(nw/2),[],fs,'yaxis');
%spectrogram(x2s(1:2*fs),w,floor(nw/2));
colormap jet

