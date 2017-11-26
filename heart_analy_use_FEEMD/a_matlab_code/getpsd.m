function [ Pxx ] = getpsd( xn,nfft,Fs)
% UNTITLED4 此处显示有关此函数的摘要
% 间接法得频谱
% 参数 xn       输入信号
%      nfft fft 点数
%      Fs       采样频率
%      Pxx      输出频谱幅值
% 20170425 zhaolin

% dataFive = dataFive(1:2048,1);
plotlevel = 0;

%% 直接fft得到振幅 figure (1)
if 1
    y = fft(xn,nfft);
    mag_yy = abs(y);%求模
    Pxx = mag_yy;   %输出参数
    index=0:round(nfft/2-1);
    k=index*Fs/nfft;
    
    if plotlevel
        figure
        plot(k,mag_yy(index+1));
        % plot_Pxx=10*log10(mag_yy(index+1));
        % plot(k,plot_Pxx);
        xlim([0.1 5]);
        title('直接fft得到振幅 figure (1)')
    end
end


%% 直接法 figure (2)

if 0

window=boxcar(length(xn)); %矩形窗
[Pxx,f]=periodogram(xn,window,nfft,Fs); %直接法
figure(2)
plot(f,Pxx);
% plot(f,10*log10(Pxx));
xlim([0.1 5]);
title('直接法 figure (2)');
end
%% 间接法 figure (3)

if 0
    cxn=xcorr(xn,'unbiased'); %计算序列的自相关函数
    CXk=fft(cxn,nfft);
    Pxx=abs(CXk);
    index=0:round(nfft/2-1);
    k=index*Fs/nfft;
    plot_Pxx=10*log10(Pxx(index+1));
    if plot_level
        figure
        % plot(k,plot_Pxx);
        plot(k,Pxx(index+1));
        xlim([0.1 5]);
        title('间接法 figure (3)');
    end
end

if 0
    
%% 改进分段平均图法 figure (4 5)

if 1  
    
n=0:1/Fs:1;
window=boxcar(length(n)); %矩形窗
noverlap=0; %数据无重叠
p=0.9; %置信概率
[Pxx,Pxxc]=psd(xn,nfft,Fs,window,noverlap,p);
index=0:round(nfft/2-1);
k=index*Fs/nfft;
plot_Pxx=10*log10(Pxx(index+1));
plot_Pxxc=10*log10(Pxxc(index+1));
figure(4)
% plot(k,plot_Pxx);
plot(k,Pxx(index+1))
xlim([0.1 5]);
title('改进分段平均图法 figure (4)');
% pause;
figure(5)
% plot(k,[plot_Pxx plot_Pxx-plot_Pxxc plot_Pxx+plot_Pxxc]);
plot(k,[Pxx(index+1) Pxx(index+1)-Pxxc(index+1) Pxx(index+1)+Pxxc(index+1)]);
title('改进分段平均图法 figure (5)');

xlim([0.1 5]);
end

%% 改进加窗平均周期图法 figure (6 7 8)

if 1 

window=boxcar(100); %矩形窗
window1=hamming(100); %海明窗
window2=blackman(100); %blackman窗
noverlap=20; %数据无重叠
range='half'; %频率间隔为[0 Fs/2]，只计算一半的频率
[Pxx,f]=pwelch(xn,window,noverlap,nfft,Fs,range);
[Pxx1,f]=pwelch(xn,window1,noverlap,nfft,Fs,range);
[Pxx2,f]=pwelch(xn,window2,noverlap,nfft,Fs,range);
plot_Pxx=10*log10(Pxx);
plot_Pxx1=10*log10(Pxx1);
plot_Pxx2=10*log10(Pxx2);

figure(6)
plot(f,plot_Pxx);
xlim([0.1 5]);
title('改进加窗平均周期图法 figure (6)');
% pause;
figure(7)
plot(f,plot_Pxx1);
xlim([0.1 5]);
title('改进加窗平均周期图法 figure (7)');
% pause;
figure(8)
plot(f,plot_Pxx2);
xlim([0.1 5]);
title('改进加窗平均周期图法 figure (8)');
end

end


end