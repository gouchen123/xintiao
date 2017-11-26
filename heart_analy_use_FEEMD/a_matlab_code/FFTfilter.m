function aFdata = FFTfilter(Fs,filterdata,nfft,plotlevel1 )
%FFTFILTER 函数滤波
%   滤波后返回滤波后的值

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
% fup =  max(maxf + 0.3,2);% 选取最大的值
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

%% 画图分析
if  plotlevel1
    figure
    subplot(3,1,1),plot([0:N-1]/Fs,filterdata);
    xlabel('时间/s');
    ylabel('振幅');
    title(sprintf('%d hz通道原始信号',Fs));
    grid on;
    subplot(3,1,2),plot([0:N-1]/Fs,aFdata);
    xlabel('时间/s');
    ylabel('振幅');
    title(sprintf('%d hz通道滤波后信号',Fs));
    grid on;
end



end

