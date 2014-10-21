function [bsm,beginds] = big_space_matrix(gd_idx,pos_dir,em_dir)
	gd_idx = gd_idx(:);
	bsm = cell(size(gd_idx));
	for i=1:numel(bsm)
		bsm{i} = spaces_in_time(gd_idx{i},pos_dir,em_dir);
	end
	beginds = get_beginds(bsm);
	bsm = cell2mat(bsm);
end
