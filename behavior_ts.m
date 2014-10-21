function [xx,d,L,dm,ds,dpts,beginds] = behavior_ts(bsm,beginds,intvl,sigma)
% d is a 4D matrix: (z1,z2,individual,time_bin)

matlabpool local

[xx,d] = bin_in_time(bsm,beginds,intvl,sigma);
% imagesc(xx,xx,d)
% axis equal tight off xy
sz = size(d);
N = sz(3);
T = sz(4);
L = zeros(sz(1),sz(2));
L = watershed(-nansum(nansum(d,4),3));
imagesc(L)
pno = max(L(:));
[dm,ds] = deal(zeros(pno,T));

[dp,dpts] = deal(cell(pno,1));

parfor i=1:pno
    sq = L==i;
    msk = repmat(sq,[1,1,N,T]);
    dp{i} = reshape(d(msk),sum(sum(sq)),N,T);
    dp{i} = squeeze(sum(dp{i},1));
    dm(i,:) = nanmean(dp{i},1);
    ds(i,:) = nanstd(dp{i},0,1);
    gd = ~isnan(dp{i});
    dpts{i} = zeros(sum(sum(gd)),3);
    [~,dpts{i}(:,1)] = find(gd);
    dpts{i}(:,2) = dp{i}(gd);
end
beginds = get_beginds(dpts);
dpts = cell2mat(dpts);

matlabpool close

end
% plot(ds,'o-')
% imagesc(xx,xx,density1)
% axis equal tight off xy
% hold on
% for i=1:pno
%     B = bwboundaries(L==i);
%     plot(xx(B{1}(:,2)),xx(B{1}(:,1)),'w-','linewidth',2)
% end