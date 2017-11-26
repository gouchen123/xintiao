function heart_beat_perminute = countheart(data,Fs,plotlevel1)
% COUNTHEART count ����
% ��һ��ͨ�������ݣ�������Ӧ������ֵ
%   �˴���ʾ��ϸ˵��

W = length(data);
UPPER_LOWER_LEVEL_COEFF = 0.1;
%% ****** �ҳ����ֵ******
% countpartt ��ʾ��ֵ���Ӧ�ĵ���
countpartt = [];

for countparti = 2:length(data)-1
    if(data(countparti) >= data(countparti-1) && data(countparti) > data(countparti+1))
        countpartt = [countpartt, countparti];
    end
    if(data(countparti) <= data(countparti-1) && data(countparti) < data(countparti+1))
        countpartt = [countpartt, countparti];
    end
end

%% �ϲ�̫�����ļ�ֵ
% i ��ʱ����
for i = 1:length(countpartt)-1
    if(countpartt(i+1)-countpartt(i) <= floor(0.166*Fs)+1)
        data(countpartt(i):countpartt(i+1)) = data(countpartt(i));
    end
end

% figure
% plot(data)

%% ���ڼƲ�
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
    plot((1:W)/Fs,data);grid minor;
end
for i2 = 1:W
    if(data(i2) > center)                  %��ʼʱ�Ǵ���center
        if(data(i2) > upper)
            max_flag = true;
        end
        if(flag)                             %֮ǰ����center�·�
            if(min_flag || max_flag)         %��һ�μ�ֵ�´��ϴ󣬻��߱����ϴ��ϴ󣬲�����һ�ֲ�û�м�¼��
                flag = false;                %��ǰ�Ѿ�����center�Ϸ�
                min_flag = false;
                heart_beat_num = heart_beat_num + 1;
                if plotlevel1
                    hold on
                    plot(i2/Fs,data(i2),'or');grid minor;
                end
            end
        end
    elseif(data(i2) < center)              %�´�center��
        if(~flag)                            %���ֵ�һ�ε���center
            
            flag = true;                     %��ʾ�Ѿ�����center�·�
            max_flag = false;                %�����һ�ֵ�max��־
            
        elseif(~min_flag && data(i2) < lower)
            
            min_flag = true;                 %��ʾ����lower
        end
    end
end

%% ����
heart_beat_perminute = floor(heart_beat_num * Fs * 60 / W);

end

