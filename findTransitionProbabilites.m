function [T,Tnew,totals,density] = findTransitionProbabilites(states)
    %states must be integer-valued
    
    minVal = min(states);
    maxVal = max(states);
    num = maxVal - minVal + 1;
    values = minVal:maxVal;
    
    N = length(states);
    T = zeros(num,num);
    totals = zeros(num,num);
    Tnew = zeros(num,num);
    density = zeros(num,1);
    for i=1:num
        idx = find(states == values(i) & (1:N)' < N);
        nextIdx = idx + 1;
        nextStates = states(nextIdx);
        
        density(i) = length(idx) ./ (N-1);
        if ~isempty(nextStates)
            for j=1:num
                T(i,j) = sum(nextStates == values(j));
                totals(i,j) = T(i,j);
            end
            
            Tnew(i,:) = T(i,:);
            T(i,:) = T(i,:) ./ length(nextStates);
            Tnew(i,i) = 0;
            if sum(Tnew(i,:)) > 0
                Tnew(i,:) = Tnew(i,:) ./ sum(Tnew(i,:));
            end
        end
        

    end