nsegments_in = 5; % select number of segments to process for testing

input_type = 1;
%% Import data

if (input_type == 1)
    [x, fs] = audioread('resources/heli_and_boat_short/heli6_short.wav'); %assume 44.1kHz
    x = mean(x,2);% col vector
    % Resample to around 8KHz
%     x = resample(x,2,11);
%     fs = fs*2/11;
    xlen = length(x);  
elseif (input_type == 2)
    [x, fs] = audioread('resources/Cessna.wav');
    x = mean(x,2);% col vector
    start_pos = 1;
    count_frames = 10*fs;
    x = x(start_pos:start_pos+count_frames);

    % Resample to around 8KHz
    x = resample(x,2,11);
    fs = fs*2/11;
    xlen = length(x);  
elseif (input_type == 3)
    %load train;
    load speech_dft;
    x = y;
    xlen = length(x);
end

%% Plot spectrogram
segduration = 1; %1 second
seglen = segduration*fs;
nseg = min(nsegments_in, floor(xlen/seglen));

Nw = 512;
start_ind = 1;
for n = 1:nseg
    end_ind = start_ind + seglen;
    xseg = x(start_ind:end_ind);
    x_specgram_temp = FBS_Analysis(xseg.',fs,Nw,0,0);
        title(['STFT of frame number ' num2str(n)]);
    x_specgram(:,:,n) = x_specgram_temp; 
    start_ind = start_ind + seglen;

    % Do frequency analysis
    freq_specgram_len = 8019;
    x_freq_specgram(:,:,n) = fft(x_specgram_temp,freq_specgram_len,2); %8019 = size(fft(x_specgram_temp),2)

    % Plot ffts as images
    f_vert = linspace(0,1,Nw/2)*(fs/2); % actual frequency axis in Hz
    f_hori = fs*(0:(freq_specgram_len/2)) /freq_specgram_len;
    figure;
    imagesc(f_vert,f_hori, 20*log10(abs(x_freq_specgram(:,:,n))));
    axis xy; colormap(jet); colorbar; 
    title(['frequency spectrogram of frame number ' num2str(n)]);

end

% pick a frequency row to plot magnitude and fourier transform magnitude
f = linspace(0,1,Nw/2)*(fs/2); % actual frequency axis in Hz
k_vect = 50:50:250;
for k_ind = 1:length(k_vect)
    k = k_vect(k_ind);

    figure;
    plot(abs(x_specgram(k,:,3)));
    title(['for all frames: magnitude of row ' num2str(k) ', freq = ' num2str(f(k)) ' Hz']);

    figure;
    plot(20*log10(abs(x_freq_specgram(k,:,3))));
    title(['for all frames: fft of magnitude of row ' num2str(k) ', freq = ' num2str(f(k)) ' Hz']);

end



