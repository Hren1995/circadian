function [xx,d] = bin_in_time(bsm,beginds,intvl,sigma)
% intvl is in hours
slen = 1000;
mlen = 60*slen;
hlen = 60*mlen;
stp = round(intvl*hlen);
pixno = 501; % resolution of behavior space, no. of pixels/side

% create binning in time
hmark = 0:stp:24*hlen;
[~,bins] = histc(bsm(:,3),hmark);
bsm = bsm(bins~=0 & bins~=numel(hmark),:);
bins = bins(bins~=0 & bins~=numel(hmark)); % exclude data outside [0,24hr)

% find proper scale for density plot
scl = max(max(abs(bsm(:,1:2))));
mx = ceil(scl/25)*25;


N = numel(beginds)-1;
t0 = min(bins);
T = max(bins);
d = zeros(pixno,pixno,N,T);
% xx = cell(N,max(bins)-min(bins)+1);

% matlabpool 12;
% for i=1:N
C = cell(N,T);
for i=1:N
    for j=t0:T
        C{i}{j} = bsm(in_rg(bsm(:,3),beginds(i),beginds(i+1)) & bins==j,1:2);
    end
end

parfor i=1:N
    for j=t0:T
%         disp([num2str(i) ' ' num2str(j) ' ' num2str(sum(in_rg(bsm(:,3),beginds(i),beginds(i+1)) & bins==j))])
        [~,d(:,:,i,j)] = findPointDensity(C{i}{j},sigma,pixno,[-mx mx]);
    end
end

% matlabpool close;

xx = linspace(-mx,mx,pixno);

end