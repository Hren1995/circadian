function [Xs,Ys,angles,areas] = ...
            align_subroutine_parallel(grouping,initialPhi,segmentationOptions,nDigits,file_path,...
                                        image_path,readout,processorNum,asymThreshold,initialArea,fid)      


    L = length(grouping);
    Xs = zeros(L,1);
    Ys = zeros(L,1);
    angles = zeros(L,1);
    areas = zeros(L,1);
        
    
    dilateSize = segmentationOptions.dilateSize;
    cannyParameter = segmentationOptions.cannyParameter;
    imageThreshold = segmentationOptions.imageThreshold;
    alpha = segmentationOptions.alpha;
    maxIter = segmentationOptions.maxIter;
    spacing = segmentationOptions.spacing;
    pixelTol = segmentationOptions.pixelTol;
    basis = segmentationOptions.referenceImage;
    maxAreaDifference = segmentationOptions.maxAreaDifference;
    segmentationOff = segmentationOptions.segmentationOff;
    symLine = segmentationOptions.symLine;
    minRangeValue = segmentationOptions.minRangeValue;
    maxRangeValue = segmentationOptions.maxRangeValue;
        
    s = size(basis);
    currentMinArea = ceil(initialArea*(1-maxAreaDifference));
    
    for j=2:L
        
        if mod(j,readout) == 0
            fprintf(1,'\t Processor #%2i, Image #%7i\n',processorNum,j);
        end
       
        
        
        k = grouping(j);
        nn = nDigits - 1 - floor(log(k+1e-10)/log(10));
        zzs  = repmat('0',1,nn);
        q = [zzs num2str(k) '.tiff'];
        
                
        originalImage = imread([file_path q]);
        sCurrent = size(originalImage);
        
        if sCurrent(1) < s(1) || sCurrent(2) < s(2)
            zz = uint8(zeros(s)+255);
            zz(1:sCurrent(1),1:sCurrent(2)) = originalImage;
            originalImage = zz;
        end
        if ~segmentationOff
            imageOut = segmentImage_combo(originalImage,dilateSize,cannyParameter,...
                imageThreshold,alpha,maxIter,currentMinArea,true);
        else
            imageOut = originalImage;
        end
        
%if max(imageOut(:)) ~= 0        
        
        areas(j) = sum(imageOut(:) ~= 0);
        currentMinArea = ceil((1-maxAreaDifference)*areas(j));
        
        
        imageOut2 = imageOut;
        imageOut2(imageOut2 < asymThreshold) = 0;

if max(imageOut2(:)) ~= 0 
       
        [angles(j),Xs(j),Ys(j),~,~,loopImage] = ...
            alignTwoImages(basis,imageOut2,initialPhi,spacing,pixelTol,false,imageOut);
        
        
        b = loopImage;
        b(b > asymThreshold) = 0;
        
        if minRangeValue > 1
            b(1:minRangeValue-1,:) = 0;
        end
        
        if maxRangeValue < length(basis(:,1))
            b(maxRangeValue+1:end,:) = 0;
        end

        q = sum(b) ./ sum(b(:));
        
        asymValue = symLine - sum(q.*(1:s(1)));
        if asymValue < 0
            
            initialPhi = mod(initialPhi+180,360);
            [tempAngle,tempX,tempY,~,~,tempImage] = ...
                alignTwoImages(basis,imageOut2,initialPhi,spacing,pixelTol,false,imageOut);
            
            b = tempImage;
            b(b > asymThreshold) = 0;
            if minRangeValue > 1
                b(1:minRangeValue-1,:) = 0;
            end
            if maxRangeValue < length(basis(:,1))
                b(maxRangeValue+1:end,:) = 0;
            end
            
            q = sum(b) ./ sum(b(:));
            asymValue2 = symLine - sum(q.*(1:s(1)));
            
            if asymValue2 > asymValue
                angles(j) = tempAngle;
                Xs(j) = tempX;
                Ys(j) = tempY;
                loopImage = tempImage;
            end
            
        end
        
        
        
        initialPhi = angles(j);
        %imwrite(loopImage,[image_path zzs num2str(k) '.tiff'],'tiff');
        fwrite(fid,loopImage,'uint8','l'); 
end
        
    end
