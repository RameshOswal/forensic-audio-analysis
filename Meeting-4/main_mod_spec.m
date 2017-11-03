%% Import data
[x, fs] = audioread('Cessna.wav');
x = mean(x,2);
x = x.';
start_pos = 800000;
count_frames = 80000;
x = x(start_pos:start_pos+count_frames);
x_len = length(x);
n = (0:x_len-1);

%% Perform filter bank analysis
Nw = 20;
spectrumFBS = FBS_Analysis(x,fs,Nw, 0, 0);

% Finally, plot the positive half of the result
% figure;
% f = linspace(0,1,N)*(fs/2); % actual frequency axis in Hz
% t = n / fs; % actual time axis in seconds
% imagesc(t,f,20*log(music)); 
% axis xy; colormap(jet); 
% xlabel('time (s)', 'FontName', 'Arial', 'FontSize', 15); 
% ylabel('frequency (Hz)', 'FontName', 'Arial', 'FontSize', 15); 
% title('FBS Analysis', 'FontName', 'Arial', 'FontSize', 15);

%% Perform mod specgram 
modspecgram = fft(spectrumFBS,size(spectrumFBS,2),2);
msg_half = modspecgram(1:ceil(size(spectrumFBS,1)/2),:);
figure;
imagesc(20*log10(abs(msg_half)));


%% Perform STFT
% hop_size = Nw/2;
% %spectrum = stft(x,2048,256,0,hann(2048));
% spectrum = stft(x,Nw,hop_size,0,hamming(Nw));
% music = abs(spectrum);
% sphase = spectrum./(abs(spectrum)+eps);
% % Finally, plot the positive half of the result
% figure;
% f = linspace(0,1,N)*(fs/2); % actual frequency axis in Hz
% t = n / fs; % actual time axis in seconds
% imagesc(t,f,20*log(music)); 
% axis xy; colormap(jet); 
% xlabel('time (s)', 'FontName', 'Arial', 'FontSize', 15); 
% ylabel('frequency (Hz)', 'FontName', 'Arial', 'FontSize', 15); 
% title('STFT', 'FontName', 'Arial', 'FontSize', 15);