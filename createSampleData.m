function [signalData,signalAmps,runData] = createSampleData(files,outputPath,sampleDataSize,...
                                                numPoints,perplexity,rtol,kdNeighbors)


    if nargin < 3 || isempty(sampleDataSize)
        sampleDataSize = 32000;
    end
    
    if nargin < 4 || isempty(numPoints)
        numPoints = 10000;
    end
    
    if nargin < 5 || isempty(perplexity)
        perplexity = 20;
    end
    
    if nargin < 6 || isempty(rtol)
        rtol = 2e-3;
    end
    
    if nargin < 7 || isempty(kdNeighbors)
        kdNeighbors = 5;
    end
    
    
    [status,~]=unix(['ls ' outputPath]);
    if status == 1
        unix(['mkdir ' outputPath]);
    end
    
    
    runSampleData(files,outputPath,numPoints,perplexity,rtol);
    
    L = length(files);
    numPerDataSet = round(sampleDataSize / L);
    
    
    [signalData,signalAmps,runData] = findTemplatesFromData(files,numPerDataSet,kdNeighbors);