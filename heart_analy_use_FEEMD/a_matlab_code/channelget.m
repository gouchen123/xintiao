function channelSel = channelget(data)
%CHANNELGET ѡ��ͨ��

%   �˴���ʾ��ϸ˵��
% ѡ��һ�������ϵ�3��ͨ��
% ѡȡ����С��4095�ҽ�ֹ���ٲ�����ƽ��ֵ֮��200ֵ��������3��ͨ��,
%

channel_num = size(data,2);
W = size(data,1);

SelectChannelNum = 3;
PointNumcount = zeros(1,channel_num);
% PointNumcount1 = zeros(1,channel_num);
TopPointNum = zeros(1,channel_num);
channel_data_mean = zeros(1,channel_num);

for channel = 1:channel_num
    % ��ֹ����
    for j = 1:W
        if (data(j,channel) == 4095 )
            TopPointNum(channel) = TopPointNum(channel) + 1;
        end
    end
    channel_data_mean(channel) = mean(data(:,channel));
    %С��4095�Ҵ���2500����
    for j = 1:W
        if (data(j,channel) < 4095 && data(j,channel) > channel_data_mean(channel) + 200 && TopPointNum(channel) <= W*0.02)
            PointNumcount(channel) = PointNumcount(channel) + 1;
        end
    end
end


% ��������
PointNumcount1 = sort(PointNumcount);
% ����������Ӧ�ĵ���
LastOneChannelPointValue = PointNumcount1(channel_num);
LastSecondChannelPointValue = PointNumcount1(channel_num - 1);
LastThirdChannelPointValue = PointNumcount1(channel_num - 2);
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
% channelSel


