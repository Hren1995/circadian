function beginds = get_beginds(C)
	% returns size in dimension one of each cell contents in a cell array
	one_cell = num2cell(ones(size(C)));
	beginds = cumsum([1; cellfun(@size,C,one_cell)]);
	beginds = beginds(:);
end
