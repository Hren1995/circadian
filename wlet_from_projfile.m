function Wavelets = wlet_from_projfile(scorefile)
	load(scorefile,'Scores');
	Wavelets = wavelet_wrapper(Scores);
end
