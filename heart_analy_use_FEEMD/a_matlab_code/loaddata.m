function [A] = loaddata( plotlevel )
%LOADDATA 此处显示有关此函数的摘要
% loadplot(1)
% 此处显示详细说明

% A R 分别表示1 到18个通道

%A = importdata('.\data\IMATTS0615_2.xlsx','A:R');
%A = xlsread('.\data\002T.xls','A:R');
%A = xlsread('.\data\datawjj.xls','A:R');
%A = xlsread('.\data\001P.xls','A:R');
A = xlsread('.\data\003TK.xls','A:R');
% if plotlevel
    figure
    plot(A);
    strips(A)
% end


%save IMATTS0615_2_100_all A
save  A