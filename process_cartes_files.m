function [x,vx,y,vy,t] = process_cartes_files(path,flist)
flist = flist(:);
[x,y,t] = deal(cell(size(flist)));
for i=1:numel(flist)
    flist{i}
	[x{i},y{i},t{i}] = ptReader([path '/' flist{i}],12);
end
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