function [ ] = printFig( )
% PRINTFIG ��ԭʼ���ݣ�����ͼ
% A��ʾ��һ�ж�Ӧ��һ��ͨ����R��ʾ��18��ͨ��

%   �˴���ʾ��ϸ˵��
plotlevel1 = 1; % �Ƿ���Ҫ������ͼ��
plotlevel2 = 1; % �Ƿ���Ҫ��ÿ��ͼ��

% A = xlsread('.\data\IMATTS0612_1.xlsx','A:R');

A = x;

if plotlevel1
    figure
    plot((1:size(A,1))/100,A);
end

if plotlevel2
for i = 0:6:size(A,2)-1
    figure
    for j = 1:min(6,(size(A,2) - i))
        subplot(6,1,j)
        if (i+j) < 10
            plot((1:size(A,1))/100,A(:,i+j));
            ylabel(sprintf('One.%d',(i+j)));
            ylim([-100,5050]);
        else
            plot((1:size(A,1))/100,A(:,i+j));
            ylabel(sprintf('Two.%d',(i+j-9)));
            ylim([-100,5050]);
        end
        grid minor;
        set(gca,'MinorGridAlpha',0.8);
    end
    
end
end

end

