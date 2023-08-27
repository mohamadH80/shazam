function single_sided_power_spectrum = FFT(X)
    %%% single_sided_power_spectrum
    fft_abs_av=abs(fft(X))./length(X);
    power_spectrum=fft_abs_av.^2;
    halfLen=1+floor(length(X)/2);
    single_sided_power_spectrum=power_spectrum(1:halfLen);
    single_sided_power_spectrum(2:end)=2*single_sided_power_spectrum(2:end);
    
end
