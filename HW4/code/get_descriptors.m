% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'descriptor_window_image_width', in pixels, is the local feature descriptor width. 
%   You can assume that descriptor_window_image_width will be a multiple of 4 
%   (i.e., every cell of your local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations, then you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, descriptor_window_image_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each descriptor_window_image_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

%Placeholder that you can delete. Empty features.
n = size(x, 1);
features = zeros(n, 128);
cell_width = descriptor_window_image_width/4; %cell size

window_gaussian = fspecial('Gaussian', [descriptor_window_image_width descriptor_window_image_width], descriptor_window_image_width/2);
image_gaussian = fspecial('Gaussian', [descriptor_window_image_width descriptor_window_image_width], 1);

image = imfilter(image, image_gaussian);
gy = [0 1 0;0 0 0;0 -1 0];
gx = gy';
ix = imfilter(image, gx);
iy = imfilter(image, gy);
value = sqrt(iy.^2 + ix.^2);
theta = rad2deg(atan2(iy, ix));

for i = 1:n
    direction = zeros(4, 4, 8);
    window_theta = theta(y(i)-(2 * cell_width):y(i)+(2 * cell_width)-1, x(i)-(2 * cell_width):x(i)+(2 * cell_width)-1);
    window_value = value(y(i)-(2 * cell_width):y(i)+(2 * cell_width)-1, x(i)-(2 * cell_width):x(i)+(2 * cell_width)-1); 
    window_value = imfilter(window_value, window_gaussian);
    for cell_x = 0:3
        for cell_y = 0:3
            pin_x = 1 + cell_width * cell_x;
            pin_y = 1 + cell_width * cell_y;
            cell_theta = window_theta(pin_x:pin_x+cell_width-1, pin_y:pin_y+cell_width-1); 
            cell_value = window_value(pin_x:pin_x+cell_width-1, pin_y:pin_y+cell_width-1); 
            for pixel_x = 1:cell_width
                for pixel_y = 1:cell_width
                    d = get_direction(cell_theta(pixel_x, pixel_y));
                    direction(cell_x+1, cell_y+1, d) = direction(cell_x+1, cell_y+1, d) + cell_value(pixel_x, pixel_y);
                end
            end
        end
    end
    features(i, :) = reshape(direction, 1, 128);
    features(i, :) = diag(1./sum(features(i, :), 2)) * features(i, :);
end
end

function direction = get_direction(angle)
    if angle >= 0 && angle < 45
        direction = 1;
    elseif angle >= 45 && angle < 90
        direction = 2;
    elseif angle >= 90 && angle < 135
        direction = 3;
    elseif angle >= 135 && angle < 180
        direction = 4;
    elseif angle == 180
        direction = 5;
    elseif angle >= -180 && angle < - 135
        direction = 5;
    elseif angle >= - 135 && angle < - 90
        direction = 6;
    elseif angle >= - 90 && angle < - 45
        direction = 7;
    else
        direction = 8;
    end
end
