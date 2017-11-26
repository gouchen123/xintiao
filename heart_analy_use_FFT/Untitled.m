%% *********心律完整版*********
% 提供的数据只有500*18 
% 采样率50HZ
% 可以完整运行，误差较大。

clear all

plotlevel1 = 1; %是否画原始图
plotlevel2 = 0; %是否画滤波后图像


%% ********* loaddata *********


% load('newdataone1.mat');
% Fs = 100;
% x = newdataone;
% [c,r]=size(x);
% Fs = 100;
% W = 2048;

%使用xlsread直接读取excel文件的数据
clc
% x = xlsread('.\data\IMATTS0612_1.xlsx','A:R');
load mydata;
[c,r]=size(A);%c为行数，r为列数
Fs = 50;
W = 500; %window 表示处理的窗口大小
channel_num = 18; %总的通道数

%%  画出9个通道原始数据
% 用于观察原始数据
if plotlevel1
    
    figure
    channel1 = 1;
    channel2 = 18;
    for n = channel1:channel2
        %  figure
        tmp = A(:,n);
        subplot((channel2 - channel1 + 1),1,n);
        plot([0:c-1]/Fs,tmp);
        %   xlabel('时间/s');
        ylabel(sprintf('振幅 %d',n));
        grid minor
        %     title(sprintf('channel %d',n));
    end
end

% if 0
%% ****窗口处理数据***
channelSelAll = [];
dynatise_HBP =[];
dynatise_HBP_all_channel = [];
for i = 0:fix(c/W)-1
    % for i = 0:0
    data = A(i*W+1:i*W+W,:);
    
    %% **** 滑动滤波
    for jj = 1:1
    new_data = [];
    for temp_i = 1:channel_num
        data_temp = data(:,temp_i);
        data_temp = reshape(movemeanFilter(data_temp),[],1);
        new_data = [new_data,data_temp];
    end
    data = new_data;
    end
    
    %% *********通道选择**********
    % 选择一条带子上的3个通道
    % 选取规则小于4095且截止最少并大于平均值之上200值点数最多的3个通道,
    %
    SelectChannelNum = 3;
    PointNumcount = zeros(1,channel_num);
    TopPointNum = zeros(1,channel_num);
    channel_data_mean = zeros(1,channel_num);
    for channel = 1:channel_num
        % 截止最少
        for j = 1:W
            if (data(j,channel) == 4095 )
                TopPointNum(channel) = TopPointNum(channel) + 1;
            end
        end
        channel_data_mean(channel) = mean(data(:,channel));
        %小于4095且大于2500点数
        for j = 1:W
            if (data(j,channel) < 4095 && data(j,channel) > channel_data_mean(channel) + 500 && TopPointNum(channel) <= W*0.02)
                PointNumcount(channel) = PointNumcount(channel) + 1;
            end
        end
    end
    % 点数排序
    PointNumcount1 = zeros(1,channel_num);
    PointNumcount1 = sort(PointNumcount);
    % 倒数三个对应的点数
    LastOneChannelPointValue = PointNumcount1(channel_num);
    LastSecondChannelPointValue = PointNumcount1(channel_num - 1);
    LastThirdChannelPointValue = PointNumcount1(channel_num - 2);
    %倒数三个对应的通道
    LastOnechannelSel = find(PointNumcount == LastOneChannelPointValue);
    LastSecondchannelSel = find(PointNumcount == LastSecondChannelPointValue);
    LastThirdchannelSel = find(PointNumcount == LastThirdChannelPointValue);
    
    % 确定通道
    if length(LastOnechannelSel) > 2
         channelSel(1:3) = LastOnechannelSel(1:3); 
    elseif  length(LastOnechannelSel) >1
         channelSel(1:2) = LastOnechannelSel(1:2);
         channelSel(3) = LastSecondchannelSel(1);
    else
         LastOnechannelSel =  LastOnechannelSel(1);
         if  length(LastSecondchannelSel) > 1
             channelSel(1) = LastOnechannelSel(1);
             channelSel(2:3) = LastSecondchannelSel(1:2);
         else
             channelSel = [LastOnechannelSel(1),LastSecondchannelSel(1),LastThirdchannelSel(1)];
         end
    end
    % 选择相应的通道  
    channelSelAll = [channelSelAll,channelSel']; 
    %% *********滤波**********
    % 每个通达单独处理，优化可以考虑矩阵3个通道同时处理
    %
    three_chanel_HBP = [];
    for filterChannel = 1:SelectChannelNum
        filterdata = data(:,channelSel(filterChannel));
        
       %% 在0.7—2Hz找到频率对应振幅最大的点,然后找到心律存在频率
        dt = 1/Fs;
        N = W;
        nftt = 512;
        n = 0:nftt-1;
        t = n * dt;
        f = n / (nftt*dt);
        y = fft(filterdata,nftt);
        f1 = 0.7;
        f2 = 2;
        fmax = 0;
        tmpy = abs(y')*2/nftt;
        possible_heart_fre_gap = tmpy(floor(f1*nftt/Fs:f2*nftt/Fs));
        index = find ( possible_heart_fre_gap == max(possible_heart_fre_gap));
        newindex = f1*nftt/Fs + index;
        maxf = newindex/(nftt*dt);

        fdown =  maxf - 0.3;
        fup =  max(maxf + 0.3,2);

        yy = zeros(size(y));
        for m = 0:nftt-1;
            if(m/(nftt*dt)>(1/dt-fup)&&m/(nftt*dt)<(1/dt-fdown))...
                    ||(m/(nftt*dt)>(1/dt-fup)&&m/(nftt*dt)<(1/dt-fdown))
                yy(m+1)=y(m+1);
            else
                yy(m+1)=0;
            end
        end
        %% IFFT
        ytime = ifft(yy,nftt);
        aFdata = ytime(1:W);
        % 画图分析
        if  plotlevel2 
        figure
        subplot(3,1,1),plot([0:N-1]/Fs,filterdata);
        xlabel('时间/s');
        ylabel('振幅');
        title(sprintf('%d hz通道%d原始信号',Fs, channelSel(filterChannel)));
        grid on;        
        subplot(3,1,2),plot([0:N-1]/Fs,aFdata);
        xlabel('时间/s');
        ylabel('振幅');
        title(sprintf('%d hz通道%d滤波后信号',Fs, channelSel(filterChannel)));
        grid on;
        end
        
        
        %% *****计算心律*******
        UPPER_LOWER_LEVEL_COEFF = 0.1;
        % ****** 找出峰谷值******             
        % countpartt 表示极值点对应的点数
        countpartt = [];
        
        for countparti = 2:length(aFdata)-1
            if(aFdata(countparti) >= aFdata(countparti-1) && aFdata(countparti) > aFdata(countparti+1))
                countpartt = [countpartt, countparti];
            end
            if(aFdata(countparti) <= aFdata(countparti-1) && aFdata(countparti) < aFdata(countparti+1))
                countpartt = [countpartt, countparti];
            end
        end
        
        % 合并太靠近的极值
        % i1 临时变量
        for i1 = 1:length(countpartt)-1
            if(countpartt(i1+1)-countpartt(i1) <= floor(0.166*Fs)+1)
                aFdata(countpartt(i1):countpartt(i1+1)) = aFdata(countpartt(i1));
            end
        end
        %         figure
        %         plot(aFdata)
        
        
        
        % 窗口计步
        center = mean(aFdata);
        max_num = max(aFdata);
        min_num = min(aFdata);
        upper = UPPER_LOWER_LEVEL_COEFF * (max_num - min_num) + center;
        lower = UPPER_LOWER_LEVEL_COEFF * (min_num - max_num) + center;
        max_flag = false;
        min_flag = false;
        flag = false;
        heart_beat_num = 0;
        for i2 = 1:W
            if(aFdata(i2) > center)                  %开始时是大于center
                if(aFdata(i2) > upper)
                    max_flag = true;
                end
                if(flag)                             %之前到了center下方
                    if(min_flag || max_flag)         %上一次极值下穿较大，或者本次上穿较大，并且这一轮并没有记录过                        
                        flag = false;                %当前已经到了center上方
                        min_flag = false;
                        heart_beat_num = heart_beat_num + 1;
                    end
                end
            elseif(aFdata(i2) < center)              %下穿center线
                if(~flag)                            %本轮第一次低于center
                    
                    flag = true;                     %表示已经到了center下方
                    max_flag = false;                %清除上一轮的max标志
                    
                elseif(~min_flag && aFdata(i2) < lower)
                    
                    min_flag = true;                 %表示低于lower
                end
            end
        end
        heart_beat_perminute = floor(heart_beat_num * Fs * 60 / W);
        three_chanel_HBP = [three_chanel_HBP,heart_beat_perminute];
    end
    mean_HBP = floor(mean(three_chanel_HBP(1:2))); % 计算两个通道
    dynatise_HBP = [dynatise_HBP,mean_HBP]
    dynatise_HBP_all_channel = [dynatise_HBP_all_channel,three_chanel_HBP(1:2)'] % 计算2个通道
end
% 得到的心律 dynatise_HBP_all_channel dynatise_HBP
%
%

%%% 调试代码
debug = 1;
if debug
    % 心律均值
   dynatise_HBP = dynatise_HBP';
   % 心律所有值
   dynatise_HBP_all_channel = dynatise_HBP_all_channel';
   % 所有选通道
   for ii = 1:3
       for jj = 1:fix(c/W)
           if channelSelAll(ii, jj) > 9;
               channelSelAll(ii, jj) = 100 + (channelSelAll(ii, jj) - 9);
           end
       end
   end
   channelSelAll = channelSelAll';
 
end
    

