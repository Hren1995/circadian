function tf = in_rg(V,a,b)
    ct = V;
    ct(:) = 1:numel(V);
    tf = (ct >= a) & (ct < b);
end