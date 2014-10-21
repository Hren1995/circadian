function p = prctile_mat(M,prct)
    d = numel(size(M));
    for i=d:-1:1
        M = prctile(M,prct,i);
    end
    p = double(M);
end