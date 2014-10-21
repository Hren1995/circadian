function D2 = findSquaredDistances(X,Y)

    N = length(X(:,1));

    if nargin == 1 || isempty(Y)

        Y = X;
        M = N;
        normsX = zeros(N,M);
        for i=1:N
            normsX(i,:) = norm(X(i,:));
        end
        normsY = normsX';
        
        
    else
        
        
        M = length(Y(:,1));
        
        normsX = zeros(N,M);
        normsY = zeros(N,M);
        for i=1:min(N,M)
            normsX(i,:) = norm(X(i,:));
            normsY(:,i) = norm(Y(i,:));
        end
        
        if N > M
            for i=M+1:N
                normsX(i,:) = norm(X(i,:));
            end
        else
            for i=N+1:M
                normsY(:,i) = norm(Y(i,:));
            end
        end
        
    
    end
    
    
    D2 = abs(-2*X*Y' + normsX.^2 + normsY.^2);