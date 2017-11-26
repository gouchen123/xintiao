function leaved = leavebed_detection ( data );
average = zeros(18,1);
LEAVEBED_VAR_THRE = 500	
sum=0;
max_var=0;
for i = 1:18
    average(i,:) = mean (data(i,:));
    sum = var(data(i,:))
    if sum >max_var
        max_var=sum
    end
end
if max_var > LEAVEBED_VAR_THRE
    leaved = 0
elseif max_var < LEAVEBED_VAR_THRE
    leaved = 1
end
end


    
    
    
    
