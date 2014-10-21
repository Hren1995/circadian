function y = quickFilterData(x,filterRange,samplingFrequency)

    fx = fft(x);
    L = length(x);
    amps = abs(fx);
    phases = angle(fx);
    
    
    if nargin < 3
        samplingFrequency = 1;
    end
    
    if nargin > 2 && ~isempty(filterRange)
        
        fs = .5*linspace(0,1,ceil(L/2))*samplingFrequency;
        
        minIdx = find(fs < filterRange(1),1,'last');
        
        maxIdx = find(fs > filterRange(2),1,'first');
        
        if ~isempty(minIdx)
            amps(1:minIdx) = 0;
            amps(end-(minIdx-1)) = 0;
        end
        
        if ~isempty(maxIdx)
            amps(maxIdx:end-(maxIdx-1)) = 0;
        end
        
    end
    
    y = real(ifft(amps.*exp(1i .* phases)));