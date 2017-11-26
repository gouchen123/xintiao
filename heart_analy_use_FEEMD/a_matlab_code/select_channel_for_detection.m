function  select_channel_for_detection(max_index, second_index, data, dis_to_avg1, dis_to_avg2,dis_to_bound,base_line)
average = 0;
upper_low = 0;
upper_high = 0; 
lower_high = 0;
lower_low =0;
sum=0;
point_num=zeros(18,1)
max_point_num=0
second_point_num=0;
selected_sensor_use_var =selected_sensors(0,0)
for i = 1:18
    average = base_line(i,1); 
    if (4096-dis_to_bound<average+dis_to_avg2) 
        upper_high  =  4096-dis_to_bound
    else upper_high =average+dis_to_avg2
    end
	upper_low = average+dis_to_avg1;
	lower_high = average-dis_to_avg1;%иооб╤тЁф
    averages = floor(average);
    dis_to_avg2 = floor(dis_to_avg2);
    if (dis_to_bound>averages-dis_to_avg2)
        
	lower_low =  dis_to_bound
    else
      lower_low = average-dis_to_avg2;
    end 
    sum = 0;
    for j=1:250
        if ( ((data(i,j)>=upper_low)&&(data(i,j)<=upper_high)) || ((data(i,j)<=lower_high)&&(data(i,j)>=lower_low)) )
            sum = sum +1
        end
        point_num(i,1)=sum;
    end
end
max_index = 0
second_index =0
for i = 1:18
    if (max_point_num<point_num(i,1))
        	second_point_num = max_point_num;
			max_point_num = point_num(i,1);
			second_index = max_index;
			max_index = i;
    elseif second_point_num<point_num(i,1)
           second_point_num = point_num(i,1);
           second_index = i;
    end
end
if (point_num(second_index,1)<1)
    selected_sensor_use_var = select_sensor_for_turnover(data);
	max_index = selected_sensor_use_var.first_sensor_index;
	second_index = selected_sensor_use_var.second_sensor_index;
end
end

    

    
        
 
    
            
    
    
 

