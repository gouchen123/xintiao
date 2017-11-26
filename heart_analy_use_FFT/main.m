                %% 选择数据
           % data = splitdata(W,plotlevel1,plotlevel2,window_num)
             %split_data = splitdata(1000,1,1,1);%返回原胞类型
                load IMATTS0615_1_split; 
                split_data = data;

heart_beat_perminute = [];
channelSel = [];
% for choose_window_num = 1:length(split_data)
for choose_window_num = 1:6
                %% 通道选择
                % channelSel = channelget( data)
                channelSel_temp = channelget( split_data{choose_window_num});%返回对应窗口所选3个通道

                %% 滤波
                % aFdata = FFTfilter(Fs,filterdata,nfft,plotlevel1 )
%                 figure
split_data{choose_window_num}(:,channelSel_temp(1)) = 1.5 * split_data{choose_window_num}(:,channelSel_temp(1));
aFdata_1 = FFTfilter(25,split_data{choose_window_num}(:,channelSel_temp(1)),1024,0 ); %返回滤波后数据
                title(sprintf('%d 窗口原始信号频谱',choose_window_num));
%                 aFdata_2 = FFTfilter(100,split_data{choose_window_num}(:,channelSel_temp(2)),1024,0 ); 
%                 aFdata_3 = FFTfilter(100,split_data{choose_window_num}(:,channelSel_temp(3)),1024,0 ); 

                %% 得到心律
                % heart_beat_perminute = countheart(data,Fs)
                heart_beat_perminute_temp = zeros(1,3);
                heart_beat_perminute_temp(1) = countheart(aFdata_1,100,0);
                title(sprintf('第 %d 时间个窗口,选择的通道%d信号---心律: %d',choose_window_num,channelSel_temp(1),...
                              heart_beat_perminute_temp(1)));
%                 heart_beat_perminute_temp(2) = countheart(aFdata_2,100,0);
%                 heart_beat_perminute_temp(3) = countheart(aFdata_3,100,0);
% % % %                 figure;
% % % %                 plot(split_data{choose_window_num}(:,channelSel_temp(1)));grid minor;
% % % %                 title(sprintf('第 %d 时间个窗口,选择的通道%d信号---心律: %d',choose_window_num,channelSel_temp(1),...
% % % %                               heart_beat_perminute_temp(1)));
% % % %          
              

                
     heart_beat_perminute = [heart_beat_perminute,heart_beat_perminute_temp'];
     channelSel = [channelSel,channelSel_temp'];

end
mean_heart_beat_perminute_2 = mean(heart_beat_perminute(1:2,:),1);




% 
% for i = 1:12
%     close(i)
% end





















