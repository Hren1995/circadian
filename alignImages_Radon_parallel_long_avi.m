function [Xs,Ys,angles,areas,groupings,outputVariables,segmentationOptions,framesToCheck] = ...
    alignImages_Radon_parallel_long_avi(...
    file_path,image_path,basisImage,initialPhi,...
    dilateSize,cannyParameter,alpha,maxIter,imageThreshold,numProcessors,...
    maxAreaDifference,segmentationOff)

vidObj = VideoReader(file_path);
nFrames = vidObj.NumberOfFrames;

xlen = 1000;
if nFrames < xlen + 1
    err = MException('LenChk:TooShort','Video file is less than 10 seconds');
    throw(err);
end

maxlen = 360000;
startImage = (xlen+1):maxlen:nFrames;

if nFrames < xlen+maxlen
    finalImage = nFrames;
else
    finalImage = (xlen+maxlen):maxlen:(nFrames+maxlen-rem(nFrames,maxlen));
    if rem(nFrames,maxlen)~=xlen
        finalImage = [finalImage nFrames];
    end
end

assert(numel(startImage)==numel(finalImage));
n_vid = numel(startImage);

for i=1:n_vid
	mkdir([image_path,num2str(i),'/']);
    [Xs,Ys,angles,areas,groupings,outputVariables,segmentationOptions,framesToCheck] = ...
        alignImages_Radon_parallel_avi(...
        file_path,startImage(i),finalImage(i),[image_path,num2str(i),'/'],basisImage,initialPhi,...
        dilateSize,cannyParameter,alpha,maxIter,imageThreshold,numProcessors,...
        maxAreaDifference,segmentationOff);
end
