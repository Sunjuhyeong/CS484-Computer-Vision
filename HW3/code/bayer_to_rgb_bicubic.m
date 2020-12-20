%% HW3-a
% Generate the rgb image from the bayer pattern image using linear and
% bicubic interpolation.
function rgb_img = bayer_to_rgb_bicubic(bayer_img)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    [h,w] = size(bayer_img);
    I = uint8(zeros(h,w,3));
    R = uint8(zeros(h,w));
    G = uint8(zeros(h,w));
    B = uint8(zeros(h,w));
    for i = 1:h
        for j = 1:w
            if mod(i,2)==1 && mod(j,2)==1
                R(i,j) = bayer_img(i,j);
            elseif mod(i,2)==0 && mod(j,2)==0
                B(i,j) = bayer_img(i,j);
            else
                G(i,j) = bayer_img(i,j);
            end
        end
    end
    Rh = imfilter(R, [1,0,1]/2);
    Rv = imfilter(R, [1;0;1]/2);
    Rd = imfilter(R, [1,0,1;0,0,0;1,0,1]/4);
    R = R+Rh+Rv+Rd;
    Bh = imfilter(B, [1,0,1]/2);
    Bv = imfilter(B, [1;0;1]/2);
    Bd = imfilter(B, [1,0,1;0,0,0;1,0,1]/4);
    B = B+Bh+Bv+Bd;
    Gc = imfilter(G, [0 1 0; 1 0 1; 0 1 0]/4);
    G = G+Gc;
    I(:,:,1) = R;
    I(:,:,2) = G;
    I(:,:,3) = B;
    rgb_img = I;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end
