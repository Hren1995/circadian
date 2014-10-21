function SamplingWrapper(cores)

%f = fopen(fnfile);
%files = textscan(f,'%s');
%files = files{1};
%fclose(f);

if matlabpool('size') ~= 0
	matlabpool close force
end

matlabpool(cores) 

outputPath = '/Genomics/grid/users/dmossing/tsne/sampledata/';

%%%% RUN IMPORTANT SAMPLING

fprintf('Running createSampleData.m...\n');

[signalData,signalAmps,runData] = createSampleData(outputPath);

%%% SAVE OUTPUT FILES

fprintf('Saving output files...\n');

save([outputPath 'SampleDataOutput.mat'],'signalData','signalAmps','runData');

fprintf('Finding KL Divergences...\n');
[D,~] = findKLDivergences(signalData);

fprintf('Running tsne...\n');
[ydata,betas,P,Q] = tsne_d(D);

fprintf('Saving Files...\n');
save([outputPath 'SpaceOutput.mat'],'ydata','betas','P','signalAmps','signalData');

%fprintf('\n\n\nMatlab Function Completed.')

matlabpool close

fprintf('\n\n\nMatlab function completed.');
