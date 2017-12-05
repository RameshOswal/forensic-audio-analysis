function [s_vects] = call_stft(AUDIO_PATH)
% spec size optional as output


    disp = 0;
    
    samp_rate = 44100;
    [x,fs] = audioread(AUDIO_PATH); %5 x 51143 gives 2 second long in each row
    x2 = mean(x,2);
    if fs ~= samp_rate
        x2 = resample(x2,samp_rate,fs);
        fs = samp_rate;
    end

    D = 3;
    x2s = decimate(x,D);
    fs = fs/D;
    nw  = round(.02*fs);
    M = floor((nw-1)/4); %since we are using Hamming windows

    w = hamming(nw);
    
    seg_len = 2*fs;
    n_seg = floor(length(x2s)/seg_len);
    
    start_ind = 1;
    
    
    
    % take specgram of 2 sec long windows
    for cur_seg = 1:n_seg
        end_ind = start_ind + seg_len -1;
%         if disp
%             figure;
%             spectrogram(x2s(start_ind:end_ind),w,round(nw/2),[],fs,'yaxis');
%             title(['frame' num2str(cur_seg)]);
%             colormap jet
%         end
        
        % return magnitude
        % vectorize each time segment along cols and add to matrix
        mag_spec = 20*log10(abs(spectrogram(x2s(start_ind:end_ind),w,round(nw/2),[],fs,'yaxis')));

        mag_spec = mag_spec(end:-1:1,:); %flip across xaxis
        
        if disp
%             figure;
%             imagesc(1:1/fs:2,mag_spec);
%             xlabel('time (s)');
            figure;
            spectrogram(x2s(start_ind:end_ind),w,round(nw/2),[],fs,'yaxis');
            title(['frame' num2str(cur_seg)]);
            colormap jet
        end

        ms_mat(:,:,cur_seg) = mag_spec;
        start_ind = start_ind + seg_len;
    end
    spec_size = size(mag_spec);
    s_vects = generate_delta_mat(ms_mat);
    
    
    
end

