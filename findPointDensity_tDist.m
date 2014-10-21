function [xx,density,G,Z] = findPointDensity_tDist(points,numPoints,rangeVals)

    if nargin < 2 || isempty(numPoints)
        numPoints = 1001;
    else
        if mod(numPoints,2) == 0
            numPoints = numPoints + 1;
        end
    end
    
    if nargin < 3 || isempty(rangeVals)
        rangeVals = [-110 110];
    end

    xx = linspace(rangeVals(1),rangeVals(2),numPoints);
    yy = xx;
    [XX,YY] = meshgrid(xx,yy);
    dx = xx(2) - xx(1);
    
    
    G = 1./(pi*(1 + XX.^2 + YY.^2));
    
    %G = exp(-.5.*(XX.^2 + YY.^2)./sigma^2) ./ (2*pi*sigma^2);
    
    Z = hist3(points,{xx,yy});
    Z = Z ./ (sum(Z(:)));
    
    density = fftshift(real(ifft2(fft2(G).*fft2(Z))))';
    
    %imagesc(xx,yy,density)
    %axis equal tight
    %set(gca,'ydir','normal');