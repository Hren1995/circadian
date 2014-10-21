function findRadonValues_bin(testImage,files,mu,thetas,pixels,scale)

    N = length(files);
    L = length(pixels);
    
    s = size(testImage);
    scaledSize = round(s ./ scale);
        
    
    
    parfor i=1:N
        
        radvalues = zeros(files{i,2},L);
        fprintf(1,'Processing Batch #%8i\n',i);
        fid = fopen(files{i,1},'r');
        
        
        for j = 1:files{i,2}
            b = uint8(fread(fid,[200,200]));
            a = double(imresize(b,scaledSize));
            lowVal = min(a(a>0));
            highVal = max(a(a>0));
            a = (a - lowVal) / (highVal - lowVal);
            z = radon(a,thetas);
            z = z(pixels) - mu';
            
            radvalues(j,:) = z';
            
            
        end
        
        fclose(fid);

        fname = strrep(files{i,1},'bin','mat');
%         fname = strrep(fname,'aging','wavelets');
        
        parsave(fname,radvalues,files);
        
    end
    
end

function parsave(fname,radvalues,files)

save(fname,'radvalues','files','-v7.3');
end