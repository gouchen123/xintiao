function [A] = loaddata( plotlevel )
%LOADDATA �˴���ʾ�йش˺�����ժҪ
% loadplot(1)
% �˴���ʾ��ϸ˵��

% A R �ֱ��ʾ1 ��18��ͨ��

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