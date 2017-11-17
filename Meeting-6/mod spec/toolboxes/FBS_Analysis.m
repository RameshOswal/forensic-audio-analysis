function [ X_half ] = FBS_Analysis( xin, fs, Nw, DECIMATE, M )
% Performs STFT via LPF view
% Outputs 2D matrix with horizontal time and vertical frequency content
% If want mirrored output, choose X_out
% If want single side, choose X_half

    % Design window
    w = hamming(Nw);

    % Pick number of frequency bins to account for OLA constraints
    N = Nw;
    
    x_len = size(xin, 2);
    n = (0:x_len-1); %time index

   
    
    % Initialize STFT matrix
    X = zeros(N, length(n));
    
    for n_bin = 1:N
        w_k = 2*pi*(n_bin-1)/N;
        exp_modulator = exp(-1j*w_k*n);
        X_k = filter(w, 1, xin.*exp_modulator);
        
        X(n_bin,:) = X_k;
    end
    
    X_out = X;
    
    if DECIMATE
        for n_bin = 1:N
            X_k_M(n_bin,:) = decimate(X(n_bin,:), M);
        end
        X_out = X_k_M;
    end
    
    
    X_half = X(1:ceil(N/2),:);
    
    % Plot results
    if DECIMATE 
        figure;
        imagesc(20*log(abs(X_half)));
        f = linspace(0,1,N)*(fs/2); % actual frequency axis in Hz
        t = decimate(n,M) / fs; % actual time axis in seconds
        axis xy; colormap(jet); 
        xlabel('time (s)', 'FontName', 'Arial', 'FontSize', 15); 
        ylabel('frequency (Hz)', 'FontName', 'Arial', 'FontSize', 15); 
        title('FBS Analysis yichingl_5_2b2, decimated', 'FontName', 'Arial', 'FontSize', 15);
    else
        

        % Finally, plot the positive half of the result
        figure;
        f = linspace(0,1,N/2)*(fs/2); % actual frequency axis in Hz
        t = n / fs; % actual time axis in seconds
        imagesc(t,f,20*log(abs(X_half))); 
        axis xy; colormap(jet); 
        xlabel('time (s)'); 
        ylabel('frequency (Hz)'); 
        title('FBS Analysis');
    end
end

