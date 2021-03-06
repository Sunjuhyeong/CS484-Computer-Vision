%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_words(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x feature vector length
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct feature descriptors here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% feature descriptors will look very different from a smaller version of the same
% image.

load('vocab.mat')
vocab_size = size(vocab, 1);
N = size(image_paths, 1);
image_feats = zeros(N, vocab_size);
step = 10;
x = 1:step:256;
y = 1:step:256;
[X, Y] = meshgrid(x, y);
X = reshape(X, [], 1);
Y = reshape(Y, [], 1);

for i=1:N
    hgram = zeros(1, vocab_size);
    image = imread(image_paths{i});
    features = extractHOGFeatures(image, [X Y], 'CellSize', [16 16]);
    D = pdist2(features, vocab);
    features_size = size(D, 1);
    for j=1:features_size
        [~, idx] = min(D(j,:));
        hgram(1, idx) = hgram(1, idx) + 1;
    end
    hgram = hgram/norm(hgram);
    image_feats(i,:) = hgram;
end




