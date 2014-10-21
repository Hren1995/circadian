function y = reinsert(x,inds,vals)
% given a vector x (row or column), stick in vals at inds in a longer vector
[x,flip] = make_col(x);
inds = inds(:)' + [0:numel(inds)-1];
y = zeros(numel(x)+numel(inds),1);
y(inds) = vals;
y(~ismember(1:numel(y),inds)) = x;
if flip
    y = y(:);
end