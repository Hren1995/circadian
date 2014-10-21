function [T,Tchange,fracInState,stateProbabilities] = find2DTransitionProbabilities(data)
    %data must be positive-integer valued
    %T(i,j,idx) = transition probability between group i,j and idx,
    %where idx = sub2ind(size(T(i,j,1),i,j)
    
    q = max(data);
    L = length(data(:,1));
    
    T = zeros(q(1),q(2),prod(q));
    Tchange = zeros(q(1),q(2),prod(q));
    fracInState = zeros(q(1),q(2));
    stateProbabilities = zeros(q(1),1);
    for i=1:q(1)
        
        iIdx = find(data(:,1) == i);
        stateProbabilities(i) = length(iIdx) ./ L;
        
        for j=1:q(2)
            idx = intersect(iIdx,find(data(:,2)==j));
            fracInState(i,j) = length(idx) / L;
            z = idx + 1;
            if z(end) == L + 1
                z = idx(1:end-1);
            end
            
            nextIdx = sub2ind(q,data(z,1),data(z,2));
            
            if ~isempty(nextIdx)
                
                for k=1:prod(q)
                    T(i,j,k) = sum(nextIdx==k)/length(nextIdx);
                end
                
                kCurrent = sub2ind(q,i,j);
                Tchange(i,j,:) = T(i,j,:);
                Tchange(i,j,kCurrent) = 0;
                if sum(Tchange(i,j,:)) > 0
                    Tchange(i,j,:) = Tchange(i,j,:) ./ sum(Tchange(i,j,:));
                end
                
            end
        end
    end