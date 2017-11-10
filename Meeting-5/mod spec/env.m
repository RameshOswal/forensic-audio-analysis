function [ sigenv ] = env( sig)
% calculate envelope of x

    hlowpass1 = dsp.FIRFilter(...
    'Numerator', firpm(20, [0 0.03 0.1 1], [1 1 0 0]));

    DownsampleFactor = 100;
    
    % Envelope detector by squaring the signal and lowpass filtering
    sigsq = 2*sig.*sig;
    sigenv = sqrt(step(hlowpass1, downsample(sigsq, DownsampleFactor)));

end

