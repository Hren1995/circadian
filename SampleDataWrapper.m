function SampleDataWrapper

if matlabpool('size') ~= 0
	matlabpool close force
end

matlabpool 12

files = load('waveletlist.mat','waveletlist');
outputPath = '/scratch/gpfs/clairh/tsne/sampledata/';

[signalData,signalAmps,runData] = createSampleData(files,outputPath);

save([outputPath 'SampleDataOutput.mat'],'signalData','signalAmps','runData');

matlabpool close