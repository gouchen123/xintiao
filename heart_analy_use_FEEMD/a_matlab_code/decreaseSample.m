function [ output_data ] = decreaseSample(N )
%DECREASESAMPLE 降低采样率
%   降低N倍采样率

load IMATTS0615_2_100_all
% x = [1 2 3 4 5 6 7 8];
rawdata = A;
N = 2; % 降低倍数
[r,c] = size(rawdata);
data_temp_2 = [];
for i = 1:c
    data_temp = rawdata(:,i);
    data_temp_1 = data_temp(1:N:r);
    data_temp_2 = [data_temp_2,data_temp_1];
end
output_data = data_temp_2;
