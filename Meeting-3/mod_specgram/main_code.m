

%% Import data

% Navigate to and read images for helicopters
cd ../../../../local_data/week3/heli_and_boat_short;
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



% fs: samp frequency
% t: signal duration in seconds
% n: number of signals
% by: dimensions fs*t x n
