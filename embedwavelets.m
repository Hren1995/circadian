function embedwavelets(wavfile,numProcessors)


%%% OPEN MATLAB POOL %%%

if matlabpool('size') ~= 0
    matlabpool close force
end

matlabpool(numProcessors)

%%% LOAD AND NORMALIZE WAVELETS %%%

fprintf(1,'Normalizing Wavelets\n');

load(wavfile);

amps = sum(Wavelets,2);

parfor i=1:length(Wavelets(1,:))
    Wavelets(:,i) = Wavelets(:,i) ./ amps;
end

fprintf('Wavelets Normalized!\n\n');

%%% LOAD EMBEDDING PARAMETER FILE %%%

load('/scratch/gpfs/dmchoi/aging_embedding_080713.mat');
fprintf('Parameter files loaded!\n\n');

%%% EMBEDDING FUNCTION %%%

fprintf('Beginning Embedding...\n\n');

[zValues,zCosts,zGuesses,inConvHull,meanMax,exitFlags] = findTDistributedProjections_fmin(Wavelets,signalData,yData);

fprintf('Embedding finished!\n\n');

%%% SAVE FILE %%%

fprintf('Saving outputs...\n\n');

fracNotInHull = (length(inConvHull)-sum(inConvHull))/length(inConvHull);
savename = strrep(wavfile,'wavelets','embedding');

save(savename,'zValues','zCosts','zGuesses','inConvHull','meanMax','exitFlags','startfile','fracNotInHull','-v7.3');

fprintf('Saving Complete!\n\n');

%%% FINISH BY CLOSING MATLAB POOL %%%

matlabpool close

fprintf('\n\n\n');
fprintf('Matlab Function Completed.');
