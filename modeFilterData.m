function y = modeFilterData(x,windowSize)

    N = length(x);
    y = zeros(size(x));
    
    for i=1:N
        minVal = max(1,i-windowSize);
        maxVal = min(N,i+windowSize);
        [y(i),~,c] = mode(x(minVal:maxVal));
        
        count = 1;
        while length(c{1}) > 1
            minVal = max(1,i-windowSize-count);
            maxVal = min(N,i+windowSize+count);
            [y(i),~,c] = mode(x(minVal:maxVal));
            count = count + 1;
        end
    end