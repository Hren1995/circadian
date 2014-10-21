function anlongmovie(fpath,ipath,numProcessors)
fpath
file_path = fpath;
image_path = ipath;
basisImage = imread('/Users/danmossing/Documents/MATLAB/MatlabScripts/basisImage.tiff');

if exist(image_path,'dir') == 0
	mkdir(image_path);
end

alignImages_Radon_parallel_long_avi(file_path,image_path,basisImage,'','','','','','',numProcessors,'','');
