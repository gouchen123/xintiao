function [ rebuild_data ] = eemdrebuild( data )
%EEMDREBUILD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%% �ϴ�����
%% imf
%% Ƶ��
%% ����
%% �ϲ�




% ������ز���
% clear
close all
data = splitdata(1000,0,0,1);
plotlevel0 = 1; %�Ƿ�ԭ��ͼ��
plotlevel1 = 1; %�Ƿ�imfͼ
plotlevel2 = 1; %�Ƿ�imf��Ƶ��ͼ
plotlevel3 = 1; %�Ƿ�imf��Ӧ������ռ�ٷֱ�
plotlevel4 = 1; %�Ƿ��ع����ͼ��
plotlevel5 = 1; %�Ƿ�ƽ���˲����ͼ��

Fs = 100;T = 10;

%% load data
t = (1:Fs*T)/Fs;
t_temp = (1:Fs*T)/1;
if plotlevel0
    figure
    plot(1:1000,data);
end
%% ƽ���˲�
% 5��ƽ���˲����Ƿ���Ҫ��c = movemeanFilter(a)
aftersmooth_data = data; % ������ƽ���˲�
% aftersmooth_data = movemeanFilter(data);
if plotlevel5
    figure
    plot(t,aftersmooth_data)
end
%% EEMD�ֽ�õ�ģ̬����
% ʹ��EEMD�ֽ��ź�
Nstd = 0.2;
NE = 100;
allmode = eemd(aftersmooth_data,Nstd,NE,-1); % N*(m+1) matrix��allmodeΪimf��re
m = size(allmode,1)-1; % m=imf index
t = (1:Fs*T)/Fs;
% ����imf��reͼ��
if plotlevel1
    for i = 0:4:m
        figure
        for j = 1:min(4,m - i + 1)
            subplot(4,1,j),plot(t,allmode(i+j,:));
            grid minor;
        end
    end
end

%% ģ̬������Ƶ��
% ���ú�����ÿһ��imf����Ƶ�� getpsd( xn,nfft,Fs)
nfft = 1024;
x_f = (1:nfft)/nfft*Fs;
frequen = cell(1,m+1);
for i = 1:(m+1)
    frequen{i} = getpsd(allmode(i,:),nfft,Fs);
end
%����ԭʼ�źŵ�Ƶ��
%
fre_raw = getpsd(data,nfft,Fs);
figure
plot(x_f, fre_raw);
xlim([0 2]);grid minor;

%  ����imf��reͼ�ε�Ƶ��
if plotlevel2
    
    for i = 0:4:m
        figure
        for j = 1:min(4,m-i+1 )
            subplot(4,1,j), plot(x_f, frequen{i+j});
            xlim([0 2]);grid minor;
        end
    end
end

%% ģ̬���������������������ٷֱ�
% ���ú�����ÿһ��imf������Ӧ������ getenergy( xn )
energy = zeros(1,m);
for i = 1:(m)
    energy(i) = getenergy(allmode(i,:));
end
% ����������ռ�ٷֱȣ�����ͼ
Energy = sum(energy);
percent_energy = energy/Energy;
if plotlevel3
    figure
    bar(percent_energy);
end

%% �����ع�
% ���ú���rebuild( input,k1,k2 )
rebuild_data = rebuild(allmode,3,m-3);
if plotlevel4
    figure
    plot(t,rebuild_data);
end


%�����ع��źŵ�Ƶ��
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




