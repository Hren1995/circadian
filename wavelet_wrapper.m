function [normalizedWavelets,frequencies] = wavelet_wrapper(scoreset,numModes,minF,maxF,numFs,scale,dt,omega0)

if nargin < 2 || isempty(numModes)
    numModes = 50;
end

if nargin < 3 || isempty(minF)
    minF = 1;
end

if nargin < 4 || isempty(maxF)
    maxF = 50;
end

if nargin < 5 || isempty(numFs)
    numFs = 25;
end

if nargin < 6 || isempty(scale)
    scale = 10/7;
end

if nargin < 7 || isempty(dt)
    dt = .01;
end

if nargin < 8 || isempty(omega0)
    omega0 = 5;
end

%L = min(length(vecs(1,:)),numModes);
L = numModes;

minT = 1/maxF;
maxT = 1/minF;
Ts = minT.*2.^((0:numFs-1).*log(maxT/minT)/(log(2)*(numFs-1)));
frequencies = fliplr(1./Ts);

N = length(frequencies);

%scoreset = [];
%
%for i = 1:length(files)
%    load(files{i});
%    scoreset = [scoreset; scores];
%end


normalizedWavelets = zeros(length(scoreset(:,1)),length(frequencies)*L);



for i=1:L
    fprintf(1,'Mode #%2i\n',i);
    normalizedWavelets(:,(1:N)+(i-1)*N) = ...
        fastWavelet_morlet_convolution_parallel(scoreset(:,i),frequencies,omega0,dt)';
end


% fprintf(1,'Normalizing Wavelets\n');
% amps = sum(normalizedWavelets,2);
% 
% parfor i=1:length(normalizedWavelets(1,:))
%     normalizedWavelets(:,i) = normalizedWavelets(:,i) ./ amps;
% end


