% load bsm.mat
hmark = (3600000*0):1800000:(3600000*24);
[~,bins] = histc(bsm(:,3),hmark);
bsm = bsm(bins~=0 & bins~=numel(hmark),:);
bins = bins(bins~=0 & bins~=numel(hmark));
d = cell(numel(unique(bins)),1);
for i=min(bins):max(bins)
    [~,d{i}] = findPointDensity(bsm(bins==i,1:2),2.0);
end

for i=1:numel(d)-1
    figure; 
    title([num2str(i-1) ' to ' num2str(i) ' half hours past midnight']);
    imagesc(d{i});
    M(i) = getframe;
%     saveas(gcf,['space' ddigit(i,2)],'fig');
end