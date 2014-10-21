function mi = find_mi(x,y)
x = single(x(:));
y = single(y(:));
mn = min(min(x),min(y));
mx = max(max(x),max(y));
bx = [mn:mx]';
by = [mn:mx]';
h1 = hist(x,bx)';
h2 = hist(y,by)';
h3 = hist3([x y],{bx,by});
h1 = h1/sum(h1);
h2 = h2/sum(h2);
h3 = h3/sum(sum(h3));
hs = -h3.*log2(h1*h2'./h3);
hs(h3==0) = 0;
mi = sum(sum(hs));