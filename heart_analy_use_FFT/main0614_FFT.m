clear

%% loaddata
load data_test_1;
data_get = data;

%% FFT 滤波
aFdata_1 = FFTfilter(100,data_get,1024,1 ); %返回滤波后数据

%% 得到心律
% heart_beat_perminute = countheart(data,Fs)

heart_beat_perminute_temp(1) = countheart(aFdata_1,100,1);