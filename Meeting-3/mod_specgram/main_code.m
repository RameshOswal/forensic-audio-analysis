

%% Import data

% Navigate to and read images for helicopters
cd ..;
hY = [];
n = 10;
for i = 1:n
    audioname = ['heli' num2str(i-1) '_short.wav'];
    [x,fs] = audioread(audioname);
    x = x(:,1);
    if fs == 48000
        x = resample(x,44100, 48000);
    end
    hY = [hY x(:)];
end

% read images for boats
bY = [];
n = 10;
for i = 1:n
    audioname = ['boat' num2str(i-1) '_short.wav'];
    [x,fs] = audioread(audioname);
    x = x(:,1);
    if fs == 48000
        x = resample(x,44100, 48000);
    end
    bY = [bY x(:)];
end

b = [bY hY];

% fs: samp frequency
% t: signal duration in seconds
% n: number of signals
% by: dimensions fs*t x n


cd mod_specgram;

% add spec gram toolbox
path_toolbox = '../../toolboxes/amtoolbox-full-0.9.9';
addpath(genpath(path_toolbox));

%output mod specgram
for i = 1:2*n
    c = modspecgram(hY(:,1),fs);
    c = reshape(c, 1, []); %reshape into vector
    outgram(i,:) = c;
end

save('specgrams.mat','outgram')  % function form

