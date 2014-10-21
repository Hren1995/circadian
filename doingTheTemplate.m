function doingTheTemplate(files)

fprintf('Files loaded...\n')

sampleDataSize = 36000;
kdNeighbors = 5;
outputPath = '/scratch/gpfs/dmossing/tsne/BigSpace/';

L = length(files);
numPerDataSet = round(sampleDataSize / L);

fprintf('Running findTemplatesFromData...\n')

[signalData,signalAmps,runData] = findTemplatesFromData(files,numPerDataSet,kdNeighbors);

fprintf('Saving Output....\n')

save([outputPath 'SampleDataOutput.mat'],'signalData','signalAmps','runData');

fprintf('\n\n\n Matlab Function Terminated.')
