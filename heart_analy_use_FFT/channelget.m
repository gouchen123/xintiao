function channelSel = channelget(data)
%CHANNELGET ѡ��ͨ��

%   �˴���ʾ��ϸ˵��
% ѡ��һ�������ϵ�3��ͨ��
% ѡȡ����С��4095�ҽ�ֹ���ٲ�����ƽ��ֵ֮��200ֵ��������3��ͨ��,
%

 channelSel_temp = [];
 for choose_window_num = 1:6
 data = split_data{choose_window_num};
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
                            if (data(j,channel) < 4095 && data(j,channel) > channel_data_mean(channel) + 500 && TopPointNum(channel) <= W*0.02)
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
% channelSel_temp = [channelSel_temp,channelSel'];
%% ������ѡͨ��ͼ
% װ������
if 0
A = split_data{choose_window_num}(:,channelSel_temp(1));
for i = 0:6:size(A,2)-1
    figure
    for j = 1:min(6,(size(A,2) - i))
        subplot(6,1,j)
        if (i+j) < 10
            plot((1:size(A,1))/100,A(:,i+j));
            ylabel(sprintf('One.%d',(i+j)));
%             ylim([-100,5050]);
        else
            plot((1:size(A,1))/100,A(:,i+j));
            ylabel(sprintf('Two.%d',(i+j-9)));
%             ylim([-100,5050]);
        end
        grid minor;
        set(gca,'MinorGridAlpha',0.8);
    end
    title(sprintf('���� %d',choose_window_num));
    
end
end

end
% end
