%% *********����������*********
% ��������ֻ��9��ͨ����ѡȡ9��ͨ������
% ������200HZ
% �����������У����ϴ�

%% ********* loaddata *********
clear

load('newdataone1.mat');
Fs = 100;
x = newdataone;
[c,r]=size(x);
Fs = 100;
W = 2048;

% %ʹ��xlsreadֱ�Ӷ�ȡexcel�ļ�������
% close all
% clear all
% clc
% x = xlsread('ITTMAX1.xls','A:I');
% [c,r]=size(x);%cΪ������rΪ����
% Fs = 200;
% W = 2048; %window ��ʾ����Ĵ��ڴ�С

%%  ����9��ͨ��ԭʼ����
% ���ڹ۲�ԭʼ����
if 1
    
    figure
    channel1 = 1;
    channel2 = 9;
    for n = channel1:channel2
        %  figure
        tmp = x(:,n);
        subplot((channel2 - channel1 + 1),1,n);
        plot([0:c-1]/Fs,tmp);
        %   xlabel('ʱ��/s');
        ylabel(sprintf('��� %d',n));
        grid minor
        %     title(sprintf('channel %d',n));
    end
end

% if 0
%% ****���ڴ�������***
channelSelAll = [];
dynatise_HBP =[];
dynatise_HBP_all_channel = [];
for i = 0:fix(c/W)-1
    % for i = 0:0
    data = x(i*W+1:i*W+W,:);
    
    %% *********ͨ��ѡ��**********
    % ѡ��һ�������ϵ�3��ͨ��
    % ѡȡ����С��4095�ҽ�ֹ���ٲ�����ƽ��ֵ֮��200ֵ��������3��ͨ��,
    %
    SelectChannelNum = 3;
    PointNumcount = zeros(1,9);
    TopPointNum = zeros(1,9);
    channel_data_mean = zeros(1,9);
    for channel = 1:9
        % ��ֹ����
        for j = 1:W
            if (data(j,channel) == 4095 )
                TopPointNum(channel) = TopPointNum(channel) + 1;
            end
        end
        channel_data_mean(channel) = mean(data(:,channel));
        %С��4095�Ҵ���2500����
        for j = 1:W
            if (data(j,channel) < 4095 && data(j,channel) > channel_data_mean(channel) + 500 && TopPointNum(channel) <= W*0.02)
                PointNumcount(channel) = PointNumcount(channel) + 1;
            end
        end
    end
    % ��������
    PointNumcount1 = zeros(1,9);
    PointNumcount1 = sort(PointNumcount);
    % ����������Ӧ�ĵ���
    LastOneChannelPointValue = PointNumcount1(9);
    LastSecondChannelPointValue = PointNumcount1(8);
    LastThirdChannelPointValue = PointNumcount1(7);
    %����������Ӧ��ͨ��
    LastOnechannelSel = find(PointNumcount == LastOneChannelPointValue);
    LastSecondchannelSel = find(PointNumcount == LastSecondChannelPointValue);
    LastThirdchannelSel = find(PointNumcount == LastThirdChannelPointValue);
    
    % ȷ��ͨ��
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
    % ѡ����Ӧ��ͨ��  
    channelSelAll = [channelSelAll,channelSel']; 
    %% *********�˲�**********
    % ÿ��ͨ�ﵥ�������Ż����Կ��Ǿ���3��ͨ��ͬʱ����
    %
    three_chanel_HBP = [];
    for filterChannel = 1:SelectChannelNum
        filterdata = data(:,channelSel(filterChannel));
        
       %% ��0.7��2Hz�ҵ�Ƶ�ʶ�Ӧ������ĵ�,Ȼ���ҵ����ɴ���Ƶ��
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
        
        % ��ͼ����
        plotlevel = 0;
        if  plotlevel 
        figure
        subplot(3,1,1),plot([0:N-1]/Fs,filterdata);
        xlabel('ʱ��/s');
        ylabel('���');
        title(sprintf('%d hzͨ��%dԭʼ�ź�',Fs, channelSel(filterChannel)));
        grid on;        
        subplot(3,1,2),plot([0:N-1]/Fs,real(ifft(yy)));
        xlabel('ʱ��/s');
        ylabel('���');
        title(sprintf('%d hzͨ��%d�˲����ź�',Fs, channelSel(filterChannel)));
        grid on;
        end
        
        aFdata =real(ifft(yy));
        
        %% *****��������*******
        UPPER_LOWER_LEVEL_COEFF = 0.1;
        % ****** �ҳ����ֵ******             
        % countpartt ��ʾ��ֵ���Ӧ�ĵ���
        countpartt = [];
        
        for countparti = 2:length(aFdata)-1
            if(aFdata(countparti) >= aFdata(countparti-1) && aFdata(countparti) > aFdata(countparti+1))
                countpartt = [countpartt, countparti];
            end
            if(aFdata(countparti) <= aFdata(countparti-1) && aFdata(countparti) < aFdata(countparti+1))
                countpartt = [countpartt, countparti];
            end
        end
        
        % �ϲ�̫�����ļ�ֵ
        % i1 ��ʱ����
        for i1 = 1:length(countpartt)-1
            if(countpartt(i1+1)-t(i1) <= floor(0.166*Fs)+1)
                aFdata(countpartt(i1):countpartt(i1+1)) = aFdata(countpartt(i1));
            end
        end
        %         figure
        %         plot(aFdata)
        
        
        
        % ���ڼƲ�
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
            if(aFdata(i2) > center)                  %��ʼʱ�Ǵ���center
                if(aFdata(i2) > upper)
                    max_flag = true;
                end
                if(flag)                             %֮ǰ����center�·�
                    if(min_flag || max_flag)         %��һ�μ�ֵ�´��ϴ󣬻��߱����ϴ��ϴ󣬲�����һ�ֲ�û�м�¼��                        
                        flag = false;                %��ǰ�Ѿ�����center�Ϸ�
                        min_flag = false;
                        heart_beat_num = heart_beat_num + 1;
                    end
                end
            elseif(aFdata(i2) < center)              %�´�center��
                if(~flag)                            %���ֵ�һ�ε���center
                    
                    flag = true;                     %��ʾ�Ѿ�����center�·�
                    max_flag = false;                %�����һ�ֵ�max��־
                    
                elseif(~min_flag && data(j) < lower)
                    
                    min_flag = true;                 %��ʾ����lower
                end
            end
        end
        heart_beat_perminute = floor(heart_beat_num * Fs * 60 / W);
        three_chanel_HBP = [three_chanel_HBP,heart_beat_perminute];
    end
    mean_HBP = floor(mean(three_chanel_HBP(1:2))); % ��������ͨ��
    dynatise_HBP = [dynatise_HBP,mean_HBP]
    dynatise_HBP_all_channel = [dynatise_HBP_all_channel,three_chanel_HBP(1:2)'] % ����2��ͨ��
end

% �õ������� dynatise_HBP_all_channel dynatise_HBP
%
%

