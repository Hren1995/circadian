function [zValues,zCosts,zGuesses,meanMax,exitFlags] = findTDistributedProjections_fmin_templates(data,means,yData,cdfFunctions,batchSize)

   
    readout = 5000;
    N = length(data(:,1));
    L = length(means(1,:));

    if nargin < 5 || isempty(batchSize)
        batchSize = N;
    end
          
    
    zValues = zeros(N,2);
    zGuesses = zeros(N,2);
    zCosts = zeros(N,1);
    batches = ceil(N/batchSize);
    meanMax = zeros(N,1);
    exitFlags = zeros(N,1);
    
    options = optimset('Display','off','maxiter',100);
    
    for j=1:batches
        fprintf(1,'\t Processing batch #%4i out of %4i\n',j,batches);
        idx = (1:batchSize) + (j-1)*batchSize;
        idx = idx(idx <= N);
        current_guesses = zeros(length(idx),2);
        current = zeros(length(idx),2);
        currentData = data(idx,:);
        tCosts = zeros(size(idx));
        
        fprintf(1,'\t\t Calculating Distances\n');
        D = findListKLDivergences(currentData,means);
        fprintf(1,'\t\t Calculating Similarities and Probabilities\n');
        S = zeros(size(D));
        parfor k=1:L
            S(:,k) = cdfFunctions{k}(D(:,k));
        end
        
        sumS = sum(S,2);
        idx2 = find(sumS==0);
        if ~isempty(idx2)
            for k=1:length(idx2)
                [~,maxIdx] = min(D(idx2(k),:));
                S(idx2(k),maxIdx) = 1;
            end
            sumS(idx2) = sum(S(idx2,:),2);
        end
        P = bsxfun(@rdivide,S,sumS);
        
        clear S D
        unix('purge');
        
        current_meanMax = zeros(length(idx),1);
        
        fprintf(1,'\t\t Estimating Points\n');
        parfor i=1:length(idx)
            
            if mod(i,readout) == 0
                fprintf(1,'\t\t\t Image #%5i\n',i);
            end
            
            q = P(i,:);
            
            [~,maxIdx] = max(q);
            a = sum(bsxfun(@times,yData,q'));
            
            guesses = [a;yData(maxIdx,:)];
            
            b = zeros(2,2);
            c = zeros(2,1)
            flags = zeros(2,1);
            
            
            [b(1,:),c(1),flags(1)] = fminsearch(@(x)calculateKLCost(x,yData,q),guesses(1,:),options);
            [b(2,:),c(2),flags(2)] = fminsearch(@(x)calculateKLCost(x,yData,q),guesses(2,:),options);
            
            
            [~,mI] = min(c);
            
            exitFlags(i) = flags(mI);
            current_guesses(i,:) = guesses(mI,:);
            current(i,:) = b(mI,:);
            tCosts(i) = c(mI);
            current_meanMax(i) = mI;
            
        end
        
        clear P
        
        zGuesses(idx,:) = current_guesses;
        zValues(idx,:) = current;
        zCosts(idx) = tCosts;
        meanMax(idx) = current_meanMax;
        
    end


