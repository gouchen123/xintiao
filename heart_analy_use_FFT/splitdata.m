function data = splitdata(W,plotlevel1,plotlevel2,window_num)
%SPLITDATA 拆分数据
%   按照每窗口个数据拆分
x = xlsread('.\data\data3.xlsx','A:R');
W = 3500; plotlevel1 = 1;plotlevel2 = 1;window_num = 1;
% load IMATTS0615_2;
% x = A;


[c,r]=size(x);
for i = 1:fix(c/W)
    data{i} = x((i-1)*W+1:i*W,:);
    if plotlevel1
        plot(data{i});
        title(sprintf('第 %d 个窗口 ',i));
    end
end

if plotlevel2
    A = data{window_num};
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
        end
        
    end
end

