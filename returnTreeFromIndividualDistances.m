function [tree,D] = returnTreeFromIndividualDistances(diffs,labels)

    N = length(diffs(:,1));
    labelVals = unique(labels);
    L = length(labelVals);
    
    D = zeros(L);
    for i=1:L
        for j=i:L
            a = diffs(labels==labelVals(i),labels==labelVals(j));
            D(i,j) = median(a(a>0));
            D(j,i) = D(i,j);
        end
    end
    
    DD = makePdistForm(D);
    tree = linkage(DD,'single');