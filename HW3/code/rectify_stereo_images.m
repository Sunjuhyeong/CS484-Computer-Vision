%% HW3-c
% Given two homography matrices for two images, generate the rectified
% image pair.
function [rectified1, rectified2] = rectify_stereo_images(img1, img2, h1, h2)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here

    % Hint: Note that you should care about alignment of two images.
    % In order to superpose two rectified images, you need to create
    % certain amount of margin.
    tform1 = projective2d(h1); 
    tform2 = projective2d(h2);

    outPts = zeros(8, 2);
    h = size(img1, 1);
    w = size(img1, 2);
    inPts = [1, 1; 1, h; w, h; w, 1];
    outPts(1:4,1:2) = transformPointsForward(tform1, inPts);
    h = size(img2, 1);
    w = size(img2, 2);
    inPts = [1, 1; 1, h; w, h; w, 1];
    outPts(5:8,1:2) = transformPointsForward(tform2, inPts);
    
    xl = [min(outPts(:,1)), max(outPts(:,1))];
    yl = [min(outPts(:,2)), max(outPts(:,2))];
    h = ceil(yl(2) - yl(1));
    w = ceil(xl(2) - xl(1));
    Ref = imref2d([h, w], xl, yl);
    
    rectified1 = imwarp(img1, tform1, 'OutputView', Ref);
    rectified2 = imwarp(img2, tform2, 'OutputView', Ref);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end
