function data_output = filters( data,  size,  data_buffer,  smooth_window)
sum = 0;
i = 1;
data_output = 0
for i =1:smooth_window
    sum = data_buffer(:,i)
end
for i =1:smooth_window
    sum = sum-data_buffer(:,i)+data(:,i);
	data_output(1,i) = uint16(sum/smooth_window);
end
for i = smooth_window : size 
    sum = sum-data(:,i-smooth_window)+data(:,i);
	data_output(:,i) =uint16(sum/smooth_window);
end       
    
