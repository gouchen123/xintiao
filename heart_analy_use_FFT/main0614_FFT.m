clear

%% loaddata
load data_test_1;
data_get = data;

%% FFT �˲�
aFdata_1 = FFTfilter(100,data_get,1024,1 ); %�����˲�������

%% �õ�����
% heart_beat_perminute = countheart(data,Fs)

heart_beat_perminute_temp(1) = countheart(aFdata_1,100,1);