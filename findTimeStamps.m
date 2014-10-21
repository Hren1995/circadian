function ts = findTimeStamps(fn,offset)
	if nargin < 2
		offset = 0;
	end
    % input is the full path to a position file. Output is a vector of time
    % stamps, one per frame.
    t = get_t(fn);
    tstr_len = 6; % time stamp is 6 digits, HHMMSS
    re = '\d+_\d+';
    st_time = regexp(fn,re,'match');
    st_time = st_time{1}(end-tstr_len+1:end); % get clock time
    st_time = t_convert(st_time); % convert to time in ms (since midnight)
    ts = t + st_time + offset;
end
    
    
