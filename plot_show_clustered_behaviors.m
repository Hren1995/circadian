function plot_show_clustered_behaviors(dm,ds,k,L,D)
gd = median(dm,2) > 0.01 & max(dm,[],2) > 0.25;
ds = ds(gd,:);
dm = dm(gd,:);
gd_ind = find(gd);
idx = cluster_behaviors(dm,k);
idx = 1:size(dm,2);
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
    ylim([0 1.1*max(dm(aux(i),:)+ds(aux(i),:))])
    xlabel('hours after midnight');
end
loc = zeros(numel(gd_ind),2);
figure;
for i=1:numel(gd_ind)
    lkat = L==gd_ind(aux(i));
    [z1,z2] = find(lkat);
    loc(i,:) = [sum(z1.*D(lkat))/sum(D(lkat)) sum(z2.*D(lkat))/sum(D(lkat))];
    imagesc(D); caxis([0 0.04]); hold on; scatter(loc(i,2),loc(i,1),100,'m+'); hold off;
    xlabel(num2str(i))
    pause;
end
end