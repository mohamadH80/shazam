%% adding the path of subfolders
clc;
addpath('functions/');
addpath('database/');
addpath('musics/');
addpath('test_musics/');

%%
path='musics/';
song_num1 = 25;
song_num2 = 26;
format = '.mp3';
[~, audioMono1] = import_audio(path, song_num1, format);
[downsampled_Fs, audioMono2] = import_audio(path, song_num2, format);
t=20;
p1=zeros(21);
p2=zeros(21);
for a=0:0.05:1
    %cut 20 seconds
    cen=floor(length(audioMono1)/2);
    cutted_audio1=audioMono1(cen:cen+t*downsampled_Fs);
    cutted_audio2=audioMono2(cen:cen+t*downsampled_Fs);
    cutted_audio=a*cutted_audio1+(1-a)*cutted_audio2;
    
    
    
    window_time = 0.1;
    [time, freq, time_freq_mat] = STFT(cutted_audio, downsampled_Fs, window_time);

    df = floor(0.1*size(time_freq_mat, 1)/4);
    dt = 2/window_time;

    anchor_points = find_anchor_points(time_freq_mat, dt, df);
    df_hash = floor(0.1*size(time_freq_mat,1));
    dt_hash = 20/window_time;
    % creating hash-keys and hash-values for each pair of anchor points
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
    
    i=floor(a*20+1);
    t1=score(:,1)==song_num1;
    t2=score(:,1)==song_num2;
    p1(i)=score(t1,2);
    p2(i)=score(t2,2);
    
end

figure(1);
subplot(1,2,1);
plot(0:0.05:1,p1);
xlabel('alpha');
ylabel('probability');
title(song_num1);

subplot(1,2,2);
plot(0:0.05:1,p2);
xlabel('alpha');
ylabel('probability');
title(song_num2);
