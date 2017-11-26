function heart_beat_perminute = countheart(data,Fs,plotlevel1)
% COUNTHEART count 心律
% 给一个通道的数据，返回相应的心律值
%   此处显示详细说明

W = length(data);
UPPER_LOWER_LEVEL_COEFF = 0.1;
%% ****** 找出峰谷值******
% countpartt 表示极值点对应的点数
countpartt = [];

for countparti = 2:length(data)-1
    if(data(countparti) >= data(countparti-1) && data(countparti) > data(countparti+1))
        countpartt = [countpartt, countparti];
    end
    if(data(countparti) <= data(countparti-1) && data(countparti) < data(countparti+1))
        countpartt = [countpartt, countparti];
    end
end

%% 合并太靠近的极值
% i 临时变量
for i = 1:length(countpartt)-1
    if(countpartt(i+1)-countpartt(i) <= floor(0.166*Fs)+1)
        data(countpartt(i):countpartt(i+1)) = data(countpartt(i));
    end
end

% figure
% plot(data)

%% 窗口计步
center = mean(data);
max_num = max(data);
min_num = min(data);
upper = UPPER_LOWER_LEVEL_COEFF * (max_num - min_num) + center;
lower = UPPER_LOWER_LEVEL_COEFF * (min_num - max_num) + center;
max_flag = false;
min_flag = false;
flag = false;
heart_beat_num = 0;
if plotlevel1
    figure
    plot((1:W)/Fs,data);
end
for i2 = 1:W
    if(data(i2) > center)                  %开始时是大于center
        if(data(i2) > upper)
            max_flag = true;
        end
        if(flag)                             %之前到了center下方
            if(min_flag || max_flag)         %上一次极值下穿较大，或者本次上穿较大，并且这一轮并没有记录过
                flag = false;                %当前已经到了center上方
                min_flag = false;
                heart_beat_num = heart_beat_num + 1;
                if plotlevel1
                    hold on
                    plot(i2/Fs,data(i2),'or')
                end
            end
        end
    elseif(data(i2) < center)              %下穿center线
        if(~flag)                            %本轮第一次低于center
            
            flag = true;                     %表示已经到了center下方
            max_flag = false;                %清除上一轮的max标志
            
        elseif(~min_flag && data(i2) < lower)
            
            min_flag = true;                 %表示低于lower
        end
    end
end

%% 计数
heart_beat_perminute = floor(heart_beat_num * Fs * 60 / W);

end

