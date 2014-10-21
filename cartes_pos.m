function [x,vx,y,vy] = cartes_pos(x,y,t)
    % read in .dat file with 12 columns
        warning('off', 'All')
        %splitinto = 10;
%       stopat = 500;
%       [x,y,t] = deal(x(1:stopat),y(1:stopat),t(1:stopat));
    	% find smoothed positions and velocities; span is 11 for pos...Reader
	chunksize = 50000;
	beginds = 1:chunksize:length(x);
	%beginds = 1:floor(length(x)/splitinto):length(x);
	[vx,vy] = deal(zeros(size(x)));
        for i=1:numel(beginds)-1
% 		save('/scratch/gpfs/dmossing/posn/counter','i');
                rg = beginds(i):(beginds(i+1)-1);
                [x(rg),vx(rg)] = SEEstar(x(rg),t(rg),11); 
                %save('/scratch/gpfs/dmossing/posn/gothere1.mat');
                [y(rg),vy(rg)] = SEEstar(y(rg),t(rg),11);
                %save('/scratch/gpfs/dmossing/posn/gothere2.mat');
        end
    	% find out if origin is zero; if so, define theta using arctan and r
    	% using sqrt(x^2+y^2)
    	%x = x - mean([min(x),max(x)]);
    	%y = y - mean([min(y),max(y)]);
end  
