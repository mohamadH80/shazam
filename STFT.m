function [time, freq, time_freq_mat] = STFT(audio, Fs, window_time)
    window_length = Fs*window_time;
    window_num = floor(2*length(audio)/(window_length));
    time_freq_mat = zeros(1+floor(window_length/2),window_num-1);
    % calculating fft using an overlapping sliding window
   
    for i = 1:window_num-1
        w_begin=1+(i-1)*floor(window_length*0.5);
        w_end=floor((i-1)*0.5*window_length+window_length);
        selected_window=audio(w_begin:w_end);
        noise=0.00001*randi([0 50],1+floor(size(selected_window,1)/2),1);
        time_freq_mat(:,i)=FFT(selected_window)+noise;
        %%% time_freq_mat
    end
    % time and freq vectors
    time = (window_time/2)*(1:(window_num-1));
    freq = Fs*(0:floor(window_length/2))/window_length;
end

