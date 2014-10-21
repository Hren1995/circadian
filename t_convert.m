function t = t_convert(s)
    % s is a time stamp of the form HHMMSS
    freq = 1000;
    slen = freq;
    mlen = 60*slen;
    hlen = 60*mlen;
    t = hlen*str2num(s(1:2)) + mlen*str2num(s(3:4)) + slen*str2num(s(5:6));
end
