function outputFiles = get_mat(outputPath)
	filecont = what(outputPath); 
	outputFiles = filecont.mat; 
	for i=1:length(outputFiles); 
		outputFiles{i} = [outputPath outputFiles{i}]; 
	end; 
end
