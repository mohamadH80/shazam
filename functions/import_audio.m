function [downsampled_Fs, resampled_audio] = import_audio(path, song_num, format)
    % import the audio 
    [audio, Fs] = audioread([path, 'music', num2str(song_num), format]);
    % getting mean over right and left channels
    if size(audio,2)==2
        mono_audio=(audio(:,1)+audio(:,2))/2;
    else
        mono_audio=audio;
    end
    %%% audioMono
    % downsample the audio to 8 KHz
    downsampled_Fs = 8000;
    %%% resampled_audio
    resampled_audio=resample(mono_audio,downsampled_Fs,Fs);
end

