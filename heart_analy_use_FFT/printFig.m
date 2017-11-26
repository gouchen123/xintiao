% function [ ] = printFig( )
% PRINTFIG 读原始数据，并画图
% A表示第一列对应第一个通道，R表示第18个通道

%   此处显示详细说明
plotlevel1 = 1; % 是否需要看整体图形
plotlevel2 = 1; % 是否需要看每组图形

% A = xlsread('.\data\IMATTS0615_1.xlsx','A:R');

% A = x;
load IMATTS0615_2; split_data = x;
for choose_window_num = 1:1
% A = split_data{choose_window_num};
A = x;
                if plotlevel1
                   figure;
                   plot((1:size(A,1))/100,A);
%                    title(sprintf('窗口%d',choose_window_num));
                end

                if plotlevel2
                    for i = 0:6:size(A,2)-1
                        figure;
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
                        suptitle(['\fontsize{8}',['窗口',num2str(choose_window_num)]]);    
                    end
                end


                %
                % Fs = 100;
                % test_data = A(:,14);
                % test_data_temp1 = test_data * 1.5;
                % figure
                % subplot(2,1,1),plot((1:length(test_data))/Fs,test_data);
                % subplot(2,1,2),plot((1:length(test_data))/Fs,test_data_temp1);
end
