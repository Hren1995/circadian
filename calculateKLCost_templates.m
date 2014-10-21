function out = calculateKLCost_templates(x,ydata,P)


    d = findListDistances(x,ydata);
    d = d.^2;
    out = log(sum((1+d).^-1)) + sum(P.*log(1+d));