datas = [1 1 1 1 1 ; 2 2 2 2 2; 3 3 3 3 3 ]
k = zeros(3,1)
for i = 1:3
k(i,:) = mean (datas(i,:))
end