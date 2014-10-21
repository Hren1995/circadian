function [yData,signalData,numReplaced,fracNotInHull] = findRefinedEmbedding(yData,signalData,dataFiles,spacing,perplexity,batchSize,relTol)


    if nargin < 4 || isempty(spacing)
        spacing = 5;
    end
    
    if nargin < 5 || isempty(perplexity)
        perplexity = 30;
    end
    
    if nargin < 6 || isempty(batchSize)
        batchSize = 20000;
    end
    
    if nargin < 6 || isempty(relTol)
        relTol = 1e-3;
    end

    sigmaTolerance = 1e-5;
    maxNeighbors = perplexity * 6;
    L = length(dataFiles);
    fracNotInHull = zeros(L,1);
    numReplaced = zeros(L,1);

    
    if length(yData(:)) > 1
        
        N = length(yData(:,1));
        fprintf(1,'Finding Initial KL divergences\n');
        KLsums = findKLsums(signalData,yData,perplexity,sigmaTolerance);
        
    else
        
        N = yData;
        fprintf(1,'Loading Initial Data File...\n');
        load(dataFiles{1},'normalizedWavelets');
        nn = length(normalizedWavelets(:,1));
        signalData = normalizedWavelets(randperm(nn,N),:);
        clear normalizedWavelets        
        unix('purge');
        fprintf(1,']\n');
        
        fprintf(1,'Finding Distances for New Data Set\n');
        [D,~] = findKLDivergences(signalData);
        unix('purge');
        
        fprintf(1,'Embedding Initial Data Set\n');
        figure
        [yData,~,P,Q] = tsne_d(D, [1;ones(N-1,1)+1], 2, perplexity, relTol);
        
        clear D
        unix('purge');
        
        fprintf(1,'Finding KL divergences\n');
        KLsums = findKLsums(P,Q,perplexity,sigmaTolerance);
                
        clear P Q
        
        unix('purge');
                
    end
    
    maxToReplace = round(N * .2);
    for i=1:L
        
        fprintf(1,'Loading Data File #%3i out of %3i...\n',i,L);
        load(dataFiles{i},'normalizedWavelets');
        normalizedWavelets = normalizedWavelets(1:spacing:end,:);
        unix('purge');
        fprintf(1,']\n');
                
        matlabpool 12
        
        fprintf(1,'Processing Data File #%3i out of %3i...\n',i,L);
        [~,~,~,inConvHull,~] = findTDistributedProjections_fmin(...
            normalizedWavelets,signalData,yData,perplexity,batchSize,maxNeighbors,sigmaTolerance);
        
        fracNotInHull(i) = sum(~inConvHull)/length(inConvHull);
        
        matlabpool close
        
        idx = find(~inConvHull);
        if length(idx) > maxToReplace
            idx = idx(randperm(length(idx),maxToReplace));
        end
        
        if ~isempty(idx)
            [~,idx2] = sort(KLsums);
            signalData(idx2(1:length(idx)),:) = normalizedWavelets(idx,:);
            numReplaced(i) = length(idx);
        else
            numReplaced(i) = 0;
        end
        
        clear normalizedWavelets inConvHull
        unix('purge');
        
        fprintf(1,'Finding Distances for New Data Set\n');
        [D,~] = findKLDivergences(signalData);
        
        %matlabpool close
        
        unix('purge');
        
        fprintf(1,'Embedding New Data Set\n');
        figure
        [yData,~,P,Q] = tsne_d(D, [1;ones(N-1,1)+1], 2, perplexity, relTol);
        
        clear D
        unix('purge');
        
        fprintf(1,'Finding KL divergences\n');
        KLsums = findKLsums(P,Q,perplexity,sigmaTolerance);
        
        
        clear P Q
        %matlabpool 12
        
        unix('purge');
        
    end
    
    
    