A = xlsread('.\data\002T.xls','A:R');
figure (11)
plot(A)
A = A(2001:5000,:);
[c,r] = size(A(1:3000,:));
up_tag = 0 ;
up_tags = 0 ;
chanel = 6 ;
beatnum = 0;
breathnum = 0;
index1 = [];
index2 = [];
s = A(1:3000,chanel);
[cs,l] = wavedec(s, 10, 'coif4');
data = wrcoef('d', cs, l, 'coif4', 5);
data2= wrcoef('d', cs, l, 'coif4', 7);
plot (s)
figure
plot (data);
for i = 1:(c-1);
if up_tag;
    if(data(i+1) < data(i))    ;
        if length(index1)<2 || index1(length(index1))-index1(length(index1)-1) > 20;
            beatnum = beatnum + 1 ;
            index1 = [index1,i];
            up_tag = 0;
        end
    end    
else 
    if data(i+1) > data(i);
     up_tag = 1;
    end
end
end
figure
plot (data2);
for i = 1:(c-1);
if up_tags;
    if(data2(i+1) < data2(i))
        if length(index2)<2 || index2(length(index2))-index1(length(index2)-1) > 100
            breathnum = breathnum +1   ;
            up_tags = 0;
            index2 = [index2,i];
        end
    end    
else 
    if data2(i+1) > data2(i);
        up_tags = 1;
    end
end
end
disp(beatnum)
disp(breathnum)