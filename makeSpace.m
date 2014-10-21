function makespace(sampledata,outputfile)

load(sampledata);

fprintf('Finding KL Divergences...\n');
[D,~] = findKLDivergences(signalData);

fprintf('Running tsne...\n');
[ydata,betas,P,Q] = tsne_d(D);

fprintf('Saving Files...\n');
save(outputfile,'ydata','betas','P','signalAmps','signalData');

fprintf('\n\n\nMatlab Function Completed.')
