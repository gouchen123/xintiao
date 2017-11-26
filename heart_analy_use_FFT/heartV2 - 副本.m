%% *********心律完整版*********
% 提供的数据只有500*18 
% 采样率500HZ
% 可以完整运行，误差较大。

clear all

plotlevel1 = 0; %是否画原始图
plotlevel2 = 0; %是否画心跳滤波后图像
plotlevel3 = 0; %是否画呼吸滤波后图像
lvbo = 1
as = 0;


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
load A;
[c,r]=size(A(2000:5000,:));%c为行数，r为列数
Fs = 50;
W = 1000; %window 表示处理的窗口大小
nftt = 1024;
channel_num = 18; %总的通道数
subplot 311
plot (A(:,4));
subplot 312
plot (A(:,12));
subplot 313
plot (A(:,15));
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
channelSelAlls = [];
dynatise_HBP =[];
dynatise_breath =[];
dynatise_HBP_all_channel = [];
dynatise_breath_all_channel = [];
for i = 0:fix(c/W)-1
    % for i = 0:0
    data = A(i*W+1:i*W+W,:);
    
    %% **** 滑动滤波
if lvbo
    new_data = [];
    for temp_i = 1:channel_num
        data_temp = data(:,temp_i);
%         figure
%         subplot 211
%         plot (data_temp)
        data_temp = reshape(movemeanFilter(data_temp),[],1);
%         subplot 212
%         plot (data_temp)
        new_data = [new_data,data_temp];
    end
    data = new_data;
end
    
    
    
    %% *********通道选择**********
    % 选择一条带子上的3个通道
    % 选取规则小于4095且截止最少并大于平均值之上200值点数最多的3个通道,
    %
    SelectChannelNum = 4;
    xvar = zeros(1,channel_num);
    PointNumcount = zeros(1,channel_num);
    TopPointNum = zeros(1,channel_num);
    channel_data_mean = zeros(1,channel_num);
    
    for channel = 1:channel_num
        xvar (channel) =  var(data(:,channel));
        %subplot(3,1,1);
        %plot (xvar(channel));
        %subplot(3,1,2);
        %plot (data(:,channel));
        %subplot(3,1,3);
        %plot (data);
        
        %figure(1);
        %subplot(channel_num,1,channel);
        %plot(data(:,channel));
        
        flag = 0 ;
      
        % 截止最少
        for j = 1:W
            if (data(j,channel) >= 4050 )
                flag = 1;
            end
        end
        if flag == 1
            xvar(channel) = 0;
        end
%         channel_data_mean(channel) = mean(data(:,channel));
%         %小于4095且大于2500点数
%         for j = 1:W
%             if (data(j,channel) < 4095 && data(j,channel) > channel_data_mean(channel) + 200 && TopPointNum(channel) <= W*0.02)
%                 PointNumcount(channel) = PointNumcount(channel) + 1;
%             end
% %         end
    disp(xvar(:))
    end
    PointNumcountvar = sort(xvar);
    [sa index]=sort(xvar)
    LastOnePointNumcountvarValue = PointNumcountvar(channel_num);
    LastSecondPointNumcountvarValue = PointNumcountvar(channel_num - 1);
    LastThirdPointNumcountvarValue = PointNumcountvar(channel_num - 2);
    disp(index);
    if plotlevel2
        figure ;
%         subplot(6,1,1);
%         plot (LastOnePointNumcountvarValue);
%         subplot(6,1,2);
%         plot (LastSecondPointNumcountvarValue);
%         subplot(6,1,3);
%         plot (LastThirdPointNumcountvarValue);
%         subplot(6,1,4);
%         plot (data(:,index(channel_num)));
%         subplot(6,1,5);
%         plot (data(:,index(channel_num - 1)));
%         subplot(6,1,6);
%         plot (data(:,index(channel_num - 2)));
% %         subplot(3,1,1);
% %         plot (data(:,index(channel_num)));
% %         title (index(channel_num))
% %         subplot(3,1,2);
% %         plot (data(:,index(channel_num - 1)));
% %         title (index(channel_num-1))
% %         subplot(3,1,3);
% %         plot (data(:,index(channel_num - 2)));
% %         title (index(channel_num-2))
        %figure ;
        %plot(data(:,10:18))
    end 
       % A=[ 15 3 5 7 2 1 12 17]
        %[sA index]=sort(A)
        %AA(index)=sA
    % 点数排序
      PointNumcount1 = zeros(1,channel_num);
%     PointNumcount1 = sort(PointNumcount);
%     xvar (channel) =  var(PointNumcount1(:,channel));
%     PointNumcountvar = sort(xvar);
%     %[sa index]=sort(xvar)
%     LastOnePointNumcountvarValue = PointNumcountvar(channel_num);
%     LastSecondPointNumcountvarValue = PointNumcountvar(channel_num - 1);
%     LastThirdPointNumcountvarValue = PointNumcountvar(channel_num - 2);
% %     
%        figure ;
%         subplot(6,1,1);
%         plot (LastOnePointNumcountvarValue);
%         subplot(6,1,2);
%         plot (LastSecondPointNumcountvarValue);
%         subplot(6,1,3);
%         plot (LastThirdPointNumcountvarValue);
%         subplot(6,1,4);
%         plot (data(:,channel_num));
%         subplot(6,1,5);
%         plot (data(:,channel_num - 1));
%         subplot(6,1,6);
%         plot (data(:,channel_num - 2));
    % 倒数三个对应的点数
    LastOneChannelPointValue = PointNumcount1(channel_num);
    LastSecondChannelPointValue = PointNumcount1(channel_num - 1);
    LastThirdChannelPointValue = PointNumcount1(channel_num - 2);
    LastFourChannelPointValue = PointNumcount1(channel_num - 3);
    %倒数三个对应的通道
    LastOnechannelSel = find(PointNumcount == LastOneChannelPointValue);
    LastSecondchannelSel = find(PointNumcount == LastSecondChannelPointValue);
    LastThirdchannelSel = find(PointNumcount == LastThirdChannelPointValue);
    LastFourchannelSel = find(PointNumcount == LastFourChannelPointValue);
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
             channelSel = [LastOnechannelSel(1),LastSecondchannelSel(1),LastThirdchannelSel(1),LastFourchannelSel(1)];
         end
    end
    %channelSel = [channel_num,channel_num-1,channel_num-2]
    channelSel = [index(channel_num),index(channel_num-1),index(channel_num-2),index(channel_num-3)]
    % 选择相应的通道  
    channelSelAlls = [channelSelAlls,channelSel']; 
    %% *********滤波**********
    % 每个通道单独处理，优化可以考虑矩阵3个通道同时处理
    %
    three_chanel_HBP = [];
    three_chanel_breath = [];
    for filterChannel = 1:SelectChannelNum
        filterdata = data(:,channelSel(filterChannel));
        
       %% 在0.7—2Hz找到频率对应振幅最大的点,然后找到心律存在频率
        dt = 1/Fs;
        N = W;
        n = 0:nftt-1;
        t = n * dt;
        f = n / (nftt*dt);
        y = fft(filterdata,nftt);
        %plot(1:512,y)
        f1 = 0.7;
        f2 = 2;
        fmax = 0;
        tmpy = abs(y')*2/nftt;
        possible_heart_fre_gap = tmpy(floor(f1*nftt/Fs:f2*nftt/Fs));
        %figure;
        %plot(1:512,tmpy);
        index = find ( possible_heart_fre_gap == max(possible_heart_fre_gap));
        newindex = f1*nftt/Fs + index;
        maxf = newindex/(nftt*dt);
       %figure ;
       %plot (tmpy);
        fdown =  maxf-0.3;
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
        %subplot(2,1,1),
        %figure ;
        %plot(1:512,ytime);
        %subplot(2,1,2),
        %plot(1:512,aFdata);
        
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
               %  figure
                % plot(1:500,aFdata)
        
        
        
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
        heart_beat_perminute = floor(heart_beat_num );
        three_chanel_HBP = [three_chanel_HBP,heart_beat_perminute];
    end
    mean_HBP = floor(mean(three_chanel_HBP(1:4))); % 计算两个通道
    dynatise_HBP = [dynatise_HBP,mean_HBP]
    dynatise_HBP_all_channel = [dynatise_HBP_all_channel,three_chanel_HBP(1:4)'] % 计算2个通道
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %呼吸计算
        for filterChannel = 1:SelectChannelNum
        filterdata = data(:,channelSel(filterChannel));
        
       %% 在0.25—0.5Hz找到频率对应振幅最大的点,然后找到心律存在频率
        dt = 1/Fs;
        N = W;

        n = 0:nftt-1;
        t = n * dt;
        f = n / (nftt*dt);
        y = fft(filterdata,nftt);
        %plot(1:512,y)
        f1 = 0.25;
        f2 = 0.5;
        fmax = 0;
        tmpy = abs(y')*2/nftt;
        possible_breath_fre_gap = tmpy(floor(f1*nftt/Fs:f2*nftt/Fs));
        %figure;
        %plot(1:512,tmpy);
        index = find ( possible_breath_fre_gap == max(possible_breath_fre_gap));
        newindex = f1*nftt/Fs + index;
        smaxf = newindex/(nftt*dt);
        maxfs = 0.3
       %figure ;
       %plot (tmpy);
        sfdown =  maxfs-0.15;
        sfup =  max(maxfs + 0.1,0.5);
        yy = zeros(size(y));
        for m = 0:nftt-1;
            if(m/(nftt*dt)>(1/dt-sfup)&&m/(nftt*dt)<(1/dt-sfdown))...
                    ||(m/(nftt*dt)>(1/dt-sfup)&&m/(nftt*dt)<(1/dt-sfdown))
                yy(m+1)=y(m+1);
            else
                yy(m+1)=0;
            end
        end
        %% IFFT
        ytime = ifft(yy,nftt);
        aFdata = ytime(1:W);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%呼吸傅里叶变换        
% %         figure ;
% %         subplot(2,1,1),
% %         plot(1:512,ytime);
% %         subplot(2,1,2),
% %         plot(1:500,aFdata);
        
        % 画图分析
        if  plotlevel3 
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
        
        
        %% *****计算呼吸*******
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
            if(countpartt(i1+1)-countpartt(i1) <= floor(42))
                aFdata(countpartt(i1):countpartt(i1+1)) = aFdata(countpartt(i1));
            end
        end
               %  figure
                % plot(1:500,aFdata)
        
        
        
        % 窗口计步
        center = mean(aFdata);
        max_num = max(aFdata);
        min_num = min(aFdata);
        upper = UPPER_LOWER_LEVEL_COEFF * (max_num - min_num) + center;
        lower = UPPER_LOWER_LEVEL_COEFF * (min_num - max_num) + center;
        max_flag = false;
        min_flag = false;
        flag = false;
        breath_num = 0;
        for i2 = 1:W
            if(aFdata(i2) > center)                  %开始时是大于center
                if(aFdata(i2) > upper)
                    max_flag = true;
                end
                if(flag)                             %之前到了center下方
                    if(min_flag || max_flag)         %上一次极值下穿较大，或者本次上穿较大，并且这一轮并没有记录过                        
                        flag = false;                %当前已经到了center上方
                        min_flag = false;
                        breath_num = breath_num + 1;
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
        breath_perminute = floor(breath_num );
        three_chanel_breath = [three_chanel_breath,breath_perminute];
        end
        mean_breath = floor(mean(three_chanel_breath(1:3))); % 计算两个通道
        dynatise_breath = [dynatise_breath,mean_breath]
        dynatise_breath_all_channel = [dynatise_breath_all_channel,three_chanel_breath(1:3)'] % 计算2个通道
end
dynatise_all1 = sum (dynatise_HBP(1:3));
dynatise_all2 = sum (dynatise_breath(1:3));
%dynatise_all2 = sum (dynatise_HBP(4:6));
%dynatise_all2 = sum (dynatise_HBP(7:12));
%dynatise_all3 = sum (dynatise_HBP(13:18));
%dynatise_all4 = sum (dynatise_HBP(19:24));
% 得到的心律 dynatise_HBP_all_channel dynatise_HBP
%
%

%%% 调试代码
debug = 0;
if debug
    % 心律均值
   dynatise_HBP = dynatise_HBP';
   % 心律所有值
   dynatise_HBP_all_channel = dynatise_HBP_all_channel';
   % 所有选通道
   for ii = 1:3
       for jj = 1:fix(c/W)
           if channelSelAlls(ii, jj) > 9;
               channelSelAlls(ii, jj) = 100 + (channelSelAlls(ii, jj) - 9);
           end
       end
   end
   channelSelAlls = channelSelAlls';
 
end
    

