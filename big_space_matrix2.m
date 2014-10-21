function [bsm,beginds,sub_beginds,sub_files] = big_space_matrix(gd_idx,pos_dir,em_dir)
	gd_idx = gd_idx(:);
	bsm = cell(size(gd_idx));
    [sub_beginds,sub_files] = deal(cell(size(bsm)));
	for i=1:numel(bsm)
		[bsm{i},sub_beginds{i},sub_files{i}] = spaces_in_time(gd_idx{i},pos_dir,em_dir);
	end
	beginds = get_beginds(bsm);
	bsm = cell2mat(bsm);
end
