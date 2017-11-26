% heart_beat_perminute_temp = [];
% for i = 1:size(rebuild_data_tmp,2)
%     
%     
%     heart_beat_perminute = countheart(rebuild_data_tmp(:,i),50,1);
%     heart_beat_perminute_temp = [heart_beat_perminute_temp,heart_beat_perminute];
% end

%% 小波变换研究


clear 
close all 
clc
A = importdata('.\data\002T.xls');
save  A
load A
[c,l] = size(A(2000:5000,:))
s = A(2000:5000,7);
figure(3);
plot(s);
% load sumsin
% s = sumsin;

figure(1)
subplot(10,1,1);
plot(s);ylabel('s');

%[c,l] = wavedec(s, 10, 'bior2.6'); % 小波分解
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% level=8; wavename='bior2.6';
% ecgdata=s;
% figure(2);
% plot(ecgdata(1:3000));
% title('原始ECG信号');
% %%%%%%%%%%进行小波变换8层
% [C,L]=wavedec(ecgdata,level,wavename);
% %%%%%%%提取尺度系数，
% A1=appcoef(C,L,wavename,1);
% A2=appcoef(C,L,wavename,2);
% A3=appcoef(C,L,wavename,3);
% A4=appcoef(C,L,wavename,4);
% A5=appcoef(C,L,wavename,5);
% A6=appcoef(C,L,wavename,6);
% A7=appcoef(C,L,wavename,7);
% A8=appcoef(C,L,wavename,8);
% %%%%%%%提取细节系数
% D1=detcoef(C,L,1);
% D2=detcoef(C,L,2);
% D3=detcoef(C,L,3);
% D4=detcoef(C,L,4);
% D5=detcoef(C,L,5);
% D6=detcoef(C,L,6);
% D7=detcoef(C,L,7);
% D8=detcoef(C,L,8);
% %%%%%%%%%%%%重构
% A8=zeros(length(A8),1); %去除基线漂移,8层低频信息
% RA7=idwt(A8,D8,wavename);
% RA6=idwt(RA7(1:length(D7)),D7,wavename);
% RA5=idwt(RA6(1:length(D6)),D6,wavename);
% RA4=idwt(RA5(1:length(D5)),D5,wavename);
% RA3=idwt(RA4(1:length(D4)),D4,wavename);
% RA2=idwt(RA3(1:length(D3)),D3,wavename);
% D2=zeros(length(D2),1); %去除高频噪声，2层高频噪声
% RA1=idwt(RA2(1:length(D2)),D2,wavename);
% D1=zeros(length(D1),1);%去除高频噪声，1层高频噪声
% DenoisingSignal=idwt(RA1(1:length(D1)),D1,wavename);
% figure(666);
% plot(1:3002,DenoisingSignal);
% title('去除噪声的ECG信号'); 
% clear ecgdata;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [c,l] = wavedec(s, 10, 'coif4'); % 小波分解
% ca10 = detcoef(c,l,10); %提取低频成分
% ca9 = detcoef(c,l,9);
% ca8 = detcoef(c,l,8);
% ca7 = detcoef(c,l,7);
% ca6 = detcoef(c,l,6);
% ca5 = detcoef(c,l,5);
% ca4 = detcoef(c,l,4);
% ca3 = detcoef(c,l,3);
% ca2 = detcoef(c,l,2);
% ca1 = detcoef(c,l,1);
% figure(11)
% subplot 311
% plot (ca1)
% subplot 312
% plot (ca2)
% subplot 313
% plot (ca10)
% 
% cd10 = appcoef(c,l,'db4',10); %% 提取高频成分
% cd9 = appcoef(c,l,'db4',10);
% cd8 = appcoef(c,l,'db4',8);
% cd7 = appcoef(c,l,'db4',7);
% cd6 = appcoef(c,l,'db4',6);
% cd5 = appcoef(c,l,'db4',5);
% cd4 = appcoef(c,l,'db4',4);
% cd3 = appcoef(c,l,'db4',3);
% cd2 = appcoef(c,l,'db4',2);
% cd1 = appcoef(c,l,'db4',1);
% 
% figure(22)
% subplot 311
% plot (cd1)
% subplot 312
% plot (cd10)
% subplot 313
% plot (cd3)
% cd1soft = wthresh(cd1,'s', 1.456);  % 对第1层的高频系数设置阈值
% cd2soft = wthresh(cd2,'s', 1.456); 
% cd3soft = wthresh(cd3,'s', 1.456); 
% cd4soft = wthresh(cd4,'s', 1.456); 
% cd5soft = wthresh(cd5,'s', 1.456); 
% cd6soft = wthresh(cd6,'s', 1.456); 
% cd7soft = wthresh(cd7,'s', 1.456); 
% cd8soft = wthresh(cd8,'s', 1.456); 
% cd9soft = wthresh(cd9,'s', 1.456); 
% cd10soft = wthresh(cd10,'s', 1.456); 
% figure(33)
% subplot 311
% plot (cd1soft())
% subplot 312
% plot (cd2soft)
% subplot 313
% plot (cd6soft)
% %c2 = [ca10,cd10soft,cd9soft,cd8soft,cd7soft,cd6soft,cd5soft,...
% %      cd4soft,cd3soft,cd2soft,cd1soft];
% %s2 = waverec(c2,l,'db4');
% %plot(s2);
% 
% 
% ca1soft = wthresh(ca1,'s', 1.456);  % 对第1层的低频频系数设置阈值
% ca2soft = wthresh(ca2,'s', 1.456); 
% ca3soft = wthresh(ca3,'s', 1.456); 
% ca4soft = wthresh(ca4,'s', 1.456); 
% ca5soft = wthresh(ca5,'s', 1.456); 
% ca6soft = wthresh(ca6,'s', 1.456); 
% ca7soft = wthresh(ca7,'s', 1.456); 
% ca8soft = wthresh(ca8,'s', 1.456); 
% ca9soft = wthresh(ca9,'s', 1.456); 
% ca10soft = wthresh(ca10,'s', 1.456);
% %c3 = [ca10soft,ca9soft,ca8soft,ca7soft,ca6soft,ca5soft,...
% %      ca4soft,ca3soft,ca2soft,ca1soft,cd10];
% %s3 = waverec(c3,l,'db4');
% %plot(s3);
% 
% figure(44)
% subplot 411
% plot (ca1soft)
% 
% subplot 412
% plot (ca2soft)
%     new_data = [];
%     data_temp = reshape(movemeanFilter(ca2soft),[],1);
%     new_data = [new_data,data_temp];
%     datatemp = new_data;
% subplot 413
% plot (datatemp)
% subplot 414
% plot (ca5soft)
% 
%     
% %figure
% % 
% % for i = 1:9
% %     deapp = wrcoef('a', c, l, 'db4', 10-i);    
% %     subplot(10,1,i+1);
% %     plot(deapp);
% %     ylabel(['a', num2str(10-i)]);
% % end
% % figure;
% % for i = 1:9
% %     
% %     deap = wrcoef('d', c, l, 'db4', 10-i);    
% %     subplot(10,1,i+1);
% %     plot(deap);
% %     ylabel(['a', num2str(10-i)]);
% % end
% 



deapp_5 = wrcoef('a', c, l, 'coif4', 5);
deapp_6 = wrcoef('d', c, l, 'coif4', 5);
deapp_7 = wrcoef('d', c, l, 'coif4', 6);
deapp_8 = wrcoef('d', c, l, 'coif4', 7);
deapp_11 = deapp_5 + deapp_6;
figure (66); 
subplot 311
plot(deapp_5);
subplot 312
plot(deapp_6);
subplot 313
plot(deapp_7);
title('deapp_5')

%cd1 = wthresh()

% a3 = appcoef(c,l,'db1',3);
% d3 = detcoef(c,l,3);
% d2 = detcoef(c,l,2);
% d1 = detcoef(c,l,1);
% figure(2)
% subplot(515);plot(s);ylabel('s');
% subplot(514),plot(a3);ylabel('a3');
% subplot(513),plot(d3);ylabel('d3');
% subplot(512),plot(d2);ylabel('d2');
% subplot(511),plot(d1);ylabel('d1');
