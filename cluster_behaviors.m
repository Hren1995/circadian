function idx = cluster_behaviors(dm,k)
y = dm./repmat(max(dm,[],2),1,size(dm,2)); % normalize
idx = kmeans(y,k);
end