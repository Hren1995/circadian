function save_processing_files(input,output,brady_file_path,first_time,make_movies)
% current master script for running analysis

if first_time
    load(input,'bsm','beginds','sub_beginds','sub_files');
    bsm(:,3) = rem(bsm(:,3),24*60*60*1000);
    % beginds = beginds([1 5 14 23 31 36]); % need to automate this
    intvl = 0.5;
    sigma = 2;
    [xx,d,L,dm,ds,dpts,beginds] = behavior_ts(bsm,beginds,intvl,sigma);
    d_t = squeeze(nanmean(d,3));
    [mn,mx] = deal(min(min(min(d_t))),prctile_mat(d_t,96));
    T = size(d_t,3);
    save(output);
    [movies,groups,file_path] = save_brady_vars(L,xx,bsm,sub_beginds,sub_files,brady_file_path);
else
    load(output);
    load('brady_vars.mat');
end

gd = ~cellfun(@isempty,groups);

[dpts_gd,beginds_gd] = filter_by_beginds(dpts,beginds,gd);

plot_unclustered_behaviors(dm(gd,:),ds(gd,:),dpts_gd,beginds_gd);

movies = strrep(movies,'/scratch/gpfs/dmossing/movies/','/Volumes/Fly_Aging/Circadian/');

if make_movies
    N = length(movies);
    readers = cell(N,1);
    for i=1:N; i
        readers{i} = VideoReader(movies{i});
    end
    
    makeManyBradyMovies_avi(file_path,movies,groups,4,4,[],[],readers);
end
end