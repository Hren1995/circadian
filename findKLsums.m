function [KLsums,KL] = findKLsums(signalData,yData,perplexity,sigmaTol)


    N = length(signalData(:,1));

    if ~issparse(signalData)

        maxNeighbors = round(perplexity * 6);
        
        
        [D,~] = findKLDivergences(signalData);
        [P, ~] = d2p_sparse(D, perplexity, sigmaTol, maxNeighbors);
        
        P = (P + P');
        P = P ./ sum(P(:));
        
        Q = findAllDistances(yData);
        Q = 1 ./ (1 + Q.^2);
        Q(1:(N+1):end) = 0;
        Q = Q ./ sum(Q(:));
        
    else
        
        P = signalData;
        Q = yData;
        
    end
    
    idx = P > 0 & Q > 0;
    [ii,jj] = ind2sub(size(P),find(idx > 0));
    
    q = P(idx) .* log(P(idx)./Q(idx));
    KL = sparse(ii,jj,q,N,N);
    KLsums = .5*(sum(KL) + sum(KL,2)');