function channelSel = channelget(data)
%CHANNELGET 选择通道

%   此处显示详细说明
% 选择一条带子上的3个通道
% 选取规则小于4095且截止最少并大于平均值之上200值点数最多的3个通道,
%

channel_num = size(data,2);
W = size(data,1);

SelectChannelNum = 3;
PointNumcount = zeros(1,channel_num);
% PointNumcount1 = zeros(1,channel_num);
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
        if (data(j,channel) < 4095 && data(j,channel) > channel_data_mean(channel) + 200 && TopPointNum(channel) <= W*0.02)
            PointNumcount(channel) = PointNumcount(channel) + 1;
        end
    end
end


% 点数排序
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
% channelSel


