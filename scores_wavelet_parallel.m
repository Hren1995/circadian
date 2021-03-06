function scores_wavelet_parallel(idx,parentdir,numProcessors)

%%% OPEN MATLAB POOL %%%

if matlabpool('size') ~= 0
    matlabpool close force
end

matlabpool(numProcessors)


%%% PROJECTION SCORE PRE-CONFIGURATION %%%

load('Score_variables.mat');

cd(parentdir);

pdirlist = dir('*bin');
binfiles = cell(length(pdirlist),2);

fprintf('Building binary file list...\n');
for i = 1:length(pdirlist)
    binfiles{i,1} = pdirlist(i).name; %each binary file name
    binfiles{i,2} = pdirlist(i).bytes/(200*200); %number of frames in each file
end
fprintf('Success!...\n\n');


%%% FIND PROJECTION SCORES %%%

fprintf('Working on Projection Scores...\n\n');
findRadonValues_pca_bin(testImage,binfiles,vecs100,Mu,thetas,pixels,scale);
fprintf('Scores Completed!\n\n');


%%% WAVELET PRE-CONFIGURATION %%%

wdirlist = dir('*mat');
wavfiles = cell(length(wdirlist),1);

fprintf('Building Score Set...\n');
for i = 1:length(wdirlist)
    wavfiles{i} = wdirlist(i).name;
end
%fprintf('Success!...\n\n');

Scores = [];

for i = 1:length(wavfiles)
    load(wavfiles{i});
    Scores = [Scores; scores];
end
fprintf('Success!...\n\n');

%%% FIND UNNORMALIZED WAVELETS %%%

fprintf('Working on UNNORMALIZED Wavelets...\n\n')
[Wavelets,frequencies] = wavelet_wrapper(Scores,50);
fprintf('Wavelets Completed!\n\n');


%%% SAVE FILE %%%

fprintf('Gathering Save Parameters...\n')
startfile = str2num(strrep(binfiles{1,1},'.bin',''));
fname = ['/scratch/gpfs/dmossing/wavelets/' idx '.mat'];

fprintf('Saving...\n\n')
save(fname,'Wavelets','frequencies','Scores','startfile','-v7.3');
fprintf('Saving Completed!\n\n');


%%% DELETE SCORE FILES (INFORMATION SAVED IN FNAME FILE) %%%

fprintf('Deleting Temporary Files...\n\n')

for i = 1:length(wavfiles)
    if exist(wavfiles{i,1},'file') ~= 0
        delete(wavfiles{i,1});
    end
end
fprintf('Temporary Files Deleted!\n\n');


%%% FINISH BY CLOSING MATLAB POOL %%%

matlabpool close

fprintf('\n\n\n');
fprintf('Matlab Function Completed.');




