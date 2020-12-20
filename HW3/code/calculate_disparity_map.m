%% HW3-d
% Generate the disparity map from two rectified images. Use NCC for the
% mathing cost function.
function d = calculate_disparity_map(img_left, img_right, window_size, max_disparity)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    size1 = size(img_left);
    h = size1(1);
    w = size1(2);
    md = max_disparity;
    cost_vol = zeros(h, w, md);
    i1 = img_left;
    i2 = img_right;
    window_length = window_size-1;
    
    for j=1:h-window_length
        for k=1:md
            for i=1:w-k-window_length
                w1 = i1(j:j+window_length,i:i+window_length);
                w2 = i2(j:j+window_length,i+k:i+k+window_length);
                v1 = reshape(w1,1,[]);
                v2 = reshape(w2,1,[]);
                v1 = v1 - mean(v1);
                v2 = v2 - mean(v2);
                div = norm(v1)*norm(v2);
                result = dot(v1, v2) / div;
                cost_vol(j,i,k) = result;
            end
        end
    end
    for i=1:md
        cost_vol(:,:,i) = imguidedfilter(cost_vol(:,:,i));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % winner takes all
    [min_val, d] = max(cost_vol,[],3);
end