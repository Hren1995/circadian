function [movies,groups,file_path] = save_brady_vars(LL,xx,bsm,sub_beginds,sub_files,file_path)

if sub_beginds{2}(1)==1 % if sub_beginds isn't already cumulative, make it so
    for i=2:numel(sub_beginds)
        sub_beginds{i} = sub_beginds{i}+sub_beginds{i-1}(end)-1;
    end
end
for i=1:numel(sub_beginds)-1
    sub_beginds{i}(end) = [];
end
beginds = cell2mat(sub_beginds);
movies = vertcat(sub_files{:});
L = numel(movies);
N = max(max(LL));
skiplen = 1000;
[watershedRegions,segments,v,obj,pRest,vals] = findWatershedRegions_v2(bsm(:,1:2),xx,LL);
groups = cell(N,1);
save('temp')
for i=1:N
    groups{i} = zeros(numel(segments{i}),3);
    fst = cellfun(@(x)x(1),segments{i});
    lst = cellfun(@(x)x(end),segments{i});
    [~,a] = histc(fst,beginds);
    [~,b] = histc(lst,beginds);
    gd = a==b;
    groups{i}(gd,2) = fst(gd);
    groups{i}(gd,3) = lst(gd);
    groups{i}(gd,1) = a(gd);
    if ~isempty(groups{i})
        groups{i}(gd,2:3) = groups{i}(gd,2:3)-repmat(beginds(a(gd)),1,2)+skiplen+1; % correction for skipped frames
    end
    groups{i}(~gd,:) = [];
end

save('brady_vars.mat','movies','groups','file_path');
end