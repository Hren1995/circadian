function [signalData,signalAmps,signalIdx] = calculateWavelets(Scores)
	[Wavelets,frequencies] = wavelet_wrapper(Scores);

	amps = sum(Wavelets,2);
	parfor j = 1:size(Wavelets,2)
		Wavelets(:,j) = Wavelets(:,j)./amps;
	end
        
        N = size(Wavelets,1);
	sampleDataSize = sampleDataSize + N;
        
        signalIdx = randperm(N,numPoints);
        signalData = Wavelets(signalIdx,:);
        signalAmps = amps(signalIdx);
        
        clear Wavelets;
        unix('purge');clear ans;
end
