SAMPLING_FREQUENCY = 50 ;
DMA_BUFFER_SIZE = 18;
NUM_OF_SENSOR = 18	;
TIME_UNIT	= 5	;
BASE_VALUE	= 2048 ;
MAX_BREATH_TIMESTAMP_NUM = TIME_UNIT*4 ;
MAX_HEARTBEAT_TIMESTAMP_NUM	= TIME_UNIT*10 ;
LEAVEBED_VAR_THRE	=	500	;
TURNOVER_THRE	=	200	;
TIMEUINT_NUM_PER_STATISTIC_PERIOD	= 60/TIME_UNIT ;
SMOOTH_WINDOW1 = SAMPLING_FREQUENCY*0.5;
SMOOTH_WINDOW2 = SAMPLING_FREQUENCY*0.167;
DATA_BUFFER_SIZE = SAMPLING_FREQUENCY*TIME_UNIT;
turnover_log = 0 ;
breath_log = 0;
heartbeat_log =0;
respiratary_rate =0;
heartbeat_rate =0;
leavebed_status =0;
abnormal =0;
base_line = zeros(18,1);
%%%%%%%%%%%%%%数据处理
data = zeros(18,500);%存放18个通道的数据
size_data = 0 ;
%%selected_sensors current_selected_sensor,last_selected_sensor={101, 101};
data_buffer_for_breath = zeros(18,uint8(SMOOTH_WINDOW1));
data_buffer_for_breath (:,:)= BASE_VALUE ;
breath_up_tag=0;
breath_timestamp = [];%存放呼吸的时刻
size_breath_timestamp = 0;

%用于另一个通道的呼吸监测
breath0_up_tag=0;
breath0_per_timeunit= [];
breath0_timestamp= [];%存放呼吸的时间
size_breath0_timestamp = 0;
respiratary0_rate = 0;
	%心率测量的变量
data_buffer_for_heartbeat = zeros(NUM_OF_SENSOR,uint8(SMOOTH_WINDOW2));%初始值用BASE_VALUE
data_buffer_for_heartbeat (:,:) = BASE_VALUE ;
heartbeat_up_tag=0;%用于心率监测
heartbeat_per_timeunit = [];%心跳时间
heartbeat_timestamp = [];%	存放心跳的时刻
size_heartbeat_timestamp = 0;
	%心率补偿的变量
heartbeat_lost = 0;%这次心跳与上次心跳之间漏掉的心跳次数，0为未漏掉
heartbeat_lost2 = 0;%这次心跳与上上次心跳之间漏掉的心跳次数
heartbeat1_rate = 0;  
%另一个通道的心率监测
heartbeat2_up_tag=0;%用于心率监测
heartbeat2_per_timeunit = [];%心跳时间
heartbeat2_timestamp = [];%	存放心跳的时刻
size_heartbeat2_timestamp = 0;
heartbeat2_lost = 0;%这次心跳与上次心跳之间漏掉的心跳次数，0为未漏掉
heartbeat2_lost2 = 0;%这次心跳与上上次心跳之间漏掉的心跳次数
heartbeat2_rate = 0;    
flag_per_second=0;
flag_per_timeuint=0;
sensor1_index =0;
sensor2_index =0;
filtered_data=zeros(1,DATA_BUFFER_SIZE);
filtered_hb_data=zeros(1,DATA_BUFFER_SIZE);
for i = 1:NUM_OF_SENSOR
   % data(i,size_data) = input_data(i,:);
end
size_data=size_data+1;%此函数每被调用一次，数据长度加一
if(rem(size_data,SAMPLING_FREQUENCY)==0)%每个TIME_UNIT做一个标记
   flag_per_second = 1;
   if(size_data >= DATA_BUFFER_SIZE)
			flag_per_timeuint = 1;
			size_data = 0;
   end
end
%TIME_UNIT进行一次离床判断
if flag_per_timeuint
    %离床判断，如果离床，应该终止后面的操作，这个执行周期里什么也不做，直接把离床信号发出即可
    if(leavebed_detection(data))
        leavebed_status = 1 ;
        breath_up_tag = 0;
        %初始化各种变量
        breath0_per_timeunit = 0 ;
        size_breath0_timestamp = 0;
        last_selected_sensor.first_sensor_index = 101;
        last_selected_sensor.second_sensor_index = 101;
        heartbeat_up_tag = 0;
        heartbeat_per_timeunit = 0;
        size_heartbeat_timestamp = 0;
        for i = 0 : NUM_OF_SENSOR
            for j =0:SMOOTH_WINDOW1
                data_buffer_for_breath(i,:)=base_line(i);
            end
             for j =0:SMOOTH_WINDOW2
                data_buffer_for_heartbeat(i,:)=base_line(i);
            end
        end
    else
        leavebed_status = 0;
    end
end
if(flag_per_timeuint)
    current_selected_sensor = select_sensor_for_turnover(data);
    if((last_selected_sensor.first_sensor_index ~=101) && (current_selected_sensor.first_sensor_index ~= last_selected_sensor.first_sensor_index) && (current_selected_sensor.second_sensor_index ~= last_selected_sensor.first_sensor_index) && (current_selected_sensor.first_sensor_index ~= last_selected_sensor.second_sensor_index) && (current_selected_sensor.second_sensor_index ~= last_selected_sensor.second_sensor_index))
		turnover_log = 1;
    end
  	last_selected_sensor.first_sensor_index = current_selected_sensor.first_sensor_index;
	last_selected_sensor.second_sensor_index = current_selected_sensor.second_sensor_index;  
    %为呼吸选通道，只考虑下限，不考虑上限
    select_channel_for_detection(sensor1_index, sensor2_index, data, 60, 2000, 0);%为呼吸选通道
    %通道1做呼吸检测
    filter(data(sensor1_index,:), DATA_BUFFER_SIZE, filtered_data, data_buffer_for_breath(sensor1_index,:), SMOOTH_WINDOW1);
    respiratary_rate = breath_detection(filtered_data, sensor1_index, breath_up_tag, breath_per_timeunit, breath_timestamp, size_breath_timestamp);
	%通道2做呼吸检测
    filter(data(sensor2_index,:), DATA_BUFFER_SIZE, filtered_data, data_buffer_for_breath(sensor2_index,:), SMOOTH_WINDOW1);
	respiratary0_rate = breath_detection(filtered_data, sensor2_index, breath0_up_tag, breath0_per_timeunit, breath0_timestamp, size_breath0_timestamp);
    
    if(respiratary0_rate>0)
        if(respiratary_rate>0)
            respiratary_rate = (respiratary0_rate+respiratary_rate)/2;
        else
            respiratary_rate = respiratary0_rate;
        end
        breath_log = 1;
    else
        if(respiratary_rate>0)
            breath_log = 1;
        else
            breath_log = 0;
        end
    end
    select_channel_for_detection(sensor1_index, sensor2_index, data, 60, 2000, 50);%通道选择
    %通道1监测心率
   filtered1_data = filters(data(sensor1_index,:), DATA_BUFFER_SIZE, data_buffer_for_breath(sensor1_index,:), SMOOTH_WINDOW1);%得到较平缓曲线
   filtered_hb_data = filters(data(sensor1_index,:), DATA_BUFFER_SIZE,  data_buffer_for_heartbeat(sensor1_index,:), uint8(SMOOTH_WINDOW2));%得到稍微陡峭曲线
    heartbeat_rate = heartbeat_detection(filtered1_data, filtered_hb_data, heartbeat_up_tag, heartbeat_per_timeunit, heartbeat_timestamp,size_heartbeat_timestamp, heartbeat_lost, heartbeat_lost2);
		
   filtered2_data = filters(data(sensor2_index,:), DATA_BUFFER_SIZE,  data_buffer_for_breath(sensor2_index,:), SMOOTH_WINDOW1);%得到较平缓曲线
   filtered2_hb_data=filters(data(sensor2_index,:), DATA_BUFFER_SIZE,data_buffer_for_heartbeat(sensor2_index,:), uint8(SMOOTH_WINDOW2));%得到稍微陡峭曲线
	heartbeat2_rate = heartbeat_detection(filtered2_data, filtered2_hb_data, heartbeat2_up_tag, heartbeat2_per_timeunit, heartbeat2_timestamp, size_heartbeat2_timestamp, heartbeat2_lost, heartbeat2_lost2);
 
    if(heartbeat2_rate>0)
        if(heartbeat_rate>0)
            heartbeat_rate = (heartbeat2_rate+heartbeat_rate)/2;
        else
            heartbeat_rate = heartbeat_rate;
        end
        heartbeat_log = 1;  
    else
        if(heartbeat_rate>0)
           heartbeat_log = 1;
        else
          heartbeat_log = 0%两个通道都没有监测出心跳
        end
    end
    for i = 1 : NUM_OF_SENSOR;
        for j = 1 : SMOOTH_WINDOW1;
            data_buffer_for_breath(i,j) = data(i,DATA_BUFFER_SIZE-uint8(SMOOTH_WINDOW1)+j);
        end
        for j = 1 : SMOOTH_WINDOW2;
            data_buffer_for_heartbeat(i,j) = data(i,DATA_BUFFER_SIZE-uint8(SMOOTH_WINDOW2)+j);
        end
    end
end   
         
    
    
    



    
    

