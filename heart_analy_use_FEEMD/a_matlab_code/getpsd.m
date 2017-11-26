function [ Pxx ] = getpsd( xn,nfft,Fs)
% UNTITLED4 �˴���ʾ�йش˺�����ժҪ
% ��ӷ���Ƶ��
% ���� xn       �����ź�
%      nfft fft ����
%      Fs       ����Ƶ��
%      Pxx      ���Ƶ�׷�ֵ
% 20170425 zhaolin

% dataFive = dataFive(1:2048,1);
plotlevel = 0;

%% ֱ��fft�õ���� figure (1)
if 1
    y = fft(xn,nfft);
    mag_yy = abs(y);%��ģ
    Pxx = mag_yy;   %�������
    index=0:round(nfft/2-1);
    k=index*Fs/nfft;
    
    if plotlevel
        figure
        plot(k,mag_yy(index+1));
        % plot_Pxx=10*log10(mag_yy(index+1));
        % plot(k,plot_Pxx);
        xlim([0.1 5]);
        title('ֱ��fft�õ���� figure (1)')
    end
end


%% ֱ�ӷ� figure (2)

if 0

window=boxcar(length(xn)); %���δ�
[Pxx,f]=periodogram(xn,window,nfft,Fs); %ֱ�ӷ�
figure(2)
plot(f,Pxx);
% plot(f,10*log10(Pxx));
xlim([0.1 5]);
title('ֱ�ӷ� figure (2)');
end
%% ��ӷ� figure (3)

if 0
    cxn=xcorr(xn,'unbiased'); %�������е�����غ���
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
        title('��ӷ� figure (3)');
    end
end

if 0
    
%% �Ľ��ֶ�ƽ��ͼ�� figure (4 5)

if 1  
    
n=0:1/Fs:1;
window=boxcar(length(n)); %���δ�
noverlap=0; %�������ص�
p=0.9; %���Ÿ���
[Pxx,Pxxc]=psd(xn,nfft,Fs,window,noverlap,p);
index=0:round(nfft/2-1);
k=index*Fs/nfft;
plot_Pxx=10*log10(Pxx(index+1));
plot_Pxxc=10*log10(Pxxc(index+1));
figure(4)
% plot(k,plot_Pxx);
plot(k,Pxx(index+1))
xlim([0.1 5]);
title('�Ľ��ֶ�ƽ��ͼ�� figure (4)');
% pause;
figure(5)
% plot(k,[plot_Pxx plot_Pxx-plot_Pxxc plot_Pxx+plot_Pxxc]);
plot(k,[Pxx(index+1) Pxx(index+1)-Pxxc(index+1) Pxx(index+1)+Pxxc(index+1)]);
title('�Ľ��ֶ�ƽ��ͼ�� figure (5)');

xlim([0.1 5]);
end

%% �Ľ��Ӵ�ƽ������ͼ�� figure (6 7 8)

if 1 

window=boxcar(100); %���δ�
window1=hamming(100); %������
window2=blackman(100); %blackman��
noverlap=20; %�������ص�
range='half'; %Ƶ�ʼ��Ϊ[0 Fs/2]��ֻ����һ���Ƶ��
[Pxx,f]=pwelch(xn,window,noverlap,nfft,Fs,range);
[Pxx1,f]=pwelch(xn,window1,noverlap,nfft,Fs,range);
[Pxx2,f]=pwelch(xn,window2,noverlap,nfft,Fs,range);
plot_Pxx=10*log10(Pxx);
plot_Pxx1=10*log10(Pxx1);
plot_Pxx2=10*log10(Pxx2);

figure(6)
plot(f,plot_Pxx);
xlim([0.1 5]);
title('�Ľ��Ӵ�ƽ������ͼ�� figure (6)');
% pause;
figure(7)
plot(f,plot_Pxx1);
xlim([0.1 5]);
title('�Ľ��Ӵ�ƽ������ͼ�� figure (7)');
% pause;
figure(8)
plot(f,plot_Pxx2);
xlim([0.1 5]);
title('�Ľ��Ӵ�ƽ������ͼ�� figure (8)');
end

end


end