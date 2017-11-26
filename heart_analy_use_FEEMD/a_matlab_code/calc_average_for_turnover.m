function average = calc_average_for_turnover(process_data,start_data)
sum = 0;
average = 0
for i = 1:18
    for j = 1:250
        sum = sum + abs(process_data(i,start_data+j)-base_line(i,1));
    end
end
average = uint16(sum/900);
    



