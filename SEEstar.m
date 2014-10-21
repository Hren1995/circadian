function [z,v] = SEEstar(x,t,span)

%-----------------------------------
% SEE is used to filter out position data from the stage by the use of
% polynomial fits. X is the input vector (positions), span is the full
% sampling window width (should be 11 if used with positionReader). The
% first step involves smoothing out the data itself using LOESS. The second
% step involves recalculating the polynomial regressions to find the
% derivatives at each point, which will provide the velocities, given the
% fact that Y is a function of time.
%-----------------------------------

warning('off','all');
warning;

if matlabpool('size') ~= 0
	matlabpool close force
end

matlabpool local

% smooth (x,t) data, over a TIME window rather than index window
win = span/numel(t);
T = max(t);
z = malowess(t,x,'Span',win);
v = zeros(length(x),1);
h = (span-1)/2;

N = cell(size(t));
P = cell(size(t));

splitinto = 10;

% v is fitted, however, over an INDEX window
parfor i = find(t < win*T/2)'
    N{i} = find(t - t(i) < win*T/2);
    P{i} = polyfit(t(N{i}'),x(N{i}),1);
    v(i) = P{i}(1);
end

parfor i = find(t > win*T/2 & t < T - win*T/2)'
    N{i} = find(t - t(i) > -win*T/2 & t - t(i) < win*T/2);
    P{i} = polyfit(t(N{i}'),x(N{i}),1);
    v(i) = P{i}(1); 
end

parfor i = find(t > T - win*T/2)'
    N{i} = find(t - t(i) > -win*T/2);
    P{i} = polyfit(t(N{i}'),x(N{i}),1);
    v(i) = P{i}(1); 
end

v = 100*v;

matlabpool close
