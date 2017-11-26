                        % 0614
                        %% 测试EEMD
                        % 添加2种方案，detar取值，2次重构


                        %% 设置相关参数
                        % clear
                        close all
                        plotlevel0 = 0; %是否画原来图像
                        plotlevel0_1 = 0; %是否画平滑滤波后的图像
                        plotlevel1 = 1; %是否画imf图
                        plotlevel2 = 0; %是否画imf的频谱图
                        plotlevel3 = 0; %是否画imf对应能量所占百分比
                        plotlevel4 = 0; %是否画第一次重构后的图像
                        plotlevel6 = 0; %是否画第二次重构的imf
                        plotlevel7 = 0; %是否画第二次重构后的图像

                        Fs = 50;T = 60;
                       
                        channelSelAll = [];
                        dynatise_HBP =[];
                        dynatise_breath =[];
                        dynatise_HBP_all_channel = [];
                        dynatise_breath_all_channel = [];


                        nfft = 1024;
                        x_f = (1:nfft)/nfft*Fs;

                        %% load data
                        % split_data = splitdata(1000,0,0,1);
                        load A; 
                        [c,r] = size(A(2001:5000,:));
                        split_data = A;
                        W = 1000; 
                        channel_num = r;
 for i = 0:fix(c/W)-1
    % for i = 0:0
    data = A(i*W+1:i*W+W,:);
    t = i*W+1:i*W+W;
    t_temp = i*W+1:i*W+W;
    %% **** 滑动滤波
    new_data = [];
    for temp_i = 1:channel_num
        data_temp = data(:,temp_i);
        data_temp = reshape(movemeanFilter(data_temp),[],1);
        new_data = [new_data,data_temp];
    end
    datatemp = data;
 %% 通道选择
 three_chanel_HBP = [];
    three_chanel_breath = [];
channelSel_temp = channelget(datatemp);%返回对应窗口所选3个通道
for ns = channelSel_temp ();
data = datatemp(:,ns);
                          % data = split_data{3}(:,15); % 取第三个窗口第16个通道数据
                if plotlevel0
                            figure
                            plot(t_temp,data);title('画出原始图形');
                        end
                        %% 平滑滤波
                        % 5点平滑滤波（是否需要）c = movemeanFilter(a)
                        aftersmooth_data = data;                    % 不进行平滑滤波
                         %aftersmooth_data = movemeanFilter(data);    % 进行平滑滤波
                        if plotlevel0_1
                            figure
                            plot(t,aftersmooth_data);title('画出滤波后图形');
                        end
                        %% 第一次EEMD分解得到模态函数
                        % 使用EEMD分解信号
                        Nstd = 0.2;
                        NE = 100;
                        allmode = eemd(aftersmooth_data,Nstd,NE,-1); % N*(m+1) matrix，allmode为imf和re
                        m = size(allmode,1)-1; % m=imf index

                        % 画出imf和re图形
                        if plotlevel1
                            for i = 0:4:m
                                figure
                                for j = 1:min(4,m - i + 1)
                                    subplot(4,1,j),plot(t,allmode(i+j,:));
                                    grid minor;title('画出imf和re图形');
                                end
                            end
                        end

                        %% 第一次imf 求功率占比，得到重构索引
                        % 每个imf求功率
                        for i = 1:(m+1)
                            power_imf{i} =  bandpower(allmode(i,:),50,[0.2 2]);
                        end
                        % 每个imf_h 求功率并计算占比例
                        per_power_imf_h = [];
                        for i = 1:(m+1)
                            power_imf_h{i}  =  bandpower(allmode(i,:),50,[1 2]);
                            per_power_imf_h_temp{i} = power_imf_h{i}  / power_imf{i};
                            per_power_imf_h = [per_power_imf_h,per_power_imf_h_temp{i}];
                        end
                        % 每个imf_r 求功率并计算占比例
                        per_power_imf_r = [];
                        for i = 1:(m+1)
                            power_imf_r{i} =  bandpower(allmode(i,:),50,[0.2 0.5]);
                            per_power_imf_r_temp{i} = power_imf_r{i}  / power_imf{i};
                            per_power_imf_r = [per_power_imf_r,per_power_imf_r_temp{i}];
                        end
                        % 重构索引
                        r_index = [];
                        h_index = [];
                        for i = 1:m+1 
                            if per_power_imf_r(i) > 0.5 
                                r_index =  [r_index, i];
                            end
                            if per_power_imf_h(i) > 0.5 
                                h_index =  [h_index, i];
                            end
                        end
                        r_index_max = max(r_index);
                        r_index_min = min(r_index);
                        h_index_max = max(h_index);
                        h_index_min = min(h_index);

                        %% 第一次数据重构
                        % 调用函数rebuild( input,k1,k2 )
                        rebuild_data_r = rebuild(allmode,r_index_min,r_index_max);% 重构呼吸信号
                        rebuild_data_h = rebuild(allmode,h_index_min+2,h_index_max);% 重构心跳信号,前两个是噪声，后边的是呼吸信号
                        if plotlevel4 %% 画第一重构信号
                            figure
                            subplot(311);
                            plot(t,aftersmooth_data);
                             title('原信号');
                            subplot(312);
                            plot(t,rebuild_data_r);ylabel('rebuild_data_r')
                             title('第一次重构呼吸信号');
                            subplot(313);
                            plot(t,rebuild_data_h);ylabel('rebuild_data_h')
                            title('第一次重构心跳信号');
                        end
                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 aFdata = rebuild_data_r;
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
            if(countpartt(i1+1)-countpartt(i1) <= floor(1))
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
        for i2 = 1:1000
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
        dynatise_breath = [dynatise_breath,mean_breath];
        dynatise_breath_all_channel = [dynatise_breath_all_channel,three_chanel_breath(1:3)']; % 计算2个通道
        breath_all = sum (dynatise_breath_all_channel) 
        breath = sum(breath_all)/3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %% 画出第一次重构信号的频谱
                        fre_raw_One = getpsd(rebuild_data_h,nfft,Fs);
                        
                        %figure
                        %plot(x_f, fre_raw_One);title('画出第一次重构信号的频谱');
                        %xlim([0 2]);grid minor;
 
                        %% 第二次分解得到模态函数
                        % 使用EEMD分解信号
                        Nstd = 0.2;
                        NE = 100;
                        allmode_2 = eemd(rebuild_data_h,Nstd,NE,-1); % N*(m+1) matrix，allmode为imf和re
                        M = size(allmode_2,1)-1; % m=imf index

                        % 画出imf和re图形
                        if plotlevel6
                            for i = 0:4:M
                                figure
                                for j = 1:min(4,M - i + 1)
                                    subplot(4,1,j),plot(t,allmode_2(i+j,:));
                                    grid minor;title('画出第二次imf和re图形');
                                end
                            end
                        end

                        %% 第二次imf 求功率占比，得到重构索引
                        % 每个imf求功率
                        for i = 1:(M+1)
                            power_imf{i} =  bandpower(allmode_2(i,:),50,[0.2 2]);
                        end
                        % 每个imf_h 求功率并计算占比例
                        per_power_imf_h = [];
                        for i = 1:(M+1)
                            power_imf_h{i}  =  bandpower(allmode_2(i,:),50,[1 2]);
                            per_power_imf_h_temp{i} = power_imf_h{i}  / power_imf{i};
                            per_power_imf_h = [per_power_imf_h,per_power_imf_h_temp{i}];
                        end
                        % 每个imf_r 求功率并计算占比例
                        per_power_imf_r = [];
                        for i = 1:(M+1)
                            power_imf_r{i} =  bandpower(allmode_2(i,:),50,[0.2 0.5]);
                            per_power_imf_r_temp{i} = power_imf_r{i}  / power_imf{i};
                            per_power_imf_r = [per_power_imf_r,per_power_imf_r_temp{i}];
                        end
                        % 重构索引
                        r_index_Two = [];
                        h_index_Two = [];
                        for i = 1:M+1 
                            if per_power_imf_r(i) > 0.5 
                                r_index_Two =  [r_index_Two, i]
                            end
                            if per_power_imf_h(i) > 0.5 
                                h_index_Two =  [h_index_Two, i]
                            end
                        end
                        r_index_max_Two = max(r_index_Two);
                        r_index_min_Two = min(r_index_Two);
                        h_index_max_Two = max(h_index_Two);
                        h_index_min_Two = min(h_index_Two);

                        %% 第二次信号重构
                        % 调用函数rebuild( input,k1,k2 )
                        rebuild_data_r = rebuild(allmode_2,r_index_min_Two,r_index_max_Two);% 重构呼吸信号
                        rebuild_data_h_two = rebuild(allmode_2,h_index_min_Two+2,M-2);% 重构心跳信号 % 前面是噪声，后面是趋势项
                        if plotlevel7
                            figure
                             subplot(211);plot(t,rebuild_data_r);ylabel('rebuild_data_r');
                            subplot(212);plot(t,rebuild_data_h_two);ylabel('rebuild_data_h');title('rebuild_data_h');

                        end

                        %% 画出第二次重构信号的频谱
                        fre_raw = getpsd(rebuild_data_h_two,nfft,Fs);
                        %figure
                        %plot(x_f, fre_raw);
                       % xlim([0 2]);grid minor;

 end
         










                        %% 模态函数求频谱
                        % 调用函数求每一个imf函数和red函数的频谱 getpsd( xn,nfft,Fs)
                        frequen = cell(1,m+1);
                        for i = 1:(m+1)
                            frequen{i} = getpsd(allmode(i,:),nfft,Fs);
                        end

                        %画出原始信号的频谱

                        fre_raw = getpsd(data,nfft,Fs);
                        figure
                        plot(x_f, fre_raw);
                        xlim([0 2]);grid minor;

                        %  画出imf和re图形的频谱
                        if plotlevel2

                            for i = 0:4:m
                                figure
                                for j = 1:min(4,m-i+1 )
                                    subplot(4,1,j), plot(x_f, frequen{i+j});
                                    xlim([0 2]);grid minor;
                                end
                            end
                        end

                        %% 模态函数求能量，返回能量百分比
                        % 调用函数求每一个imf函数对应的能量 getenergy( xn )
                        energy = zeros(1,m);
                        for i = 1:(m)
                            energy(i) = getenergy(allmode(i,:));
                        end
                        % 计算能量所占百分比，并画图
                        Energy = sum(energy);
                        percent_energy = energy/Energy;
                        if plotlevel3
                            figure
                            bar(percent_energy);
                        end



                        % 画出重构信号的频谱
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




