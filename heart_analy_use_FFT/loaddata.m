function [A] = loaddata( plotlevel )
%LOADDATA 此处显示有关此函数的摘要
% loadplot(1)
% 此处显示详细说明

% A R 分别表示1 到18个通道

plotlevel = 1;
%A = importdata('.\data\datawjj.xls');
%A = importdata('.\data\测试数据.xls');
%A = importdata('.\data\001P.xls');
%A = importdata('.\data\002T.xls');
A = importdata('.\data\ceshi1.xls');
    figure
    plot(A);
    strips(A)
    figure
    plot(A(:,15));
save  A
