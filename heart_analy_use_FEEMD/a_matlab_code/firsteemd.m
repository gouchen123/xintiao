%% 测试函数

%% 以下代码调用前面feemd和并画出imf图
clear 
close all
load  newdataone
x = newdataone;
x = x(1:2:length(x));
N = length(x);
Fs = 50;
f = ((0:N-1)/N)*Fs;
t = (1:N)/50;
Nstd = 0.2;
NE = 100;

tic;
%[allmode] = eemd(Y, NoiseLevel, NE, numImf, varargin)
allmode = eemd(x,Nstd,NE,-1); % N*(m+1) matrix 
toc;

allmode = [x';allmode];
allmode = allmode';

num_imf = size(allmode,2)-1;
num_imf_ori = size(allmode,2);
for k1 = 0:4:num_imf_ori-1
    figure
    for k2 = 1:min(4,num_imf_ori - k1)
        subplot(4,1,k2),plot(t,allmode(:,k1+k2));
        grid minor;
    end
end
    
%% 计算ori和imf的功率谱
M = num_imf_ori;
for k = 1:num_imf_ori
    frequen{k} = getpsd(allmode(:,k),1024,50);
    mag_frequen{k} = frequen{k};
end
for k3 = 0:4:M-1
   figure
   for k4 = 1:min(4,M-k3)
       subplot(4,1,k4), plot(f, mag_frequen{k3+k4});
       xlim([0 5]);grid minor; 
   end  
end


%% 计算互相关性
cxn = [];
for k5 = 1:M-1
    cxn{k5}=xcorr(allmode(:,k5+1),allmode(:,1),'coeff');
    cxn_max(k5) = max(cxn{k5});
end
figure 
plot(cxn_max);grid minor;

%% 找打呼吸对应分量 找到互相关的第一个最大值对应的分量
c = [];
for k6 = 2:length(cxn_max)-1
    if cxn_max(k6) > cxn_max(k6+1) &&  cxn_max(k6) > cxn_max(k6-1)    
    brea_component = k6;
    end   
end
brea_component = brea_component(1);

%% 合并数据再分解方便二次分解
if 1
comb_data_one_heart = zeros(1024,1);
for i = 3:(brea_component - 1) % i means coorporative imf(i)
    comb_data_one_heart = comb_data_one_heart + allmode(:,i+1);
end
figure
plot(t,comb_data_one_heart);grid minor;
ff = getpsd(comb_data_one_heart,1024,50);
figure 
plot(f,ff),xlim([0 5]),grid minor;
end 





