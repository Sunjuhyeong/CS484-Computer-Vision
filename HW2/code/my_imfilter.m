function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
% output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

sf = size(filter);
A = padarray(image, [sf(1)-1, sf(2)-1], 'symmetric');
isOdd = sf(1)*sf(2);
if rem(isOdd, 2) == 0
    error('Output is undefined');
end
% Q: should I consider the identity filter differently?
res(1:3) = {':'};
res2(1:3) = {':'};
for i=1:3
    sA = size(A,i);
    si = size(image,i);
    sf = size(filter,i);
    A = fft(A, sA+sf-1, i);
    filter = fft(filter, sA+sf-1, i);
    res{i} = ((sf-1)/2)+(1:sA);
    res2{i} = (sf-1)+(1:si);
end
A = A.*filter;
for i=1:3
    A = ifft(A,[],i);
end
A = A(res{:});
A = A(res2{:});
A = real(A);
output = A;
end

 