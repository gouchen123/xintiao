             close all
             %% 选择数据
                % data = splitdata(W,plotlevel1,plotlevel2,window_num)
                split_data = splitdata(1000,0,0,1);%返回原胞类型

heart_beat_perminute = [];
channelSel = [];
for choose_window_num = 1:length(split_data)
                %% 通道选择
                % channelSel = channelget( data)
                channelSel_temp = channelget(split_data{choose_window_num});%返回对应窗口所选3个通道

                %% 滤波
                % aFdata = FFTfilter(Fs,filterdata,nfft,plotlevel1 )
                aFdata_1 = eemdrebuild(split_data{choose_window_num}(:,channelSel_temp(1))); %返回滤波后数据
                aFdata_2 = eemdrebuild(split_data{choose_window_num}(:,channelSel_temp(2))); %返回滤波后数据
                aFdata_3 = eemdrebuild(split_data{choose_window_num}(:,channelSel_temp(3))); %返回滤波后数据
               %% 得到心律
                % heart_beat_perminute = countheart(data,Fs)
                heart_beat_perminute_temp = zeros(1,3);
                heart_beat_perminute_temp(1) = countheart(aFdata_1,100,1);
                heart_beat_perminute_temp(2) = countheart(aFdata_2,100,0);
                heart_beat_perminute_temp(3) = countheart(aFdata_3,100,0);
                
     heart_beat_perminute = [heart_beat_perminute,heart_beat_perminute_temp'];
     channelSel = [channelSel,channelSel_temp'];

end