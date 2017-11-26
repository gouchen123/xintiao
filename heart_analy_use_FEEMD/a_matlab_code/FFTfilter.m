function aFdata = FFTfilter(Fs,filterdata,nfft,plotlevel1 )
%FFTFILTER �����˲�
%   �˲��󷵻��˲����ֵ

%% FFT
dt = 1/Fs;
N = length(filterdata);
n = 0:nfft-1;
t = n * dt;
f = n / (nfft*dt);
y = fft(filterdata,nfft);
f1 = 0.7;
f2 = 2;
tmpy = abs(y')*2/nfft;
possible_heart_fre_gap = tmpy(floor(f1*nfft/Fs:f2*nfft/Fs));
index = find ( possible_heart_fre_gap == max(possible_heart_fre_gap));
newindex = f1*nfft/Fs + index;
maxf = newindex/(nfft*dt);

fdown =  maxf - 0.3;
% fup =  max(maxf + 0.3,2);% ѡȡ����ֵ
fup =  maxf + 0.3;

yy = zeros(size(y));
for m = 0:nfft-1;
    if(m/(nfft*dt)>(1/dt-fup)&&m/(nfft*dt)<(1/dt-fdown))...
            ||(m/(nfft*dt)>(1/dt-fup)&&m/(nfft*dt)<(1/dt-fdown))
        yy(m+1)=y(m+1);
    else
        yy(m+1)=0;
    end
end
%% IFFT
ytime = ifft(yy,nfft);
aFdata = ytime(1:N);

%% ��ͼ����
if  plotlevel1
    figure
    subplot(3,1,1),plot([0:N-1]/Fs,filterdata);
    xlabel('ʱ��/s');
    ylabel('���');
    title(sprintf('%d hzͨ��ԭʼ�ź�',Fs));
    grid on;
    subplot(3,1,2),plot([0:N-1]/Fs,aFdata);
    xlabel('ʱ��/s');
    ylabel('���');
    title(sprintf('%d hzͨ���˲����ź�',Fs));
    grid on;
end



end

