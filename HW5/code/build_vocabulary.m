% This function will extract a set of feature descriptors from the training images,
% cluster them into a visual vocabulary with k-means,
% and then return the cluster centers.

% Notes:
% - To save computation time, we might consider sampling from the set of training images.
% - Per image, we could randomly sample descriptors, or densely sample descriptors,
% or even try extracting descriptors at interest points.
% - For dense sampling, we can set a stride or step side, e.g., extract a feature every 20 pixels.
% - Recommended first feature descriptor to try: HOG.

% Function inputs: 
% - 'image_paths': a N x 1 cell array of image paths.
% - 'vocab_size' the size of the vocabulary.

% Function outputs:
% - 'vocab' should be vocab_size x descriptor length. Each row is a cluster centroid / visual word.

function vocab = build_vocabulary( image_paths, vocab_size )

n = size(image_paths,1);
r = 0.1;
x = 1:20:256;
y = 1:20:256;
[X, Y] = meshgrid(x, y);
X = reshape(X, [], 1);
Y = reshape(Y, [], 1);
results = [];
sample = randperm(n, floor(n*r));

for i=sample
    image = imread(image_paths{i});
    features = extractHOGFeatures(image, [X Y], 'CellSize', [16 16]);
    results = cat(1, results, features);
end
[~, vocab] = kmeans(results, vocab_size);