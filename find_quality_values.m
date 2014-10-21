function [Qs,vals] = find_quality_values(D1,D2,ks)

    L = length(ks);
    
    readout = 1000;
    
    N = length(D1(:,1));

    s = size(D1);
    if s(1) ~= s(2);
        [D1,~] = findKLDivergences(D1);
    end
    
    s = size(D2);
    if s(1) ~= s(2);
        D2 = findAllDistances(D2);
    end
    
    
    vals = zeros(N,L);
     
    parfor i=1:N
        
        a = zeros(1,L);
        
        if mod(i,readout) == 0
            fprintf(1,'Point #%6i\n',i);
        end
        
        [~,idx] = sort(D1(i,:));
        [~,idx2] = sort(D2(i,:));
        
        for j=1:L
            a(j) = length(intersect(idx(2:(ks(j)+1)),idx2(2:(ks(j)+1))));
        end
        
        vals(i,:) = a;
        
        
    end
    
    Qs = bsxfun(@rdivide,sum(vals),ks) ./ N;