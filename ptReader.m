function [x,y,t] = ptReader(filename,numlines)

%-------------------------------------
% Extracts x and y position information from binary file with file name:
% fname
%-------------------------------------

cts2pix = 5e-3;
pix2mm = 24.40/1088; % Conversion factor

fid = fopen(filename,'r','l'); % Opens position data file
paths = fread(fid,[numlines inf],'int32'); paths = paths'; 
% paths is 12xN array with x in the third row, y in the fourth
% We transpose paths so each row is an observation and each column a
% variable
t = cumsum(paths(:,12)) - paths(1,12);
x = cts2pix*paths(:,3);
dx = 544-paths(:,5);
x = x-dx;
x = pix2mm*x;
%x = colfilt(x,[5 1],'sliding',@mode);

% We use a median filter (window span of 11) to make sure that the data is
% clear of any outliers. We will use the SEE algorithm to filter out the
% noise in the data.
y = cts2pix*paths(:,4);
dy = 544-paths(:,6);
y = y-dy;
y = pix2mm*y;
%y = colfilt(y,[5 1],'sliding',@mode);

fclose(fid);


