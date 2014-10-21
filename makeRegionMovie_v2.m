function makeRegionMovie_v2(save_path,files,znew,watershedValues,flyTrack,watershedImage,bounds,coarseLabels,startFrame,numFrames,trackLength,plotAxes,arenaRadius,arenaCenter,cMap)


    if nargin < 9 || isempty(startFrame)
        startFrame = 1;
    end

    if nargin < 10 || isempty(numFrames)
        numFrames = 2000;
    end

    if nargin < 11 || isempty(trackLength)
        trackLength = 50;
    end

    if nargin < 12 || isempty(plotAxes)
        maxVals = ceil(max(abs(znew(:))));
        plotAxes = [-maxVals maxVals];
    end
    xx = linspace(plotAxes(1),plotAxes(2),length(watershedImage(:,1)));
    
    
    if nargin < 13 || isempty(arenaRadius)
        arenaRadius = 5.14;
    end
    
    if nargin < 14 || isempty(arenaCenter)
        arenaCenter = [0 0];
    end
    
    
    scaleBarLength = 2;
    numZeros = 5;
    R = arenaRadius;
    scaleBarPosition = [-R-1, -R-.5];
    scaleText = [num2str(scaleBarLength) ' cm'];
    slowTime = 5;
    numToSlow = 500;
    titleFontSize = 16;
    titleFontSize_small = 14;
    markersize = 4;
    
    %make boundary image
    if nargin < 7 || isempty(bounds)
        bounds = false(size(watershedImage));
        L = max(watershedImage(:));
        for i=1:L
            B = bwboundaries(watershedImage == i);
            B = B{1};
            for j=1:length(B(:,1));
                bounds(B(j,1),B(j,2)) = true;
            end
        end
    end
    [iii,jjj] = find(bounds);
    
 
    %labelNames = { 'Front & Side Leg Motion','Abdomen Grooming/Motion','Locomotion Gait',...
    %    'Slow/No Movement','Rapid Leg Motion','Left Wing Grooming','Rear Leg & Wing Motions',...
    %    'Rear Leg Grooming','Right Wing Grooming','Proboscis Extension'};
    
    labelNames = {'Slow Movement','Idle',' ','Locomotion Gait','Anterior Movement','Posterior Movement'};
    
    
    %load images
    images = cell(numFrames,1);
    q = files(startFrame:startFrame+numFrames-1);
    parfor i=1:numFrames
        images{i}=imread(q{i});
    end
    
    %making circle points
    thetas = linspace(0,2*pi,10000);
    cx = arenaCenter(1) + arenaRadius.*cos(thetas);
    cy = arenaCenter(2) + arenaRadius.*sin(thetas);
    
    %h = figure('OuterPosition',[100,100,1920,800]);
    h = figure();
    
    %make movie images
    count = 1;
    for i=1:numFrames
             
        
        
        if mod(i,50) == 0
            fprintf('\t Frame #%5i out of %5i\n',i,numFrames);
        end
        
        
        
        %Watershed region image
        subplot(1,3,3)
        hold off
        if ~isempty(watershedValues) && watershedValues(startFrame+i-1) ~= 0
            [idxX,idxY] = find(watershedImage==watershedValues(startFrame+i-1));
            plot(xx(idxY),xx(idxX),'c.')
            hold on
        end
       
        plot(xx(jjj),xx(iii),'k.','markersize',2)
        hold on
        
        minIdx = max(1,i-trackLength);
        plot(znew(startFrame+(minIdx:i)-1,1),znew(startFrame+(minIdx:i)-1,2),'m-','linewidth',1);
        plot(znew(startFrame+i-1,1),znew(startFrame+i-1,2),'ro','markerfacecolor','r','markersize',markersize);
        axis equal tight off
        axis(repmat(plotAxes,1,2));
        title('Behavioral Space  ','Fontsize',titleFontSize,'fontweight','bold')
        
        
        
        
        
        %movie image
        subplot(1,3,2)
        hold off
        imshow(images{i});
        if coarseLabels(startFrame+i-1,1) > 0
            xlabel([labelNames{coarseLabels(startFrame+i-1,1)} ' #' num2str(coarseLabels(startFrame+i-1,2))],'Fontsize',titleFontSize,'fontweight','bold','Color','b')
        else
            xlabel(' ','FontSize',titleFontSize);
        end
        if i > numToSlow
            title(['Slowed ' num2str(slowTime) 'x'],'color','red','fontweight','demi','fontsize',titleFontSize)
        else
            title('Real Time','color','blue','fontweight','demi','fontsize',titleFontSize)
        end
        
        
        
        
        
        %position image
        subplot(1,3,1)
        hold off
        plot(cx,cy,'k-','linewidth',4)
        hold on
        x = flyTrack(startFrame+(minIdx:i)-1,1)';
        y = flyTrack(startFrame+(minIdx:i)-1,2)';
        plot(x,y,'m-','linewidth',1)
        
        plot(flyTrack(startFrame+i-1,1),flyTrack(startFrame+i-1,2),'ro','markerfacecolor','r','markersize',markersize);
        
        plot(scaleBarPosition(1) + [0 scaleBarLength],[1 1].*scaleBarPosition(2),'k-','linewidth',3)
        text(-R-.75,-R-1.5,scaleText,'fontsize',titleFontSize_small,'fontweight','demi');
        
        axis equal tight off
        axis([-R-1 R+1 -R-1 R+1])
        title('Lab Coordinates  ','Fontsize',titleFontSize,'fontweight','bold')
        
        
        
        if ~isempty(save_path)
            q = num2str(count);
            set(h,'PaperPositionMode','auto')
            print(h,'-depsc','-r200',[save_path repmat('0',1,numZeros-length(q)) q '.eps'])
            count = count + 1;
            %             if i > numToSlow
            %                 for j=2:slowTime
            %                     q = num2str(count);
            %                     r = num2str(count-1);
            %                     unix(['cp ' save_path repmat('0',1,numZeros-length(r)) r '.eps ' save_path repmat('0',1,numZeros-length(q)) q '.eps ']);
            %                     %saveas(gcf,[save_path repmat('0',1,numZeros-length(q)) q '.eps'],'eps');
            %                     count = count + 1;
            %                 end
            %             end
            drawnow;
        else
            drawnow;
        end
        
    end