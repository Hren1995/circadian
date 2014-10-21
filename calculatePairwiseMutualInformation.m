function [I,Z,Y,xx,output] = calculatePairwiseMutualInformation(x,y,bins)

    s = size(x);
    if s(1) == 1
        x = x';
    end
    s = size(y);
    if s(1) == 1
        y = y';
    end

    if length(bins) == 1
        [Z,xx] = hist3([x y],[bins bins]);
    else
        [Z,xx] = hist3([x y],{bins bins});
    end
    dxdy = (xx{1}(2)-xx{1}(1))*(xx{2}(2)-xx{2}(1));
    Z = Z ./ (sum(Z(:))*dxdy);
    
    Y = zeros(bins,2);
    Y(:,1) = hist(x,xx{1});
    Y(:,1) = Y(:,1) ./ (sum(Y(:,1)) * (xx{1}(2)-xx{1}(1)));
    
    Y(:,2) = hist(y,xx{2});
    Y(:,2) = Y(:,2) ./ (sum(Y(:,2)) * (xx{2}(2)-xx{2}(1)));
    
    X = log(Z ./ (Y(:,1) * Y(:,2)'))/log(2);
    X(isnan(X) | isinf(X)) = 0;
    
    output = ifft2(fft2(Z).*fft2(X));
    
    I = output(1,1);
        
        