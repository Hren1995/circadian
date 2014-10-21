function [X,C] = findSquareChangeParisomy(Y,tree)



    s = size(Y);
    N = s(1);
    k = length(tree(:,1));
           
    %find connectivity matrix
    A = zeros(N+k);
    for i=1:k
        
        b = tree(i,3);
        
        if tree(i,1) <= N
            A(tree(i,1),i+N) = 1/b;
            A(i+N,tree(i,1)) = 1/b;
        else
            q = b - tree(tree(i,1)-N,3);
            A(tree(i,1),i+N) = 1/q;
            A(i+N,tree(i,1)) = 1/q;
        end
        
        if tree(i,2) <= N
            A(tree(i,2),i+N) = 1/b;
            A(i+N,tree(i,2)) = 1/b;
        else
            q = b - tree(tree(i,2)-N,3);
            A(tree(i,2),i+N) = 1/q;
            A(i+N,tree(i,2)) = 1/q;
        end
    
    end
        
        
    %construct connectivity matrix
    C = -A(N+1:end,N+1:end);
    C(1:(k+1):end) = sum(A(N+1:end,:),2);
    
    
    %create Y vector
    yNew = zeros(k,s(2));
    for i=1:k
        yNew(i,:) = sum(Y(A(N+i,1:N)>0,:));
    end
    
    
    %compute ancestral values
    
    X = inv(C'*C)*C'*yNew;
    
    