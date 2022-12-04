%% adding the path of subfolders
clc;
addpath('functions/');
addpath('database/');
addpath('musics/');
addpath('test_musics/');

%%
path='musics/';
song_num = 13; % music i
format = '.mp3';
[downsampled_Fs, audioMono] = import_audio(path, song_num, format);

%cut 20 seconds
t=20;
cen=floor(length(audioMono)/2);
cutted_audio=audioMono(cen:cen+t*downsampled_Fs);
%create noise
mu=0;
sigma=0.1;
noise=normrnd(mu,sigma,[length(cutted_audio),1]);
%optimise noise
snr=-20;
p2p=10^(snr/20);
p_signal=sum(cutted_audio.^2);
p_noise=p_signal/p2p;
p_noiseR=sum(noise.^2);
cuco=sqrt(p_noise/p_noiseR);
cutted_audio=cutted_audio+cuco*noise;

audiowrite('music14.wav',cutted_audio,downsampled_Fs);

