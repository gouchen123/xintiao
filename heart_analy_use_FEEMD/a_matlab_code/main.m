             close all
             %% ѡ������
                % data = splitdata(W,plotlevel1,plotlevel2,window_num)
                split_data = splitdata(1000,0,0,1);%����ԭ������

heart_beat_perminute = [];
channelSel = [];
for choose_window_num = 1:length(split_data)
                %% ͨ��ѡ��
                % channelSel = channelget( data)
                channelSel_temp = channelget(split_data{choose_window_num});%���ض�Ӧ������ѡ3��ͨ��

                %% �˲�
                % aFdata = FFTfilter(Fs,filterdata,nfft,plotlevel1 )
                aFdata_1 = eemdrebuild(split_data{choose_window_num}(:,channelSel_temp(1))); %�����˲�������
                aFdata_2 = eemdrebuild(split_data{choose_window_num}(:,channelSel_temp(2))); %�����˲�������
                aFdata_3 = eemdrebuild(split_data{choose_window_num}(:,channelSel_temp(3))); %�����˲�������
               %% �õ�����
                % heart_beat_perminute = countheart(data,Fs)
                heart_beat_perminute_temp = zeros(1,3);
                heart_beat_perminute_temp(1) = countheart(aFdata_1,100,1);
                heart_beat_perminute_temp(2) = countheart(aFdata_2,100,0);
                heart_beat_perminute_temp(3) = countheart(aFdata_3,100,0);
                
     heart_beat_perminute = [heart_beat_perminute,heart_beat_perminute_temp'];
     channelSel = [channelSel,channelSel_temp'];

end