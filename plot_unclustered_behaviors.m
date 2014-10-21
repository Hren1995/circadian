function plot_unclustered_behaviors(dm,ds,dpts,beginds)
y = dm./repmat(max(dm,[],2),1,size(dm,2)); % normalize
% idx = kmeans(y,k);
% aux = sort_by(idx); % aux orders by cluster index
% [h,w] = aesthetic_sp_dim(numel(aux));
h = 6; w = 7;
x = linspace(0,24,size(dm,2)+1);
x = x(2:end);
% dm = dm./repmat(sum(dm),size(dm,1),1);
% ds = ds./repmat(sum(dm),size(dm,1),1);
for i=1:size(dm,1)
    subplot(h,w,i);
    b = errorbar(x,dm(i,:),ds(i,:),'r');
    bc = get(b,'children');
    set(bc(2),'color','b');
    lk = beginds(i):beginds(i+1)-1;
    hold on
    scatter(x(dpts(lk,1)),dpts(lk,2),'m+')
    hold off
    xlim([0 24]);
    ylim([0 1.1*max(dpts(lk,2))])
    xlabel('time (hrs.)','FontSize',14)
    ylabel('occupancy (a.u.)','FontSize',14)
    set(gca,'FontSize',14)
    title(['#' num2str(i)],'FontSize',14)
end
figure;
for i=1:size(dm,1)
    subplot(h,w,i);
    lk = beginds(i):beginds(i+1)-1;
    ssize = histc(dpts(lk,1),1:48);
    b = errorbar(x,dm(i,:),ds(i,:)./sqrt(ssize'),'r');
    bc = get(b,'children');
    set(bc(2),'color','b');
    xlim([0 24]);
    ylim([0 1.1*max(dpts(lk,2))])
    xlabel('time (hrs.)','FontSize',14)
    ylabel('occupancy (a.u.)','FontSize',14)
    set(gca,'FontSize',14)
    title(['#' num2str(i)],'FontSize',14)
end
end