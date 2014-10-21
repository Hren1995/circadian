function [x,vx,y,vy,t] = gauss_cartes_track(fn,sigma);
filtsz = 11;
tails = (filtsz+1)/2;
gf = fspecial('gaussian',[1 filtsz],sigma);
dgf = conv(gf,[-1 0 1]);
% fn = {'0304_xyt.mat','0308_xyt.mat','0329_xyt.mat','0330_xyt.mat'};
fn = fn(:);
[x,vx,y,vy,t] = deal(cell(size(fn)));
for i=1:numel(fn)
    [x{i},y{i},t{i}] = ptReader(fn{i},12);
end

n = numel(t);
sz = cumsum([1;cellfun(@numel,t)]);
[vxp,vyp,xp,yp,tp] = deal(zeros(sum(cellfun(@numel,t)),1));
%     for j=1:n(i)
%         corr = find(y{j} < -65);
%         y{j}(corr) = y{j}(corr+1);
%     end
x0 = mean([max(cellfun(@max,x)),min(cellfun(@min,x))]);
y0 = mean([max(cellfun(@max,y)),min(cellfun(@min,y))]);
for j=1:n
    x{j} = x{j}-x0;
    y{j} = y{j}-y0;
    vxaux = conv(x{j},dgf);
    vxp(sz(j):sz(j+1)-1) = vxaux(tails+1:end-tails)./[diff(t{j}(1:2)); diff(t{j})];
    vyaux = conv(y{j},dgf);
    vyp(sz(j):sz(j+1)-1) = vyaux(tails+1:end-tails)./[diff(t{j}(1:2)); diff(t{j})];
    xaux = conv(x{j},gf);
    xp(sz(j):sz(j+1)-1) = xaux(tails:end-tails+1);
    yaux = conv(y{j},gf);
    yp(sz(j):sz(j+1)-1) = yaux(tails:end-tails+1);
end
tadd = [0; cumsum(5*60*1000+cellfun(@(x)x(end),t(1:end-1)))]; % add final times from each
for i=1:numel(t)
    t{i} = t{i}+tadd(i);
end
tp = cell2mat(t);
[x,vx,y,vy,t] = deal(xp,vxp,yp,vyp,tp);
% [x,vx,y,vy,t] = deal(cell2mat(x),cell2mat(vx),cell2mat(y),cell2mat(vy),cell2mat(t));
end