%% HW3-b
% Calculate the fundamental matrix using the normalized eight-point
% algorithm.
function f = calculate_fundamental_matrix(pts1, pts2)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    [npts1, T1] = normalize_points(pts1', 2);
    [npts2, T2] = normalize_points(pts2', 2);
    npts1 = npts1';
    npts2 = npts2';
    
    x1 = npts1(:, 1);
    y1 = npts1(:, 2);
    x2 = npts2(:, 1);
    y2 = npts2(:, 2);
    
    A = [x2.*x1, x2.*y1, x2, y2.*x1, y2.*y1, y2, x1, y1, ones(8, 1)];
    [~, ~, V] = svd(A);
    F = reshape(V(:,end), [3, 3])';
    [Uf,Sf,Vf] = svd(F);
    Sf = diag([Sf(1, 1) Sf(2, 2) 0]);
    f = Uf*(Sf)*(Vf');
    f = T2'*f*T1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
