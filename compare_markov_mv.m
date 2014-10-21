% compare_markov
if numel(bc)>11
    bc = bc(1:11);
end
h = hist3([mvtime(1:end-1),mvtime(2:end)],{bc,bc});
T = h./repmat(sum(h,2),1,size(h,2));
Tp = [zeros(size(T,1),1), cumsum(T,2)];
stsim = zeros(size(mvtime));
randn = rand(size(stsim));
stsim(1) = find(histc(rand(1),[0, cumsum(sum(h)/sum(sum(h)))]));
for i=2:numel(stsim)
    stsim(i) = find(histc(randn(i),Tp(stsim(i-1),:)));
end
    

% bc2 = 2.^[0:2:16];

edg = conv(bc,[0.5 0.5]);
edg(end) = inf;

% h2 = histcn([mvtime(1:end-2), mvtime(2:end-1), mvtime(3:end)],edg,edg,edg);
%     T2 = h2./repmat(sum(h2,3),[1,1,size(h2,3)]);
%     Tp2 = zeros(size(T2)+[0 0 1]);
%     Tp2(:,:,2:end) = cumsum(T2,3);
%     stsim2 = zeros(size(stsim));
%     randn = rand(size(stsim2));
%     stsim2(1) = find(histc(rand(1),[0, cumsum(sum(h)/sum(sum(h)))]));
%     stsim2(2) = find(histc(randn(2),Tp(stsim2(1),:)));
%     for i=3:numel(stsim2)
%         stsim2(i) = find(histc(randn(i),Tp2(stsim2(i-2),stsim2(i-1),:)));
%     end
endat = 2;

Tp2 = cell(size(endat));
Tp2{1} = Tp;
for j=2:endat
    temp = zeros(numel(mvtime)-j,j+1);
    for k = 1:j+1
        temp(:,k) = mvtime(k:(end-j-1+k));
    end
    ed = cell(j+1,1);
    for i=1:numel(ed)
        ed{i} = deal(edg);
    end
    h2 = histcn(temp,ed{:});
    T2 = h2./repmat(sum(h2,j+1),[ones(1,j),size(h2,j+1)]);
    Tp2{j} = zeros(size(T2)+[zeros(1,j) 1]);
    s = size(T2);
    Tp2{j}(prod(s(1:end-1))+1:end) = cumsum(T2,j+1);
end
stsim2 = cell(endat-1,1);
for j=2:endat
    stsim2{j-1} = zeros(size(stsim));
    randn = rand(size(stsim2{j-1}));
    stsim2{j-1}(1) = find(histc(rand(1),[0, cumsum(sum(h)/sum(sum(h)))]));
    for i=2:j
        temp = cell(i-1,1);
        for k=1:i-1
            temp{k} = stsim2{j-1}(k);
        end
        stsim2{j-1}(i) = find(histc(randn(i),Tp2{i-1}(temp{:},:)));
    end
    temp = cell(j,1);
    for i=(j+1):numel(stsim2{j-1})
        for k=1:j
            temp{k} = stsim2{j-1}(i-j-1+k);
        end
        stsim2{j-1}(i) = find(histc(randn(i),Tp2{j}(temp{:},:)));
    end
end
a = autocorr(log10(mvtime),1000);
b = autocorr(stsim,1000);
c = autocorr(stsim2{1},1000);
% semilogx(1:1001,a,1:1001,b,1:1001,c);
semilogx(1:1000,a(2:end),1:1000,b(2:end),1:1000,c(2:end));
xlabel('lag (# of active intervals)')
ylabel('correlation coefficient')
legend('original data','order 1 Markov chain','order 2 Markov chain')
