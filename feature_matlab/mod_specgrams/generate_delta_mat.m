function [ delt_mat] = generate_delta_mat( ms_mat )
    
    n_grams = size(ms_mat,3);
    n_cols = size(ms_mat,2);
    n_rows = size(ms_mat,1);
    
    delt_mat = zeros(n_cols*n_grams,n_rows*4);
    
    zero_col = zeros(n_rows,1);
    
    
    for cur_frame = 1:n_grams
        
        % for each frame
        mat1 = ms_mat(:,:,cur_frame);
        
        % shift left once
        mat2 = [mat1(:,2:end) zero_col];
        
        % shift right once
        mat3 = [zero_col mat1(:,1:end-1)];
        
        % chop off first and last cols
        mat1 = mat1(:,2:end-1);
        mat2 = mat2(:,2:end-1);
        mat3 = mat3(:,2:end-1);
        
        % perform subtractions
        ab = mat1 - mat3;
        ac = mat1 - mat2;
        bc = mat3 - mat2;
        
        % switch to transpose 
        a = mat1';
        ab = ab';
        ac = ac';
        bc = bc';
        
        % concatenate into one delta feature
        t = [a ab ac bc];
        if cur_frame == 1
            delt_mat = t;
        else
            
            delt_mat = [delt_mat; t];
        end
    end
        


end

