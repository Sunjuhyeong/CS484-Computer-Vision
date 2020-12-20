function [features] = get_descriptors_normalized(image, x, y, descriptor_window_image_width)
n = size(x, 1);
features = zeros(n, 256);
cell_width = descriptor_window_image_width/4; %cell size

for i = 1:n
    window_image = image(y(i)-(2 * cell_width):y(i)+(2 * cell_width)-1, x(i)-(2 * cell_width):x(i)+(2 * cell_width)-1);
    features(i, :) = reshape(window_image, 1, 256);
    features(i, :) = diag(1./sum(features(i, :), 2)) * features(i, :);
end
end