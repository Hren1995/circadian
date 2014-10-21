function [X,Y] = positionReader(filename,numlines)

%-------------------------------------
% Extracts X and Y position information from binary file with file name:
% fname
%-------------------------------------

cts2pix = 5e-3;
pix2mm = 24.40/1088; % Conversion factor

fid = fopen(filename,'r','l'); % Opens position data file
paths = fread(fid,[numlines inf],'int32'); paths = paths'; 
% paths is 12xN array with X in the third row, Y in the fourth
% We transpose paths so each row is an observation and each column a
% variable

X = cts2pix*paths(:,3);
dX = 544-paths(:,5);
X = X-dX;
X = pix2mm*X;
%X = colfilt(X,[5 1],'sliding',@mode);

% We use a median filter (window span of 11) to make sure that the data is
% clear of any outliers. We will use the SEE algorithm to filter out the
% noise in the data.
Y = cts2pix*paths(:,4);
dY = 544-paths(:,6);
Y = Y-dY;
Y = pix2mm*Y;
%Y = colfilt(Y,[5 1],'sliding',@mode);

fclose(fid);


