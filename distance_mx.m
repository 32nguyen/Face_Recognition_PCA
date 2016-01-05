function d = distance_mx(a,b)
%
% d = distance_mx(a,b)
%
%    a - (DxM) matrix 
%    b - (DxN) matrix
%
% Returns:
%    d - (MxN) Euclidean distances between vectors in a and b

aa=sum(a.*a,1); 
bb=sum(b.*b,1); 
d = sqrt(abs(aa( ones(size(bb,2),1), :)' + ...
    bb( ones(size(aa,2),1), :) - 2*a'*b)); 