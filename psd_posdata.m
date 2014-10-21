% load gothere3.mat
spc = 10;
tq = t(1):spc:t(end);
rq = interp1(t,r,tq);
y = rq;
Fs = 1/spc;

L = length(y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

Y(NFFT/4+1:end) = 0;
rqfilt = ifft(Y);
plot(tq,rq);
figure;
plot(tq(1:4:end),rqfilt);
