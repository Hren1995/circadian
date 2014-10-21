function makeBradyMovie(file_path,images,groups,subX,subY)


    test = imread(images{groups{1}(1)});
    s = size(test);
    N = length(groups);
    if N > subX*subY
        N = subX*subY;
        groups = groups(1:N);
    end
    
    
    lengths = zeros(N,1);
    for i=1:N
        lengths(i) = length(groups{i});
    end
    
    runLength = max(lengths);
    numZeros = ceil(log(runLength)./log(10));
    
    
    parfor i=1:runLength
    
        Z = uint8(zeros(s(1)*subY,s(2)*subX));
        
        for j=1:N
        
            yval = floor((j-1)/subX);
            xval = j - yval*subX - 1;
            
            q = imread(images{groups{j}(mod(i-1,lengths(j))+1)});
            Z((1:s(1)) + yval*s(1),(1:s(2)) + xval*s(2)) = q;
                        
            %imshow(q);pause
        end
        
        a = num2str(i);
        if length(a) < numZeros
            a = [repmat('0',1,numZeros - length(a)) a];
        end
        imwrite(Z,[file_path a '.tif'],'tiff');
        
      
    end
    
    