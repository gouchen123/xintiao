function [A] = loaddata( plotlevel )
%LOADDATA �˴���ʾ�йش˺�����ժҪ
% loadplot(1)
% �˴���ʾ��ϸ˵��

% A R �ֱ��ʾ1 ��18��ͨ��

plotlevel = 1;
%A = importdata('.\data\datawjj.xls');
%A = importdata('.\data\��������.xls');
%A = importdata('.\data\001P.xls');
%A = importdata('.\data\002T.xls');
A = importdata('.\data\ceshi1.xls');
    figure
    plot(A);
    strips(A)
    figure
    plot(A(:,15));
save  A
