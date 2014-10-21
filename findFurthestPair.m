function [point1,point2,maxD] = findFurthestPair(x)
    
    N = length(x(:,1));
    
    
    point1 = 1;
    D = zeros(N,N);
    D(2:end,1) = find_distances(x(1,:),x(2:end,:));
    %D(1,2:end) = D(2:end,1)';
    [maxD,point2] = max(D(:,1));
    point2 = point2(1);
    
    D(3:end,2) = find_distances(x(2,:),x(3:end,:));
    %D(2,3:end) = D(3:end,2)';
    [tempMaxD,tempPoint2] = max(D(:,2));
    if tempMaxD > maxD
        point1 = 2;
        point2 = tempPoint2;
        maxD = tempMaxD;
    end
    
    for i=3:(N-1)
       
        Dbounds = zeros(i-1,N-i);
        parfor j=1:(i-1)
            Dbounds(j,:) = D(j,i) + D((i+1):end,j);
        end
        idxToTest = find(min(Dbounds) <= maxD);
        idxToTest = idxToTest + i;
        
        D(idxToTest,i) = find_distances(x(i,:),x(idxToTest,:));
        
        [tempMaxD,tempPoint2] = max(D(:,i));
        if tempMaxD > maxD
            point1 = i;
            point2 = tempPoint2;
            maxD = tempMaxD;
        end
        
    end
    
    