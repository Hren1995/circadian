function [y,bd_inds,bd_vals] = filter_rare(x,N)
% removes values in x that occur less than N times
x = single(x);
v = unique(x);
h = hist(x,v);
bd_vals = v(h<N);
bd_inds = ismember(x,bd_vals);
y = x(~bd_inds);
bd_vals = x(bd_inds);
bd_inds = find(bd_inds);