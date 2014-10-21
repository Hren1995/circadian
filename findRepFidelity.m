function [numberRegions,Representation,Fidelity,zeroethBin]=findRepFidelity(sigma,yData,signalData)

numberRegions = zeros(length(sigma),1);
Representation = zeros(length(sigma),1);
Fidelity = zeros(length(sigma),1);
zeroethBin = zeros(length(sigma),1);


%%% Sigma Loop
parfor i = 1:length(sigma)
	fprintf('Sigma = %f ... findPointDensity ... ',sigma(i));
	%%% findPointDensity

	[xx,density,~,~] = findPointDensity(yData,sigma(i));

	fprintf('finding watershed ... ');
	%%% Watershed

	LL = watershed(-density,8);
	%LL2 = LL; LL2(density < 1e-6) = 0;
	%a = unique(LL2);a = setdiff(a,0);
    LL2 = LL;
    numberRegions(i) = max(LL2(:));




	%%% Setting Up yData to Pixel mapping

    yPos = round((yData + max(xx))*length(xx)/(2*max(xx)));
    yPos(yPos<1) = 1;
    yPos(yPos>length(xx)) = length(xx);


%	yPos = zeros(length(yData),2);
%	for j = 1:length(yData)
%		dx = abs(repmat(yData(j,1),length(LL2),1) - xx');
%       dy = abs(repmat(yData(j,2),length(LL2),1) - xx');
%		yPos(j,1) = find(dx == min(dx));
%		yPos(j,2) = find(dy == min(dy));
%	end

N = length(yData);

yCluster = zeros(N,1);
for j=1:N
    yCluster(j) = diag(LL(yPos(j,2),yPos(j,1)));
end

                           
	%%% Set Cluster labels
	%yCluster = zeros(length(yData),1);
	%for j = 1:length(yData)
%		yCluster(j) = LL2(yPos(j,1),yPos(j,2));
%	end
	
	zeroethBin(i) = length(yCluster(yCluster == 0));
	yUni = unique(yCluster);
	yUni = yUni(yUni ~= 0);

	fprintf('finding Representation and Fidelity ... ');
	%%% Representation (Entropy) and Fidelity

	H = 0;
	Delta = 0;
	for j = 1:length(yUni)
		idx = find(yCluster == yUni(j));
        if length(idx) > 0
            H = H + (length(idx)/length(yData))*log2(length(idx)/length(yData));
            m = signalData(idx,:);
            kl = findKLDivergences(m);
            kl(isnan(kl) | isinf(kl)) = 0;
            Delta = Delta + length(idx)*mean(kl(kl>0))/sum(yCluster>0);
        end
        
	end
	H = -1*H;

	Representation(i) = H;
	Fidelity(i) = Delta;
	fprintf('Done!\n');
end