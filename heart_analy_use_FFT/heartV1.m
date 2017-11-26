%% *********心律完整版*********
% 测试数据只有9个通道，选取9个通道处理
% 采样率200HZ
% 可以完整运行，误差较大。

%% ********* loaddata *********
clear

load('newdataone1.mat');
Fs = 100;
x = newdataone;
[c,r]=size(x);
Fs = 100;
W = 2048;

% %使用xlsread直接读取excel文件的数据
% close all
% clear all
% clc
% x = xlsread('ITTMAX1.xls','A:I');
% [c,r]=size(x);%c为行数，r为列数
% Fs = 200;
% W = 2048; %window 表示处理的窗口大小

%%  画出9个通道原始数据
% 用于观察原始数据
if 1
    
    figure
    channel1 = 1;
    channel2 = 9;
    for n = channel1:channel2
        %  figure
        tmp = x(:,n);
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
    data = x(i*W+1:i*W+W,:);
    
    %% *********通道选择**********
    % 选择一条带子上的3个通道
    % 选取规则小于4095且截止最少并大于平均值之上200值点数最多的3个通道,
    %
    SelectChannelNum = 3;
    PointNumcount = zeros(1,9);
    TopPointNum = zeros(1,9);
    channel_data_mean = zeros(1,9);
    for channel = 1:9
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
    PointNumcount1 = zeros(1,9);
    PointNumcount1 = sort(PointNumcount);
    % 倒数三个对应的点数
    LastOneChannelPointValue = PointNumcount1(9);
    LastSecondChannelPointValue = PointNumcount1(8);
    LastThirdChannelPointValue = PointNumcount1(7);
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
        n = 0:N-1;
        t = n * dt;
        f = n / (N*dt);
        y = fft(filterdata,W);
        f1 = 0.7;
        f2 = 2;
        fmax = 0;
        tmpy = abs(y')*2/N;
        possible_heart_fre_gap = tmpy(floor(f1*N/Fs:f2*N/Fs));
        index = find ( possible_heart_fre_gap == max(possible_heart_fre_gap));
        newindex = f1*N/Fs + index;
        maxf = newindex/(N*dt);

        fdown =  maxf - 0.3;
        fup =  max(maxf + 0.3,2);

        yy = zeros(size(y));
        for m = 0:N-1;
            if(m/(N*dt)>(1/dt-fup)&&m/(N*dt)<(1/dt-fdown))...
                    ||(m/(N*dt)>(1/dt-fup)&&m/(N*dt)<(1/dt-fdown))
                yy(m+1)=y(m+1);
            else
                yy(m+1)=0;
            end
        end
        %% IFFT
        ytime = ifft(yy,W);
        
        % 画图分析
        plotlevel = 0;
        if  plotlevel 
        figure
        subplot(3,1,1),plot([0:N-1]/Fs,filterdata);
        xlabel('时间/s');
        ylabel('振幅');
        title(sprintf('%d hz通道%d原始信号',Fs, channelSel(filterChannel)));
        grid on;        
        subplot(3,1,2),plot([0:N-1]/Fs,real(ifft(yy)));
        xlabel('时间/s');
        ylabel('振幅');
        title(sprintf('%d hz通道%d滤波后信号',Fs, channelSel(filterChannel)));
        grid on;
        end
        
        aFdata =real(ifft(yy));
        
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
            if(countpartt(i1+1)-t(i1) <= floor(0.166*Fs)+1)
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
                    
                elseif(~min_flag && data(j) < lower)
                    
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

