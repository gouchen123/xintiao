function c = movemeanFilter(a)
% 函数功能：五个值滑动平均，输入数据a为行向量，输出：行向量，滑动均值结果
n = length(a);

    c(1)=a(1);
    c(2)=((a(1)+a(2))/2);
    c(3)=((a(1)+a(2)+a(3))/3);
    c(4)=((a(1)+a(2)+a(3)+a(4))/4);
    
for j =5:n
    c(j) = ((a(j)+a(j-1)+a(j-2)+a(j-3)+a(j-4))/5);
end

