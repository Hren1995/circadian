function images = plotTemplateHistograms(templates,bins,yrange,numPoints,means,logGrams)
    %makes template histogram plot
    
    %Inputs:
    
    %templates -> L x 1 cell array of templates (or groupings)
    %bins -> number of bins in each column (default = 50)
    %means -> lines to be plotted on top of histograms (the template mean
    %           if unspecified)

    N = length(templates);
    

    if nargin < 2 || isempty(bins)
        bins = 50;
    end

    if nargin < 3 || isempty(yrange) || length(yrange) < 2
        maxVal = -1e99;
        minVal = 1e99;
        for i=1:N
            a = max(templates{i}(:));
            b = min(templates{i}(:));
            if a > maxVal
                maxVal = a;
            end
            if b < minVal
                minVal = b;
            end
        end
        yrange = [minVal maxVal];
    end
    
    
    if nargin < 4 || isempty(numPoints)
        for i=1:N
            if ~isempty(templates{i})
                numPoints = length(templates{i}(1,:));
                break;
            end
        end
    end
    
    
    if nargin < 5 || isempty(means) || length(means) ~= N
        means = cell(N,1);
        for i = 1:N
            means{i} = mean(templates{i});
        end
    end
    
    
    if nargin < 6 || isempty(logGrams)
        logGrams = false;
    end
    
    
    
    L = ceil(sqrt(N));
    M = ceil(N/L);
    q = L;
    L = M;
    M = q;
    clear q
    images = cell(N,1);
    for i=1:N
        
        if ~isempty(templates{i})
            
            subplot(M,L,i)
            
            xx = linspace(yrange(1),yrange(2),bins);
            Z = zeros(numPoints,bins);
            for j=1:numPoints
                Z(j,:) = hist(templates{i}(:,j),xx);
                Z(j,:) = [0 Z(j,2:end-1) ./ sum(Z(j,2:end-1)) 0];
            end
            
            hold off
            
            if logGrams
                pcolor(1:numPoints,xx,log(Z')./log(10));
            else
                pcolor(1:numPoints,xx,Z');caxis([0 .15])
            end
            shading flat
            hold on
            
            if length(templates{i}(:,1)) > 1
                plot(1:numPoints,means{i}(1:numPoints),'k-','linewidth',2)
                title(['Template #' num2str(i) ', N = ' num2str(length(templates{i}(:,1)))]);
            end
            
            images{i} = Z;
        end
        
    end
    
    
    
    