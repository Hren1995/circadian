path = '/scratch/gpfs/dmossing/movies/';
files = dir(path);
flist = regexpi({files.name},'030[45].*','match');
flist = [flist{:}];
[x,y,t] = deal(cell(size(flist')));
for i=1:numel(flist)
	[path,flist{i},'/Positions1.dat']
	[x{i},y{i},t{i}] = ptReader([path,flist{i},'/Positions1.dat'],12);
end
len = cellfun(@length,x);
stInd = [1; 1 + cumsum(len)];
x = cell2mat(x);
y = cell2mat(y);
x = x - mean([min(x),max(x)]);
y = y - mean([min(y),max(y)]);
t = cell2mat(t);
for i=1:numel(stInd)-1
	rg = stInd(i):(stInd(i+1)-1);
	[r,phi,rdot,phidot] = polar_pos2(x(rg),y(rg),t(rg));
end
