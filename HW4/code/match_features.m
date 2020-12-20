% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Please implement the "nearest neighbor distance ratio test", 
% Equation 4.18 in Section 4.1.3 of Szeliski. 
% For extra credit you can implement spatial verification of matches.

%
% Please assign a confidence, else the evaluation function will not work.
%

% This function does not need to be symmetric (e.g., it can produce
% different numbers of matches depending on the order of the arguments).

% Input:
% 'features1' and 'features2' are the n x feature dimensionality matrices.
%
% Output:
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index in features2. 
%
% 'confidences' is a k x 1 matrix with a real valued confidence for every match.

function [matches, confidences] = match_features(features1, features2)

% Placeholder random matches and confidences.
num_features = min(size(features1, 1), size(features2,1));
matches = zeros(num_features, 2);
confidences = zeros(num_features, 1);
L = size(features1, 2); %128
threshold = 0.8;

for i = 1:num_features
    temp = zeros(num_features,1);
    for q = 1:L
        temp = temp + (features1(1:num_features, q) - features2(i,q)).^2;
    end
    temp = sqrt(temp);
    [ds, temp] = sort(temp);
    j = 1;
    conf = ds(j) / ds(j+1);
    while conf >= threshold
        j = j+1;
        if j == num_features
            j = 0;
            break
        end
        conf = ds(j) / ds(j+1);
    end
    if j == 0
        confidences(i,:) = 0;
        matches(i,:) = [0, 0];
    else
        conf = ds(j) / ds(j+1);
        confidences(i,:) = 1 / conf;
        matches(i,:) = [temp(j), i];
    end
end
[~,~,confidences] = find(confidences);
[~,~,a] = find(matches(:,1)); 
[~,~,b] = find(matches(:,2));
matches = [a, b];
end
% Remember that the NNDR test will return a number close to 1 for 
% feature points with similar distances.
% Think about how confidence relates to NNDR.