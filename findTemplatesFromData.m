function [signalData,signalAmps,runData] = findTemplatesFromData(files,numPerDataSet,kdNeighbors)


    L = length(files);
    
    if nargin < 2 || isempty(numPerDataSet)
        numPerDataSet = 800;
    end
    
    if nargin < 3 || isempty(kdNeighbors)
        kdNeighbors = 5;
    end

    minTemplateLength = 1;
    plotsOn = false;
    
    selectedData = cell(L,1);
    selectedAmps = cell(L,1);
    sigmas = zeros(L,1);
    densities = cell(L,1);
    minMax = zeros(L,2);
    watersheds = cell(L,1);

    for i=1:L
        fprintf(1,'Processing File #%2i out of %2i\n',i,L);
        
        fprintf(1,'\t Loading Data\n');
        load(files{i},'yData','signalAmps','signalData');
        
        fprintf(1,'\t Finding Templates\n');
        [templates,xx,densities{i},sigmas(i),templateLengths,watersheds{i},vals] = ...
            returnTemplates(yData,signalData,minTemplateLength,kdNeighbors,plotsOn);
        
        minMax(i,1) = min(xx);
        minMax(i,2) = max(xx);
        
        
        N = length(templates);
        d = length(signalData(1,:));
        selectedData{i} = zeros(numPerDataSet,d);
        selectedAmps{i} = zeros(numPerDataSet,1);
        
        numInGroup = round(numPerDataSet*templateLengths/sum(templateLengths));
        numInGroup(numInGroup == 0) = 1;
        sumVal = sum(numInGroup);
        if sumVal < numPerDataSet
            q = numPerDataSet - sumVal;
            idx = randperm(N,q);
            numInGroup(idx) = numInGroup(idx) + 1;
        else
            if sumVal > numPerDataSet
                q = sumVal - numPerDataSet;
                idx2 = find(numInGroup > 1);
                Lq = length(idx2);
                if Lq < q
                    idx2 = 1:length(numInGroup);
                end
                idx = randperm(length(idx2),q);
                numInGroup(idx2(idx)) = numInGroup(idx2(idx)) - 1;
            end
        end
        cumSumGroupVals = [0; cumsum(numInGroup)];
        
        
        for j=1:N;
            
            amps = signalAmps(vals == j);
 
            idx2 = randperm(length(templates{j}(:,1)),numInGroup(j));
            selectedData{i}(cumSumGroupVals(j)+1:cumSumGroupVals(j+1),:) = templates{j}(idx2,:);
            selectedAmps{i}(cumSumGroupVals(j)+1:cumSumGroupVals(j+1)) = amps(idx2);
            
        end
        
        clear D idx amps maxIdx signalData signalAmps yData;
        
        
    end
    
    
    N = sum(returnCellLengths(selectedAmps));
    signalData = zeros(N,d);
    signalAmps = zeros(N,1);
    count = 1;
    for i=1:L
        
        K = numPerDataSet;
        signalData(count:count+K-1,:) = selectedData{i}(1:numPerDataSet,:);
        signalAmps(count:count+K-1) = selectedAmps{i}(1:numPerDataSet);
        
        count = count + K;
        
    end
    
    
    
    
    runData.sigmas = sigmas;
    runData.densities = densities;
    runData.minMax = minMax;
    runData.watersheds = watersheds;
    runData.numPerDataSet = numPerDataSet;
    runData.kdNeighbors = kdNeighbors;
    
    
    

    
    

