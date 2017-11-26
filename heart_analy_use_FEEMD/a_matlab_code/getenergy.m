function [ Eng ] = getenergy( xn )
Eng = 0;
for i = 1:length(xn)
    
    Eng = Eng +  xn(i) * xn(i);
    
end