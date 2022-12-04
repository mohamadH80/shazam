clc;
addpath('functions/');
addpath('database/');
addpath('musics/');
addpath('test_musics/');


%%
clear; close all; clc;

loaded=load('database/database.mat');
database=loaded.database;
    
% importing an audio
path = 'musics/'; % test musics path
song_num = 17; % music i
format = '.mp3';
[downsampled_Fs, audioMono] = import_audio(path, song_num, format);
avearage_probs=zeros(19);    

for snr=1:0.5:10
    count=50;
    avearage_prob=0;
    for c=1:count
        %cut 20 seconds
        t=20;
        st=randi(length(audioMono)-t*downsampled_Fs-1);
        cutted_audio=audioMono(st:st+t*downsampled_Fs);
        
        cutted_audio=awgn(cutted_audio,snr);
        
        % creating the time-freq matrix of the audio using fft and an overlapping sliding window with the length of "window_time"
        window_time = 0.1;
        [time, freq, time_freq_mat] = STFT(cutted_audio, downsampled_Fs, window_time);

        % finding the anchor points from time_freq_mat using a sliding window with the size of 2dt*2df
        df = floor(0.1*size(time_freq_mat, 1)/4);
        dt = 2/window_time;
        % finding anchor points
        anchor_points = find_anchor_points(time_freq_mat, dt, df);
        df_hash = floor(0.1*size(time_freq_mat,1));
        dt_hash = 20/window_time;
        [hash_key, hash_value] = create_hash_tags(anchor_points, df_hash, dt_hash, 0);
        clc; close all;

        list = []; 

        % searching for found hash-keys in the database
        for i = 1:length(hash_key)
            key_tag = [num2str(hash_key(i, 1)), '*', num2str(hash_key(i, 2)), '*', num2str(hash_key(i, 3))];
            if (isKey(database, key_tag))
                temp1 = split(database(key_tag),'+');
                for j = 1:length(temp1)
                    temp2 = split(temp1{j},'*');
                    list = [list; [str2num(temp2{1}),str2num(temp2{2}),hash_value(i,2)]];
                end
            end
        end

        clc; close all;

        score=scoring(list);
        avearage_prob=avearage_prob+score(1,2);
    end
    
    avearage_prob=avearage_prob/count;
    i=floor(1+2*(snr-1));
    avearage_probs(i)=avearage_prob;
   
end

%%plotting
plot(1:0.5:10,avearage_probs);
xlabel('snr');
ylabel('avearage probs');

