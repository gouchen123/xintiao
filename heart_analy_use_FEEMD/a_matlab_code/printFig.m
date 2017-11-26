function [ ] = printFig( )
% PRINTFIG 读原始数据，并画图
% A表示第一列对应第一个通道，R表示第18个通道

%   此处显示详细说明
plotlevel1 = 1; % 是否需要看整体图形
plotlevel2 = 1; % 是否需要看每组图形

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

