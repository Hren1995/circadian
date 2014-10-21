function plotTransitionProbabilities(T,fracInState,SizeMultiplier,lineMultiplier)

%     N = length(T(1,1,:));
     sizes = fracInState(:) ./ max(fracInState(:));
%     s = size(T(:,:,1));
%     T = reshape(T,[N N]);
    N = length(T(:,1));
    s = size(T);
    
    hold on
    for i=1:N
        
        [a,b] = ind2sub(s,i);
        q = [sizes(i) 0 1-sizes(i)];
        plot(a,b,'o','markersize',sizes(i)*SizeMultiplier,'markeredgecolor',q,'markerfacecolor',q);        
        
    end
        
    axis(axis)
    
    for i=1:N
        for j=1:N
            
            if T(i,j) > 0
                [a,b] = ind2sub(s,i);
                [c,d] = ind2sub(s,j);
                
                q = [1-T(i,j),T(i,j),1-T(i,j)];
                quiver(a,b,c-a,d-b,'Color',q,'linewidth',lineMultiplier*T(i,j));
                %scale = arrowMultiplier*T(i,j);
                %arrow('Start',[a b],'Stop',[c d],'Width',scale,'Length',scale*10)
                
            end
        end
    end
    
    axis([.8 s(1)+.2 .8 s(2)+.2])