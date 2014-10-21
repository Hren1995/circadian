function makeRegionMovie(save_path,files,znew,watershedImage,startFrame,numFrames,trackLength,plotAxes,watershedValues)


    if nargin < 4 || isempty(startFrame)
        startFrame = 1;
    end

    if nargin < 5 || isempty(numFrames)
        numFrames = 2000;
    end

    if nargin < 6 || isempty(trackLength)
        trackLength = 50;
    end

    if nargin < 7 || isempty(plotAxes)
        maxVals = ceil(max(abs(znew(:))));
        plotAxes = [-maxVals maxVals];
    end
    xx = linspace(plotAxes(1),plotAxes(2),length(watershedImage(:,1)));
    %plotAxes = [plotAxes plotAxes];
    s = size(watershedImage);
    
    %if nargin < 9 || isempty(minLength)
    %    minLength = 25;
    %end
    
    %     if nargin >=8 && ~isempty(watershedValues)
    %         L = max(watershedValues);
    %         w = zeros(length(znew(:,1)),1);
    %         for i=1:L
    %             CC = largeBWConnComp(watershedValues==i,minLength);
    %             for j=1:CC.NumObjects
    %                 w(CC.PixelIdxList{j}) = i;
    %             end
    %         end
    %     end
    
    
    %[iii,jjj] = find(watershedImage == 0);
    bounds = false(size(watershedImage));
    L = max(watershedImage(:));
    for i=1:L
        B = bwboundaries(watershedImage == i);
        B = B{1};
        for j=1:length(B(:,1));
            bounds(B(j,1),B(j,2)) = true;
        end
    end
    [iii,jjj] = find(bounds);
 
    images = cell(numFrames,1);
    q = files(startFrame:startFrame+numFrames-1);
    parfor i=1:numFrames
        images{i}=imread(q{i});
        %Q = mean(imread(q{i}),3);
        %Q = uint8(Q(:,150:600));
        %images{i} = Q;
    end
    
    
    
    for i=1:numFrames
             
        subplot(1,2,1)
        hold off
        if nargin >= 8 && ~isempty(watershedValues) && watershedValues(startFrame+i-1) ~= 0
            [idxX,idxY] = find(watershedImage==watershedValues(startFrame+i-1));
            plot(xx(idxY),xx(idxX),'c.')
            hold on
            plot(xx(jjj),xx(iii),'k.')
        else
            plot(xx(jjj),xx(iii),'k.')
            hold on
        end
        
        minIdx = max(1,i-trackLength);
        plot(znew(startFrame+(minIdx:i)-1,1),znew(startFrame+(minIdx:i)-1,2),'bo-');
        plot(znew(startFrame+i-1,1),znew(startFrame+i-1,2),'ro','markerfacecolor','r');
        axis equal tight off
        axis(repmat(plotAxes,1,2));
        
        subplot(1,2,2)
        imshow(imcomplement(images{i}));
        %title(num2str(startFrame+i-1))
        
        if ~isempty(save_path)
            q = num2str(i);
            saveas(gcf,[save_path repmat('0',1,4-length(q)) q '.tiff'],'tiff');
        else
            pause(.0001);
        end
        
    end