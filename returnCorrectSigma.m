function [sigma,p] = returnCorrectSigma(ds,perplexity,tol,maxNeighbors)


    if nargin < 2 || isempty(perplexity)
        perplexity = 32;
    end


    if nargin < 3 || isempty(tol)
        tol = 1e-2;
    end

    
    highGuess = max(ds);
    lowGuess = 1e-10;

    sigma = .5*(highGuess + lowGuess);
    p = exp(-.5*ds.^2./sigma^2);
    p = p./sum(p);
    idx = p>0;
    H = sum(-p(idx).*log(p(idx))./log(2));
    P = 2^H;
    
    if abs(P-perplexity) < tol
        test = false;
    else
        test = true;
    end
    
    while test
        
        if P > perplexity
            highGuess = sigma;
        else
            lowGuess = sigma;
        end
        
        sigma = .5*(highGuess + lowGuess);
        
        p = exp(-.5*ds.^2./sigma^2);
        p = p./sum(p);
        idx = p>0;
        H = sum(-p(idx).*log(p(idx))./log(2));
        P = 2^H;
        
        if abs(P-perplexity) < tol
            test = false;
        end
        
    end
    
    
    if nargin == 4 && maxNeighbors > 0
        [~,sortIdx] = sort(p,'descend');
        sortIdx = sortIdx(1:maxNeighbors);
        p2 = zeros(size(p));
        p2(sortIdx) = p(sortIdx);
        p = p2 ./ sum(p2);
    end
        