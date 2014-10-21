function plot_clustered_behaviors(dm,ds,k)
y = dm./repmat(max(dm,[],2),1,size(dm,2)); % normalize
idx = kmeans(y,k);
aux = sort_by(idx); % aux orders by cluster index
[h,w] = aesthetic_sp_dim(numel(aux));
x = linspace(0,24,size(dm,2)+1);
x = x(2:end);
for i=1:size(dm,1)
    subplot(h,w,i); 
    b = errorbar(x,dm(aux(i),:),ds(aux(i),:),'r');
    bc = get(b,'children');
    set(bc(2),'color','b');
    xlim([0 24]); 
    xlabel('hours after midnight');
end
end