function I = calcuateBinaryMutualInformation(X)

    s = size(X);
    d = s(2);
    N = s(1);
    
    I = zeros(d);
    ps = sum(X) / N;
    cps = 1 - ps;
    
    
    for i=1:d
        for j=i:d
            
            p00 = sum(~X(:,i) & ~X(:,j));
            p01 = sum(~X(:,i) & X(:,j));
            p10 = sum(X(:,i) & ~X(:,j));
            p11 = sum(X(:,i) & X(:,j));
            pxy = [p00 p01 p10 p11]./N;
            
            pxpy = [cps(i)*cps(j) cps(i)*ps(j) ps(i)*cps(j) ps(i)*ps(j)];
            Is = pxy .* log(pxy./pxpy)./log(2);
            Is(isnan(Is) | isinf(Is)) = 0;
            
            I(i,j) = sum(Is);
            I(j,i) = I(i,j);
            
           
        end
    end