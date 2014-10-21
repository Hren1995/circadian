function anmovie(fpath,ipath,numProcessors)

file_path = fpath;
image_path = ipath;
basisImage = imread('/home/dmchoi/MatlabScripts/basisImage.tiff');

if exist(image_path,'dir') == 0
	mkdir(image_path);
end

if matlabpool('size') ~= 0
	matlabpool close force
end

matlabpool(numProcessors) 

alignImages_Radon_parallel_avi(file_path,'','',image_path,basisImage,'','','','','','',numProcessors,'');
