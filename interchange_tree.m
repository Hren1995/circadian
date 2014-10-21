function [Z_l, Z_d] = interchange_tree(bsm_p,beginds)
bsm_p = bsm_p([diff(bsm_p(:,1))~=0; 0],:); % get rid of repeats
% bsm_p = [pixel values of bsm(:,1:2), bsm(:,3)]
p_loc = unique(bsm_p(:,1));
% bsm_p a time series of pixel locations. 
lightson = bsm_p(:,3) > onthresh & bsm_p(:,3) < offthresh; % daytime -> 1
beginds_l = zeros(size(beginds)-[1 0]);
beginds_d = zeros(size(beginds)-[1 0]);
for i=1:numel(beginds)-1
    beginds_l(i) = sum(lightson(beginds(i):beginds(i+1)-1));
    beginds_d(i) = sum(~lightson(beginds(i):beginds(i+1)-1));
end
beginds_l = cumsum([1; beginds_l]);
beginds_d = cumsum([1; beginds_d]);
bsm_l = bsm_p(lightson,:);
bsm_d = bsm_p(~lightson,:);

for i=1:numel(beginds_l)
    T_l(:,:,i) = transition_mat(bsm_l(beginds_l(i):beginds_l(i+1)-1,1),p_loc);
    T_d(:,:,i) = transition_mat(bsm_d(beginds_d(i):beginds_d(i+1)-1,1),p_loc);
end
% T_ij = P(n+1=i|n=j)
T_lm = mean(T_l,3); 
T_dm = mean(T_d,3);
sp_l = pdist2(T_lm,T_lm); % spearman correlation coefficients between rows
sp_d = pdist2(T_dm,T_dm);
Z_l = linkage(sp_l);
Z_d = linkage(sp_d);
end