function [ output_data ] = decreaseSample(N )
%DECREASESAMPLE ���Ͳ�����
%   ����N��������

load IMATTS0615_2_100_all
% x = [1 2 3 4 5 6 7 8];
rawdata = A;
N = 2; % ���ͱ���
[r,c] = size(rawdata);
data_temp_2 = [];
for i = 1:c
    data_temp = rawdata(:,i);
    data_temp_1 = data_temp(1:N:r);
    data_temp_2 = [data_temp_2,data_temp_1];
end
output_data = data_temp_2;
