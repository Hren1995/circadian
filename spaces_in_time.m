function sp = spaces_in_time(idx,pos_dir,em_dir)

	% format of sp is Nx3, where the first two columns are the embedded points and the third is the time stamp, from midnight.
	[pos_dir,em_dir] = deal(format_fold(pos_dir), format_fold(em_dir));
	skipno = 1000; % number of frames skipped at the beginning of each movie
	f = glob([pos_dir idx '/Positions*.dat']);
	ts = cell(size(f));
	offset = 0;
	for i=1:numel(f)
		ts{i} = findTimeStamps(f{i},offset);
		ts{i} = ts{i}(skipno+1:end);
		offset = offset + ts{i}(end) - ts{i}(1);
	end
	ts = cell2mat(ts);
	sp = zeros(size(ts,1),3);
	sp(:,3) = ts;
	g = glob([em_dir idx '/*/*/embedding.mat']);
	tot_len = 0;
	for i=1:numel(g) % g should come out in sorted order, which is the same as chronological order
		load(g{i},'zValues','zGuesses','inConvHull');
		zValues(~inConvHull,:) = zGuesses(~inConvHull,:);
		new_no = size(zValues,1);
		sp(tot_len+1:tot_len+new_no,1:2) = zValues;
		tot_len = tot_len+new_no;
	end
	assert(tot_len==size(sp,1),'%s, lengths are %d,%d',idx,tot_len,size(sp,1));
end
