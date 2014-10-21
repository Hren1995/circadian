function [L,maxI,maxJ,maxVals] = segmentSpace(density,heightThreshold,absHeightThreshold)


    if nargin < 2 || isempty(heightThreshold)
        heightThreshold = .1;
    end
    
    if nargin < 3 || isempty(absHeightThreshold)
        absHeightThreshold = .4;
    end

    s = size(density);
    
    [maxI,maxJ] = find(imregionalmax(density));
    
    L = watershed(-density,8);
    numRegions = max(L(:));
    
    maxVals = zeros(numRegions,1);
    maxBoundaryVals = zeros(numRegions,1);
    maxPixels = zeros(numRegions,2);
    Q = false(size(density));
    for i=1:numRegions
        maxVals(i) = max(density(L==i));
        Q(:) = false;
        Q(L==i) = true;
        se = strel('disk',1);
        Q = imdilate(Q,se);
        w = bwboundaries(Q);
        w = w{1};
        [maxBoundaryVals(i),maxIdx] = max(diag(density(w(:,1),w(:,2))));
        maxPixels(i,:) = w(maxIdx,:);
    end
    
    
    idx = find((maxVals - maxBoundaryVals)./maxVals < heightThreshold & (maxVals - maxBoundaryVals) < absHeightThreshold);
    if ~isempty(idx);
    
        maxI = maxI(maxVals - maxBoundaryVals >= heightThreshold);
        maxJ = maxJ(maxVals - maxBoundaryVals >= heightThreshold);
        maxVals = maxVals(maxVals - maxBoundaryVals >= heightThreshold);
        
        A = L > 0;
        for i=1:length(idx)
            A(maxPixels(idx(i),1),maxPixels(idx(i),2)) = true;
        end
        
        CC = bwconncomp(A,8);
        L = zeros(size(A));
        for i=1:CC.NumObjects
            L(CC.PixelIdxList{i}) = i;
        end
        
        
        [iii,jjj] = find(L == 0);
        q = [1 -1;1 0;1 1;0 -1;0 1;-1 -1;-1 0;-1 1];
        for i=1:length(iii)
            a = iii(i);b = jjj(i);
            c = bsxfun(@plus,q,[a b]);
            c = c(max(c,[],2) <= min(s) & min(c,[],2) >= 1,:);
            d = unique(diag(L(c(:,1),c(:,2))));
            d = setdiff(d,0);
            if length(d) < 2
                L(a,b) = d(1);
            end
        end
        

        CC = bwconncomp(L > 0,8);
        L(:) = 0;
        for i=1:CC.NumObjects
            L(CC.PixelIdxList{i}) = i;
        end
        
    end