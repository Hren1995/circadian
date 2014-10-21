function [P,S,means,cdfFunctions,P2,S2] = returnGroupProbabilityMatrices(templates,pThreshold)


    L=length(templates);
    means = zeros(L,1250);
    
    fprintf(1,'Calculating Means\n');
    for i=1:L
        means(i,:) = mean(templates{i});
    end
    
    fprintf(1,'Calculating CDFs\n');
    cdfFunctions = cell(L,1);
    parfor i=1:L
        D = findListKLDivergences(templates{i},means(i,:));
        [Y,X] = hist(D,1000);
        cdfFunctions{i} = fit([0 X 10000]',1-[0 cumsum(Y)./sum(Y) 1]','linearinterp');
    end
    
    fprintf(1,'Calculating Similarities\n');
    S = eye(L);
    S2 = eye(L);
    parfor i=1:L
        if mod(i,50) == 0
            fprintf('\t Template #%4i\n',i);
        end
        D = findListKLDivergences(templates{i},means);
        temp = zeros(1,L);
        temp2 = zeros(1,L);
        for j=1:L
            a = cdfFunctions{j}(D(:,j));
            temp(j) = mean(a > pThreshold);
            temp2(j) = mean(a);
        end
        S(i,:) = temp;
        S2(i,:) = temp2;
    end
    
    fprintf(1,'Finding Transition Matrix\n');
    P = S;
    P(1:L+1:end) = 0;
    P = bsxfun(@rdivide,P,sum(P,2));
    P = P + P';
    P = P ./ sum(P(:));
    
    P2 = S2;
    P2(1:L+1:end) = 0;
    P2 = bsxfun(@rdivide,P2,sum(P2,2));
    P2 = P2 + P2';
    P2 = P2 ./ sum(P2(:));
    
    