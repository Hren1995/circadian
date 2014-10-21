function x = format_fold(x)
	if x(end)~='/'
		x = [x '/'];
	end
