function [minIdx,maxIdx,minVals,maxVals] = findLocalMaxAndMin(x)

        
    minIdx = imregionalmin(x);
    maxIdx = imregionalmax(x);
    
    minVals = x(minIdx);
    maxVals = x(maxIdx);
    
    