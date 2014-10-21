function [threshold,Htotal,Hlow,Hhigh] = findEntropyThresholdFromBins(X,Y,plotsOn)

    if nargin < 3
        plotsOn = false;
    end

    L = length(X);
    z = cumsum(Y)./sum(Y);
    
    Htotal = zeros(1,L);
    Hlow = zeros(1,L);
    Hhigh = zeros(1,L);
    
    for j=2:(L-1)
        pLow = Y(1:j) ./ sum(Y(1:j));
        Hlow(j) = sum(-pLow.*log(pLow)./log(2));
        
        pHigh = Y((j+1):end) ./ sum(Y((j+1):end));
        Hhigh(j) = sum(-pHigh.*log(pHigh)./log(2));
    end
    
    Htotal = Hhigh + Hlow;
    
    [maxVal,threshold] = max(Htotal);
    threshold = X(threshold);
    
    
    if plotsOn
        
        figure
        hold on
        plot(X,Hlow,'b-')
        plot(X,Hhigh,'r-')
        plot(X,Htotal,'k-','linewidth',2)
        plot(threshold,maxVal,'ro-','markerfacecolor','r')
        
    end