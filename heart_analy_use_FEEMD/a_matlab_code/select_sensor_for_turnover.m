function  result = select_sensor_for_turnover (data,base)
max1=0
max2=0
sum=0
average =0
result = selected_sensors(0,0);
for i = 1:18
    average = base(i,1);
    sum = 0;
    for j =1:250
        sum = sum + (data(i,j)-average)*(data(i,j)-average);
    end
    sum = sum/250;
    if(sum >= max1)
        max2 = max1;
        result.second_sensor_index= result.first_sensor_index;
        max1 = sum;
        result.first_sensor_index = i;
    elseif(sum >= max2)
        max2 = sum;
        result.second_sensor_index = i;
    end
end
end
    
        
        
    



