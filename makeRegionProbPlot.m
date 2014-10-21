function [regionProbs,probs] = makeRegionProbPlot(density,L)

    regionProbs = zeros(size(density));
    Lvals = setdiff(unique(L),0);
    summedVals = zeros(length(Lvals),1);
    
    
    for i=1:length(Lvals)
        
        idx = L == Lvals(i);
        summedVals(i) = sum(density(idx));
        regionProbs(idx) = summedVals(i);
        
    end
    
    regionProbs = regionProbs ./ sum(summedVals);
    probs = summedVals ./ sum(summedVals);