function [ output ] = rebuild( input,k1,k2 )
%REBUILD ģ̬�����Ͳв�ϲ�
%   �������Ϊģ̬������Ϊ�������ݣ����ϲ�k1��k2ģ̬
%   �������Ϊ�ϲ���ĺ���

output = sum(input(k1:k2,:),1);


end

