function out = gaussianfilterdata_derivative_zeropad(data,sigma,dt)

    L = length(data);	
    if iscolumn(data)
	data = [data;zeros(L,1)];
    else 
	data = [data zeros(1,L)];
    end	

    xx = ((1:2*L) - round(L));
    if iscolumn(data)
        xx = xx';
    end
    
    	
    
    g = -xx.*exp(-.5.*xx.^2./sigma^2)./sqrt(2*pi*sigma^6);
    out = fftshift(ifft(fft(data).*fft(g)))./dt;
 
    out = out(1:L);