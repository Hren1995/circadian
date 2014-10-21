function [obj,AICs] = findBestGMM_AIC(data,maxPeaks,replicates)

    if nargin < 3 || isempty(replicates)
        replicates = 1;
    end
    %options = statset('MaxIter',10000,'Robust','on');
    
    
    
    AICs = zeros(maxPeaks,1);
    objs = cell(maxPeaks,1);
    for i=1:maxPeaks
        %objs{i} = gmdistribution.fit(data,i,'Options',options,'Replicates',replicates,'Regularize',1e-30);
        objs{i} = gmixPlot(data,i,[],[],true,[],[],[],replicates);
        AICs(i) = objs{i}.AIC;
    end
    
    minIdx = argmin(AICs);
    
    obj = objs{minIdx};