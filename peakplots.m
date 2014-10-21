function [ts,p] = peakplots(d)
    % input: cell array d of density matrices
    d = d(:)';
    D = cell2mat(d);
    D = reshape(D,[size(d{1}), numel(d)]);
    p = FastPeakFind(sum(D,3));
    p = [p(1:2:end) p(2:2:end)];
    imagesc(sum(D,3)); hold on; plot(p(:,1),p(:,2),'m+'); hold off;
    for i=1:numel(d)
        figure; imagesc(d{i}); hold on; plot(p(:,1),p(:,2),'m+'); hold off;
    end
    ind = sub2ind(size(D),repind(p(:,1),numel(d)),repind(p(:,2),numel(d)),...
        repmat([1:numel(d)]',size(p,1),1));
    ts = D(ind);
    ts = reshape(ts,numel(d),size(p,1))';
%     for i=1:size(ts,1)
%         figure; plot(ts(i,:));
%     end
end