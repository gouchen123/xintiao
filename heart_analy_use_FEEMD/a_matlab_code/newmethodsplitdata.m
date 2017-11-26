

clear all
load IMATTS0615_1_split
for i = 1:2:5
        newdata{(i+1)/2} = [data{i};data{i+1}];
end