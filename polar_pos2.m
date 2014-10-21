function [r,phi,rdot,phidot] = polar_pos2(x,y,t)
    % read in .dat file with 12 columns
        warning('off', 'All')
        %splitinto = 10;
%       stopat = 500;
%       [x,y,t] = deal(x(1:stopat),y(1:stopat),t(1:stopat));
        save('/scratch/gpfs/dmossing/posn/gothere0.mat');
    	% find smoothed positions and velocities; span is 11 for pos...Reader
	chunksize = 50000;
	beginds = 1:chunksize:length(x);
	%beginds = 1:floor(length(x)/splitinto):length(x);
	[vx,vy] = deal(zeros(size(x)));
        for i=1:numel(beginds)-1
		save('/scratch/gpfs/dmossing/posn/counter','i');
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
    	r = sqrt(x.^2+y.^2);
        save('/scratch/gpfs/dmossing/posn/gothere2.mat');
    	% maps atan onto true angle phi, meas. from x axis
    	phi = atan(y./x) + (pi/2)*(abs(sign(x)-sign(y)) + 1 - sign(y));
    	% plot r as a function of time
    	rdot = x.*vx./r + y.*vy./r;
    	phidot = (vy - rdot.*sin(phi))./r./cos(phi);
        save('/scratch/gpfs/dmossing/posn/gothere3.mat');
end              
