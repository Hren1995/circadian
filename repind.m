function Y = repind(X,k)
    % input X a 1d vector
    flp = false;
    if size(X,1)~=1
        flp = true;
        X = X';
    end
    Y = repmat(X,k,1);
    Y = reshape(Y,1,[]);
    if flp
        Y = Y';
    end
end