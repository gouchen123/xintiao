function data = splitdata(W,plotlevel1,plotlevel2,window_num)
%SPLITDATA 拆分数据
%   按照每窗口个数据拆分
%   返回参数是原胞数据类型，每个原胞是一个窗口数据
%   x = xlsread('.\data\IMATTS0612_1.xlsx','A:R');

% W=1000;
% plotlevel1=0;
% plotlevel2=0;
% window_num=1;

load x;
[c,r]=size(x);

% 分割数据
for i = 1:fix(c/W)
    data{i} = x((i-1)*W+1:i*W,:);
    if plotlevel1
        plot(data{i});
        title(sprintf('第 %d 个窗口 ',i))
    end
end

% 每个窗口画图
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
            set(gca,'MinorGridAlpha',0.8);
        end
        
    end
end

