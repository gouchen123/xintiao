function breath_num = breath_detection (filtered_data,sensor_index, breath_up_tag, breath_per_timeunit, breath_timestamp, size_breath_timestamp)
 breath_num=0;
 tmp_breath_num=0;
 zero_time_unit_num = 0;
 num_in_time_unit = 0;
 mean=0 ;
 max=0;
 min=4096;
 for k = 1:250
     		if(filtered_data(1,k)>max)
			max = filtered_data(1,k);
            elseif(filtered_data(1,k)<min)
			min = filtered_data(1,k);
            end
 end
 mean = base_line(sensor_index,1);
 for k = 1:250
     if breath_up_tag
         %已经经历过上升过程，只要经历下降过程
         if filtered_data(1,k) < mean-(mean-min)*0.1
             if( ((size_breath_timestamp)==0) || (k-breath_timestamp(size_breath_timestamp-1,1) >= 0.5*50) )
                 breath_timestamp(size_breath_timestamp,1) = k;	%记录呼吸时刻
					size_breath_timestamp=size_breath_timestamp+1;				% 呼吸记录加一
					num_in_time_unit=num_in_time_unit+1;
                    breath_up_tag = 0;
             end
         end
     else
         if( filtered_data(1,k) > mean+(max-mean)*0.1 )
             breath_up_tag = 1
         end
     end
 end
 for i = 1:250
     breath_timestamp(i,1) = breath_timestamp(i,1)-250;
 end
 if(size_breath_timestamp >= 15)
     for j = 1:5
         breath_timestamp(j,1) = breath_timestamp(size_breath_timestamp-5+j,1);
     end
     size_breath_timestamp = 5;
 end
 for i =1:11
     breath_per_timeunit(i,1) = breath_per_timeunit(i+1,1);
 end
 breath_per_timeunit(12,1) = num_in_time_unit;
 for k =1:12
     tmp_breath_num = tmp_breath_num+breath_per_timeunit(k,1);
 end
 for k =1:12
     if(breath_per_timeunit(k,1)==0)
         zero_time_unit_num = zero_time_unit_num+1
     else
         break;
     end
 end
 if(zero_time_unit_num == 12)
  breath_num = 0;
 else
     breath_num = (60.0*tmp_breath_num/(12 - zero_time_unit_num)/5);	%TIMEUINT_NUM_PER_STATISTIC_PERIOD*TIME_UNIT内的呼吸次数，去掉0呼吸时间单元，再算到60s内有多少次呼吸
 end

         
end
 
     
     
     
     
 
     
     
     
     
         
     
     
     
     
     
 
 
 
     
     
     
 
 
     
 
 
             
         
