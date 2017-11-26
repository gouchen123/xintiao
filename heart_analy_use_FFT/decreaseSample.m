function [ output_data ] = decreaseSample( )
%DECREASESAMPLE 降低采样率
%   降低4倍采样率

load x
% x = [1 2 3 4 5 6 7 8];
rawdata = x;
N = 4; % 降低倍数
[r,c] = size(rawdata);
data_temp_2 = [];
for i = 1:c
    data_temp = rawdata(:,i);
    data_temp_1 = data_temp(1:N:r);
    data_temp_2 = [data_temp_2,data_temp_1];
end
output_data = data_temp_2;
