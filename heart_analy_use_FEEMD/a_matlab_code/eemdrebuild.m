function [ rebuild_data ] = eemdrebuild( data )
%EEMDREBUILD 此处显示有关此函数的摘要
%   此处显示详细说明
%% 上传数据
%% imf
%% 频谱
%% 能量
%% 合并




% 设置相关参数
% clear
close all
data = splitdata(1000,0,0,1);
plotlevel0 = 1; %是否画原来图像
plotlevel1 = 1; %是否画imf图
plotlevel2 = 1; %是否画imf的频谱图
plotlevel3 = 1; %是否画imf对应能量所占百分比
plotlevel4 = 1; %是否画重构后的图像
plotlevel5 = 1; %是否画平滑滤波后的图像

Fs = 100;T = 10;

%% load data
t = (1:Fs*T)/Fs;
t_temp = (1:Fs*T)/1;
if plotlevel0
    figure
    plot(1:1000,data);
end
%% 平滑滤波
% 5点平滑滤波（是否需要）c = movemeanFilter(a)
aftersmooth_data = data; % 不进行平滑滤波
% aftersmooth_data = movemeanFilter(data);
if plotlevel5
    figure
    plot(t,aftersmooth_data)
end
%% EEMD分解得到模态函数
% 使用EEMD分解信号
Nstd = 0.2;
NE = 100;
allmode = eemd(aftersmooth_data,Nstd,NE,-1); % N*(m+1) matrix，allmode为imf和re
m = size(allmode,1)-1; % m=imf index
t = (1:Fs*T)/Fs;
% 画出imf和re图形
if plotlevel1
    for i = 0:4:m
        figure
        for j = 1:min(4,m - i + 1)
            subplot(4,1,j),plot(t,allmode(i+j,:));
            grid minor;
        end
    end
end

%% 模态函数求频谱
% 调用函数求每一个imf函数频谱 getpsd( xn,nfft,Fs)
nfft = 1024;
x_f = (1:nfft)/nfft*Fs;
frequen = cell(1,m+1);
for i = 1:(m+1)
    frequen{i} = getpsd(allmode(i,:),nfft,Fs);
end
%画出原始信号的频谱
%
fre_raw = getpsd(data,nfft,Fs);
figure
plot(x_f, fre_raw);
xlim([0 2]);grid minor;

%  画出imf和re图形的频谱
if plotlevel2
    
    for i = 0:4:m
        figure
        for j = 1:min(4,m-i+1 )
            subplot(4,1,j), plot(x_f, frequen{i+j});
            xlim([0 2]);grid minor;
        end
    end
end

%% 模态函数求能量，返回能量百分比
% 调用函数求每一个imf函数对应的能量 getenergy( xn )
energy = zeros(1,m);
for i = 1:(m)
    energy(i) = getenergy(allmode(i,:));
end
% 计算能量所占百分比，并画图
Energy = sum(energy);
percent_energy = energy/Energy;
if plotlevel3
    figure
    bar(percent_energy);
end

%% 数据重构
% 调用函数rebuild( input,k1,k2 )
rebuild_data = rebuild(allmode,3,m-3);
if plotlevel4
    figure
    plot(t,rebuild_data);
end


%画出重构信号的频谱
%
fre_rebuild = getpsd(rebuild_data,nfft,Fs);
figure
plot(x_f, fre_rebuild);
xlim([0 2]);grid minor;
fre_rebuild_temp = fre_rebuild(1:21);
figure
plot( x_f(1:21),fre_rebuild_temp);
maxfre = max(fre_rebuild_temp);
find(maxfre == fre_rebuild_temp);




