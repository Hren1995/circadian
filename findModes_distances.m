function [modes,medians] = findModes_distances(data,b,samples)

    %matlabpool(7);

    N = length(data(:,1));
    if samples > N
        samples = N;
    end
    
    K = zeros(N,1);
    d = zeros(N,1);
    parfor i=1:N
        ds = findSubsetDistances(data,randperm(N,samples),i);
        d(i) = sum(ds);
        K(i) = sum(exp(-.5.*ds./b.^2));
    end
    
    [~,idx] = max(K);
    modes = data(idx(1),:);
    [~,idx] = min(d);
    medians = data(idx(1),:);
    %matlabpool close