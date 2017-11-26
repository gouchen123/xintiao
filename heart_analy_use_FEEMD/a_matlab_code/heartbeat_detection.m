%%%心率监测
%%%通过上穿下穿呼吸平滑线作心率的时刻，根据心跳间隔补偿可能漏掉的心跳
function heartbeat_num = heartbeat_detection heartbeat_detection( filtered_data, filtered_hb_data,  heartbeat_up_tag,  heartbeat_per_timeunit,  heartbeat_timestamp,  size_heartbeat_timestamp, heartbeat_lost, heartbeat_lost2)
heartbeat_num =0;
tmp_heartbeat_num =0; 
zero_time_unit_num = 0;
mean_heartbeat_inteval=0;
num_in_time_unit = 0;
for k =1:250
    if heartbeat_up_tag
        if( filtered_hb_data(1,k)+1 < filtered_data(1,k) )
            if ( ((size_heartbeat_timestamp)==0) || (k-heartbeat_timestamp(size_heartbeat_timestamp-1,1) >= 0.4*50) )
                	heartbeat_timestamp(size_heartbeat_timestamp,1) = k;	%记录heartbeat的时刻
					size_heartbeat_timestamp = size_heartbeat_timestamp+1;				%呼吸记录数量加一
					num_in_time_unit=num_in_time_unit+1;
					heartbeat_up_tag = 0;
            end
        end
    else    %检测上穿过程
           if( filtered_hb_data(1,k) > filtered_data(1,k)+1 ) %防止毛刺
               heartbeat_up_tag = 1;
           end
    end
end
for i = 1: size_heartbeat_timestamp;
    heartbeat_timestamp(i,1) = heartbeat_timestamp(i,1) -250;
end
if(size_heartbeat_timestamp >= 35)	
    for j =1:15
        heartbeat_timestamp(j,1) = heartbeat_timestamp(size_heartbeat_timestamp-5*3+j);
    end
    size_heartbeat_timestamp = 15;
end
for i = 1:11  %11还是12?
    heartbeat_per_timeunit(i,1) = heartbeat_per_timeunit(i+1,1);
end
heartbeat_per_timeunit(12,1) = num_in_time_unit;
for k =1:12
    tmp_heartbeat_num  =tmp_heartbeat_num + heartbeat_per_timeunit(k,1);
end
for k =1:12
    if(heartbeat_per_timeunit(k,1)==0)
        zero_time_unit_num=zero_time_unit_num+1
    else
        break;
    end
end
if(zero_time_unit_num == 12)
    heartbeat_num = 0;
else
    heartbeat_num = (60.0*tmp_heartbeat_num/(12- zero_time_unit_num)/5);	%TIMEUINT_NUM_PER_STATISTIC_PERIOD*TIME_UNIT内的呼吸次数
end
end


    
        
    

    
    


    


    
	
    
        