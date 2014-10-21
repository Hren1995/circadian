function [zValues,zCosts,zGuesses] = findTDistributedProjections(data,signalData,yData,perplexity,numPoints,halfWidth,batchSize)

    
    if nargin < 4 || isempty(perplexity)
        perplexity = 30;
    end
    
    if nargin < 5 || isempty(numPoints)
        numPoints = 25;
    end
    
    if nargin < 6 || isempty(halfWidth)
        halfWidth = 15;
    end
    
    if nargin < 7 || isempty(batchSize)
        batchSize = 20000;
    end
    
    tolerance = .01;
    readout = 100;
    maxNeighbors = 50;
    
    N = length(data(:,1));
    zValues = zeros(N,2);
    zGuesses = zeros(N,2);
    zCosts = zeros(N,1);
    batches = ceil(N/batchSize);

    
    for j=1:batches
        fprintf(1,'\t Processing batch #%4i out of %4i\n',j,batches);
        idx = (1:batchSize) + (j-1)*batchSize;
        idx = idx(idx <= N);
        current_guesses = zeros(length(idx),2);
        current = zeros(length(idx),2);
        currentData = data(idx,:);
        tCosts = zeros(size(idx));
        D2 = findListKLDivergences(currentData,signalData);
        
        parfor i=1:length(idx)
            if mod(i,readout) == 0
                fprintf(1,'\t\t Image #%5i\n',i);
            end
            [~,p] = returnCorrectSigma(D2(i,:),perplexity,tolerance,maxNeighbors);
            idx2 = p>0;
            a = sum(bsxfun(@times,yData,p'));
            current_guesses(i,:) = a;
            
            xx = linspace(a(1)-halfWidth,a(1)+halfWidth,numPoints);
            yy = linspace(a(2)-halfWidth,a(2)+halfWidth,numPoints);
            [XX,YY] = meshgrid(xx,yy);
            Z = [reshape(XX,[length(xx)^2,1]) reshape(YY,[length(yy)^2,1])];
            
            DD = findListDistances(Z,yData(idx2,:));
            chis = 1 ./ (1 + DD.^2);
            %q = bsxfun(@rdivide,chis,sum(chis,2));
            %m = .5*(bsxfun(@plus,p(idx2),q));
            %costs = .5*sum(bsxfun(@times,p(idx2),log(bsxfun(@rdivide,p(idx2),m))./log(2)) + ...
            %    bsxfun(@times,q,log(q./m)./log(2)),2);
            %costs1 = sum(bsxfun(@times,p(idx2),log(bsxfun(@rdivide,p(idx2),m))./log(2)),2);
            %costs2 = sum(bsxfun(@times,q,log(q./m)./log(2)),2);
            costs = -sum(bsxfun(@times,p(idx2),log(bsxfun(@rdivide,chis,sum(chis,2)))),2);
            
            [minVal,minIdx] = min(costs);
            current(i,:) = Z(minIdx,:);
            tCosts(i) = minVal;
                        
        end
        zGuesses(idx,:) = current_guesses;
        zValues(idx,:) = current;
        zCosts(idx) = tCosts;
        
    end