function [mv,t] = actogram(fold)
d = dir(fold);
nm = cell(size(d));
kp = zeros(size(d));
for i=1:numel(d)
    nm{i} = d(i).name;
    kp(i) = (length(nm{i}) > 3 && strcmp(nm{i}(1:3),'Pos'));
    nm{i} = [fold '/' nm{i}];
end
files = sort(nm(kp==1));
[x,vx,y,vy,t] = gauss_cartes_track(files,5);
thresh = 1e-3;
mv = smooth(sqrt(vx.^2 + vy.^2),10) > thresh;
mv = medfilt1(mv+0,100);
A = 60*20;
mv = A*smooth(mv,A)/60;
end