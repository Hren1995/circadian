function zValues = findWeightedProjections(data,signalData,yData,batchSize)


    if nargin < 4 || isempty(batchSize)
        batchSize = 20000;
    end

    readout = 2500;
    
    N = length(data(:,1));
    zValues = zeros(N,2);
    batches = ceil(N/batchSize);
    for j=1:batches
        fprintf(1,'\t Processing batch #%4i out of %4i\n',j,batches);
        idx = (1:chunkSize) + (j-1)*chunkSize;
        idx = idx(idx <= N);
        current = zeros(length(idx),2);
        currentData = data(idx,:);
        DD = findListKLDivergences(currentData,signalData);
        parfor i=1:length(idx)
            if mod(i,readout) == 0
                fprintf(1,'\t\t Image #%5i\n',i);
            end
            [~,p] = returnCorrectSigma(DD(i,:));
            current(i,:) = sum(bsxfun(@times,yData,p'));
        end
        zValues(idx,:) = current;
    end
