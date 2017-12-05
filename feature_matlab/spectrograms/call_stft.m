function [s_vects, spec_size  ] = call_stft( x, fs)
% spec size optional as output


    D = 3;
    x2s = decimate(x,D);
    fs = fs/D;
    nw  = round(.02*fs);

    w = hamming(nw);
    
    seg_len = 2*fs;
    n_seg = floor(length(x2s)/seg_len);
    
    start_ind = 1;
    
    disp = 1;
    
    % take specgram of 2 sec long windows
    for cur_seg = 1:n_seg
        end_ind = start_ind + seg_len -1;
        if disp
            figure;
            spectrogram(x2s(start_ind:end_ind),w,round(nw/2),[],fs,'yaxis');
            title(['frame' num2str(cur_seg)]);
            colormap jet
        end
        
        % return magnitude
        % vectorize each time segment along cols and add to matrix
        mag_spec = 20*log10(abs(spectrogram(x2s(start_ind:end_ind),w,round(nw/2),[],fs,'yaxis')));
        mag_spec = mag_spec(end:-1:1,:); %flip across xaxis

        s_vects(cur_seg,:) =  reshape(mag_spec, 1, numel(mag_spec));
        start_ind = start_ind + seg_len;
    end
    
    spec_size = size(mag_spec);
    
    
    
    % vectorize and return magnitude
    
    
    
%     figure;
%     imagesc(20*log10(abs(s(end:-1:1,:))));
%     colormap jet
    
end

