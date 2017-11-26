function [ output ] = rebuild( input,k1,k2 )
%REBUILD 模态函数和残差合并
%   输入参数为模态函数（为矩阵数据）、合并k1到k2模态
%   输出参数为合并后的函数

output = sum(input(k1:k2,:),1);


end

