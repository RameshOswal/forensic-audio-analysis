addpath('toolboxes');
nsegments_in = 3; % select number of segments to process for testing
%% Import data
[x, fs] = audioread('resources/heli_and_boat_short/boat2_short.wav'); %assume 44.1kHz
x = mean(x,2);% col vector

% Resample to around 8KHz
x = resample(x,2,11);
fs = fs*2/11;
xlen = length(x);

ham_N = 200;
w = hamming(ham_N);

%% Bandpass using Gammatone Filterbank

% Make the center frequency vector
LOW_CF = 200;
HIGH_CF = 4000;
NUMCHANS = 18;
CFS = iosr.auditory.makeErbCFs(LOW_CF,HIGH_CF,NUMCHANS);

%% Segment the data as needed (nonoverlapping)
segmentlen = fs;
nsegments_total = floor(xlen/segmentlen);

nsegments = min(nsegments_in,nsegments_total); % for testing

start_pos = 1;

% Operate on each time segment
for segmentind = 1:nsegments
    end_pos = start_pos + segmentlen - 1;
    
    x_segment = x(start_pos:end_pos);
    
    BM = iosr.auditory.gammatoneFast(x_segment,CFS,fs); %operate on every col
    
    for channum = 1:NUMCHANS
        envt = env(BM(:,channum)); %operate on every col 
        
        % normalize
        envt = envt./mean(abs(envt));
        
        % bp filter
        exp_modulator = exp(1j*2*pi*4); %mod by 4 hz
        out_chann(:,channum) = log10(abs(filter(w, 1, envt.*exp_modulator)));
    end
    
    out(:,:,segmentind) = out_chann;
    
    start_pos = start_pos + segmentlen;
    
end


