individualJS = cell(28,28);
individualJSdivs = zeros(28,28);
individualKL = cell(28,28);
individualKLdivs = zeros(28,28);
individualDiffs = cell(28,28);
individualDs = zeros(28);
for i=1:28
    for j=(i+1):28
        
        individualJS{i,j} = findMatrixJSDivergence(individualDensities{i},individualDensities{j},true);
        individualJSdivs(i,j) = sum(abs(individualJS{i,j}(:)));
        individualJS{j,i} = -individualJS{i,j};
        individualJSdivs(j,i) = individualJSdivs(i,j);
        
        [individualKL{i,j},individualKLdivs(i,j)] = findMatrixKLDivergence(individualDensities{i},individualDensities{j});
        [individualKL{j,i},individualKLdivs(j,i)] = findMatrixKLDivergence(individualDensities{j},individualDensities{i});
        
        individualDiffs{i,j} = (individualDensities{i} - individualDensities{j})./2;
        individualDiffs{j,i} = - individualDiffs{i,j};
        individualDs(i,j) = sum(abs(individualDiffs{i,j}(:)));
        individualDs(j,i) = individualDs(i,j);
    end
end



individualJSdivs = individualJSdivs.*(xx(2)-xx(1))^2;
individualKLdivs = individualKLdivs.*(xx(2)-xx(1))^2;
individualDs = individualDs.*(xx(2)-xx(1))^2;