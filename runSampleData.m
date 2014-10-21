function runSampleData(files,outputPath,numPoints,perplexity,rtol)


    L = length(files);
    
    if nargin < 3 || isempty(numPoints)
        numPoints = 10000;
    end
    
    if nargin < 4 || isempty(perplexity)
        perplexity = 20;
    end
    
    if nargin < 5 || isempty(rtol)
        rtol = 2e-3;
    end
    
    
    for i=1:L

        load(files{i},'data','amps');

        
        N = length(data(:,1));
        
        signalIdx = randperm(N,numPoints);
        signalData = data(signalIdx,:);
        signalAmps = amps(signalIdx);
        
        clear data;
        unix('purge');clear ans;
        
        [D,~] = findKLDivergences(signalData);
        [yData,betas] = tsne_d(D, log(signalAmps)./log(10), 2, perplexity, rtol);
        
        currentFile = files{i};
        
        q = num2str(i);
        
        save([outputPath '/' repmat('0',1,2-length(q)) q '.mat'],...
            'betas','yData','signalData','currentFile','signalIdx','signalAmps','');
        
        clear D yData beta signalAmps signalIdx signalData
        unix('purge');clear ans
        
    end
    
    
