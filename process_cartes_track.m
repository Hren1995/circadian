function [x,vx,y,vy,t] = process_cartes_track(x,y,t))
% inputs are cells x,y,t each corresponding to a video
len = cellfun(@length,x);
stInd = [1; 1 + cumsum(len)];
x = cell2mat(x);
y = cell2mat(y);
x = x - mean([min(x),max(x)]);
y = y - mean([min(y),max(y)]);
t = cell2mat(t);
[vx,vy] = deal(zeros(size(t)));
for i=1:numel(stInd)-1
	rg = stInd(i):(stInd(i+1)-1);
	[x(rg),vx(rg),y(rg),vy(rg)] = cartes_pos(x(rg),y(rg),t(rg));
end
end
