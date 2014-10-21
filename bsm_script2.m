% current master script for running analysis

load('bsm_07.mat','bsm','beginds','sub_beginds','sub_files');
bsm = rem(bsm,24*60*60*1000);
% beginds = beginds([1 5 14 23 31 36]); % need to automate this
intvl = 0.5;
sigma = 2;
[xx,d,L,dm,ds] = behavior_ts(bsm,beginds,intvl,sigma);
d_t = squeeze(nanmean(d,3));
[mn,mx] = deal(min(min(min(d_t))),prctile_mat(d_t,96));
T = size(d_t,3);
save('bsm_07_processing.mat');

plot_unclustered_behaviors(dm,ds);

brady_file_path = '/scratch/gpfs/dmossing/brady_movies_x/';

save_brady_vars(L,xx,bsm,sub_beginds,sub_files,brady_file_path)

% for i=1:T
%     imagesc(d_t(:,:,i),[mn mx])
%     colorbar;
%     axis equal tight off xy
%     title([num2str((i-1)/2) ' to ' num2str(i/2) ' hours past midnight'])
% %     saveas(gca,['sp_mov3/img' kdigit(i,T) '.tif']);
% end

% [~,~,pt] = hist3bin(bsm_all(:,1:2),{xx xx});
% y = L(sub2ind(size(L),pt(:,1),pt(:,2)));
% [y,bd_inds,bd_vals] = filter_rare(y,100);
% mkv = markov_model(y);
% sh = y(randperm(numel(y)));
% len = 5000;
% [mi,mi_mkv,mi_sh] = deal(zeros(len,1));
% k = round(logspace(0,6,len));
% matlabpool local
% parfor i=1:len
%     mi(i) = find_mi(y(1:end-k(i)),y(1+k(i):end));
%     mi_mkv(i) = find_mi(mkv(1:end-k(i)),mkv(1+k(i):end));
%     mi_sh(i) = find_mi(sh(1:end-k(i)),sh(1+k(i):end));
% end
% matlabpool close