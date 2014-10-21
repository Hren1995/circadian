function [Xs,Ys,angles,areas,groupings,outputVariables,segmentationOptions,framesToCheck] = ...
            alignImages_Radon_parallel(...
                        file_path,startImage,finalImage,image_path,basisImage,initialPhi,...
                        dilateSize,cannyParameter,alpha,maxIter,imageThreshold,numProcessors,...
                        maxAreaDifference,segmentationOff)

    warning off MATLAB:polyfit:RepeatedPointsOrRescale;


    spacing = 1;
    pixelTol = .1;
    readout = 100;
    minArea = 3500;
    nDigits = 8;
    asymThreshold = 150;
    symLine = 110;
   
    imagelist = findImagesInFolder(file_path,'.tiff');
    nFrames = length(imagelist);
    clear imagelist;
 
    if nargin < 6 || isempty(initialPhi) == 1
        initialPhi = 0;
    end
    
    if nargin < 7 || isempty(dilateSize) == 1
        dilateSize = 5;
    end
    
    if nargin < 8 || isempty(cannyParameter) == 1
        cannyParameter = .1;
    end
    
    if nargin < 9 || isempty(alpha) == 1
        alpha = .5;
    end
    
    if nargin < 10 || isempty(maxIter) == 1
        maxIter = 100;
    end
    
    if nargin < 11 || isempty(maxIter) == 1
        imageThreshold = 40;
    end
    
    if nargin < 12 || isempty(numProcessors) || numProcessors > 20 
        numProcessors = 7;
    end
    
    if nargin < 13 || isempty(maxAreaDifference)
        maxAreaDifference = .15;
    end
    
     if nargin < 14 || isempty(segmentationOff)
        segmentationOff = false;
    end
    
    if isempty(startImage) == 1
        startImage = 1000;
    end
    
    if isempty(finalImage) == 1
        if nFrames < 360000
            finalImage = nFrames;
        else
            finalImage = 360000;
        end
    end    


    currentSize = matlabpool('size');
    if currentSize ~= numProcessors
        
        if currentSize > 0
            matlabpool close;
        end
        
        matlabpool(numProcessors);
        
    end
    
     
    segmentationOptions.imageThreshold = imageThreshold;
    segmentationOptions.alpha = alpha;
    segmentationOptions.maxIter = maxIter;
    segmentationOptions.cannyParameter = cannyParameter;
    segmentationOptions.dilateSize = dilateSize;
    segmentationOptions.minArea = minArea;
    segmentationOptions.spacing = spacing;
    segmentationOptions.pixelTol = pixelTol;
    segmentationOptions.maxAreaDifference = maxAreaDifference;
    segmentationOptions.segmentationOff = segmentationOff;
    segmentationOptions.asymThreshold = asymThreshold;
    segmentationOptions.symLine = symLine;
    
    
    if isempty(file_path) == 1
         file_path = input('Image filepath name: ', 's');
         firstFrameNumber  = input('Image number for first frame: ', 's');
         startImage = str2double(firstFrameNumber);
         lastFrameNumber   = input('Image number for last frame:  ', 's');
         finalImage = str2double(lastFrameNumber);
    end
    
    if isempty(image_path) == 1
        image_path_init = '/Users/gberman/Desktop/';
        image_path   = input('End of Image Path?:  ', 's');
        image_path = [image_path_init image_path];
    end
        
    [status,~]=unix(['ls ' image_path]);
    if status == 1
        unix(['mkdir ' image_path]);
    end
    
    
    if file_path(end) ~= '/'
        file_path = [file_path '/'];
    end
    
    if ~segmentationOff
        referenceImage = segmentImage_combo(basisImage,dilateSize,cannyParameter,imageThreshold,alpha,maxIter,minArea,true);
    else
        referenceImage = basisImage;
    end
    
    [ii,~] = find(referenceImage > 0);
    minRangeValue = min(ii) - 20;
    maxRangeValue = max(ii) + 20;
    
    segmentationOptions.referenceImage = referenceImage;
    segmentationOptions.minRangeValue = minRangeValue;
    segmentationOptions.maxRangeValue = maxRangeValue;
    
    %define groupings 
    imageVals = startImage:finalImage;
    numImages = length(imageVals);
    minNumPer = floor(numImages / numProcessors+1e-20);
    remainder = mod(numImages,numProcessors);
    count = 1;
    groupings = cell(numProcessors,1);
    for i=1:numProcessors
        if i <= remainder
            groupings{i} = imageVals(count:(count+minNumPer));
            count = count + minNumPer + 1;
        else
            groupings{i} = imageVals(count:(count+minNumPer-1));
            count = count + minNumPer;
        end
    end
    
    % Write Out Grouping Start and Finish indices
    groupidx = zeros(length(groupings),2);
    for i = 1:length(groupings)
        groupidx(i,1) = groupings{i}(1);
        groupidx(i,2) = groupings{i}(end);
    end
    save([image_path 'groupings.txt'],'groupidx','-ASCII');
        
    
    x1s = zeros(numProcessors,1);
    y1s = zeros(numProcessors,1);
    angle1s = zeros(numProcessors,1);
    area1s = zeros(numProcessors,1);
    
    
    currentPhis = zeros(numProcessors,1);
    
    
    %initialize First Images
    
    images = cell(numProcessors,1);
    for j=1:numProcessors  
        
        fprintf(1,'Finding initial orientation for processor #%2i\n',j);
        
                
        i = groupings{j}(1);
        nn = nDigits - 1 - floor(log(i+1e-10)/log(10));
        zzs  = repmat('0',1,nn);
        q = [zzs num2str(i) '.tiff'];

        
        
        originalImage = imread([file_path q]);
        if ~segmentationOff
            imageOut = segmentImage_combo(originalImage,dilateSize,cannyParameter,...
                imageThreshold,alpha,maxIter,minArea,true);
        else
            imageOut = originalImage;
        end
        
        imageOut2 = imageOut;
        imageOut2(imageOut2 < asymThreshold) = 0;
        
        [angle1s(j),x1s(j),y1s(j),~,~,image] = ...
            alignTwoImages(referenceImage,imageOut2,initialPhi,spacing,pixelTol,false,imageOut);
        
        
        s = size(image);
        b = image;
        b(b > asymThreshold) = 0;
        if minRangeValue > 1
            b(1:minRangeValue-1,:) = 0;
        end
        if maxRangeValue < length(referenceImage(:,1))
            b(maxRangeValue+1:end,:) = 0;
        end
                
        
        q = sum(b) ./ sum(b(:));
        asymValue = symLine - sum(q.*(1:s(1)));
 
        
        
        if asymValue < 0
            
            initialPhi = mod(initialPhi+180,360);

            [tempAngle,tempX,tempY,~,~,tempImage] = ...
                alignTwoImages(referenceImage,imageOut2,initialPhi,spacing,pixelTol,false,imageOut);
            
            b = tempImage;
            b(b > asymThreshold) = 0;
            if minRangeValue > 1
                b(1:minRangeValue-1,:) = 0;
            end
            if maxRangeValue < length(referenceImage(:,1))
                b(maxRangeValue+1:end,:) = 0;
            end
            
            q = sum(b>0)./sum(b(:)>0);
            asymValue2 = symLine - sum(q.*(1:s(1)));
            
            if asymValue2 > asymValue
                angle1s(j) = tempAngle;
                x1s(j) = tempX;
                y1s(j) = tempY;
                image = tempImage;
            end
            
        end
        
               
        % Uncomment if you want to check the first frame sequences
        %         test = 0;
        %         while test == 0
        %             Q = double(image) + double(referenceImage);
        %             imagesc(Q); axis equal tight off
        %             title(['Continue? (Y/N) -- x = ' num2str(x1s(j)) ', y = ' ...
        %                 num2str(y1s(j)) ', phi = ' num2str(angle1s(j))]);
        %             [~,~,button] = ginput(1);
        %             while (button ~= 110) && (button ~=121)
        %                 [~,~,button] = ginput(1);
        %             end
        %             if button == 121
        %                 test = 1;
        %             else
        %                 initialPhi = mod(initialPhi-180,360);
        %                 %[angle1s(j),x1s(j),y1s(j),image] = ...
        %                 %    alignTwoImages(referenceImage,imageOut,initialPhi,spacing,pixelTol);
        %                 [angle1s(j),x1s(j),y1s(j),~,~,image] = ...
        %                     alignTwoImages(referenceImage,imageOut2,initialPhi,spacing,pixelTol,false,imageOut);
        %             end
        %         end
        
        area1s(j) = sum(imageOut(:) ~= 0);
        currentPhis(j) = angle1s(j);
        fid = fopen([image_path zzs num2str(i) '.bin'],'a','l');
        %imwrite(image,[image_path zzs num2str(i) '.tiff'],'tiff');
        fwrite(fid,image,'uint8','l');
        fclose(fid);
        
        
    end
    
    
    
    fprintf(1,'Aligning Images\n');
    
    tic
    Xs_temp = cell(numProcessors,1);
    Ys_temp = cell(numProcessors,1);
    Angles_temp = cell(numProcessors,1);
    Areas_temp = cell(numProcessors,1);
    
    parfor i=1:numProcessors

        k = groupings{i}(1);
        nn = nDigits - 1 - floor(log(k+1e-10)/log(10));
        zzs  = repmat('0',1,nn); 
        fid = fopen([image_path zzs num2str(k) '.bin'],'a','l');
        
        [Xs_temp{i},Ys_temp{i},Angles_temp{i},Areas_temp{i}] = ...
            align_subroutine_parallel(groupings{i},currentPhis(i),...
            segmentationOptions,nDigits,file_path,image_path,readout,i,asymThreshold,area1s(i),fid);
        
        Xs_temp{i}(1) = x1s(i);
        Ys_temp{i}(1) = y1s(i);
        Areas_temp{i}(1) = area1s(i);
        Angles_temp{i}(1) = angle1s(i);
              
        fclose(fid);
        
    end
    toc
    
    
    
    Xs = zeros(numImages,1);
    Ys = zeros(numImages,1);
    angles = zeros(numImages,1);
    areas = zeros(numImages,1);
    for i=1:numProcessors
        Xs(groupings{i}-startImage+1) = Xs_temp{i};
        Ys(groupings{i}-startImage+1) = Ys_temp{i};
        angles(groupings{i}-startImage+1) = Angles_temp{i};
        areas(groupings{i}-startImage+1) = Areas_temp{i};
    end
        
    
        
    outputVariables = [imageVals' Xs Ys angles areas];
    
    
    
    save([image_path 'transforms.txt'],'outputVariables','-ascii');
    
    
    x = abs(diff(unwrap(angles.*pi/180).*180/pi));
    framesToCheck = find(x > 90) + 1;

    save([image_path 'framesToCheck.txt'],'framesToCheck','-ASCII');    
    
    
    
    
