                        % 0614
                        %% ����EEMD
                        % ���2�ַ�����detarȡֵ��2���ع�


                        %% ������ز���
                        % clear
                        close all
                        plotlevel0 = 0; %�Ƿ�ԭ��ͼ��
                        plotlevel0_1 = 0; %�Ƿ�ƽ���˲����ͼ��
                        plotlevel1 = 1; %�Ƿ�imfͼ
                        plotlevel2 = 0; %�Ƿ�imf��Ƶ��ͼ
                        plotlevel3 = 0; %�Ƿ�imf��Ӧ������ռ�ٷֱ�
                        plotlevel4 = 0; %�Ƿ񻭵�һ���ع����ͼ��
                        plotlevel6 = 0; %�Ƿ񻭵ڶ����ع���imf
                        plotlevel7 = 0; %�Ƿ񻭵ڶ����ع����ͼ��

                        Fs = 50;T = 60;
                       
                        channelSelAll = [];
                        dynatise_HBP =[];
                        dynatise_breath =[];
                        dynatise_HBP_all_channel = [];
                        dynatise_breath_all_channel = [];


                        nfft = 1024;
                        x_f = (1:nfft)/nfft*Fs;

                        %% load data
                        % split_data = splitdata(1000,0,0,1);
                        load A; 
                        [c,r] = size(A(2001:5000,:));
                        split_data = A;
                        W = 1000; 
                        channel_num = r;
 for i = 0:fix(c/W)-1
    % for i = 0:0
    data = A(i*W+1:i*W+W,:);
    t = i*W+1:i*W+W;
    t_temp = i*W+1:i*W+W;
    %% **** �����˲�
    new_data = [];
    for temp_i = 1:channel_num
        data_temp = data(:,temp_i);
        data_temp = reshape(movemeanFilter(data_temp),[],1);
        new_data = [new_data,data_temp];
    end
    datatemp = data;
 %% ͨ��ѡ��
 three_chanel_HBP = [];
    three_chanel_breath = [];
channelSel_temp = channelget(datatemp);%���ض�Ӧ������ѡ3��ͨ��
for ns = channelSel_temp ();
data = datatemp(:,ns);
                          % data = split_data{3}(:,15); % ȡ���������ڵ�16��ͨ������
                if plotlevel0
                            figure
                            plot(t_temp,data);title('����ԭʼͼ��');
                        end
                        %% ƽ���˲�
                        % 5��ƽ���˲����Ƿ���Ҫ��c = movemeanFilter(a)
                        aftersmooth_data = data;                    % ������ƽ���˲�
                         %aftersmooth_data = movemeanFilter(data);    % ����ƽ���˲�
                        if plotlevel0_1
                            figure
                            plot(t,aftersmooth_data);title('�����˲���ͼ��');
                        end
                        %% ��һ��EEMD�ֽ�õ�ģ̬����
                        % ʹ��EEMD�ֽ��ź�
                        Nstd = 0.2;
                        NE = 100;
                        allmode = eemd(aftersmooth_data,Nstd,NE,-1); % N*(m+1) matrix��allmodeΪimf��re
                        m = size(allmode,1)-1; % m=imf index

                        % ����imf��reͼ��
                        if plotlevel1
                            for i = 0:4:m
                                figure
                                for j = 1:min(4,m - i + 1)
                                    subplot(4,1,j),plot(t,allmode(i+j,:));
                                    grid minor;title('����imf��reͼ��');
                                end
                            end
                        end

                        %% ��һ��imf ����ռ�ȣ��õ��ع�����
                        % ÿ��imf����
                        for i = 1:(m+1)
                            power_imf{i} =  bandpower(allmode(i,:),50,[0.2 2]);
                        end
                        % ÿ��imf_h ���ʲ�����ռ����
                        per_power_imf_h = [];
                        for i = 1:(m+1)
                            power_imf_h{i}  =  bandpower(allmode(i,:),50,[1 2]);
                            per_power_imf_h_temp{i} = power_imf_h{i}  / power_imf{i};
                            per_power_imf_h = [per_power_imf_h,per_power_imf_h_temp{i}];
                        end
                        % ÿ��imf_r ���ʲ�����ռ����
                        per_power_imf_r = [];
                        for i = 1:(m+1)
                            power_imf_r{i} =  bandpower(allmode(i,:),50,[0.2 0.5]);
                            per_power_imf_r_temp{i} = power_imf_r{i}  / power_imf{i};
                            per_power_imf_r = [per_power_imf_r,per_power_imf_r_temp{i}];
                        end
                        % �ع�����
                        r_index = [];
                        h_index = [];
                        for i = 1:m+1 
                            if per_power_imf_r(i) > 0.5 
                                r_index =  [r_index, i];
                            end
                            if per_power_imf_h(i) > 0.5 
                                h_index =  [h_index, i];
                            end
                        end
                        r_index_max = max(r_index);
                        r_index_min = min(r_index);
                        h_index_max = max(h_index);
                        h_index_min = min(h_index);

                        %% ��һ�������ع�
                        % ���ú���rebuild( input,k1,k2 )
                        rebuild_data_r = rebuild(allmode,r_index_min,r_index_max);% �ع������ź�
                        rebuild_data_h = rebuild(allmode,h_index_min+2,h_index_max);% �ع������ź�,ǰ��������������ߵ��Ǻ����ź�
                        if plotlevel4 %% ����һ�ع��ź�
                            figure
                            subplot(311);
                            plot(t,aftersmooth_data);
                             title('ԭ�ź�');
                            subplot(312);
                            plot(t,rebuild_data_r);ylabel('rebuild_data_r')
                             title('��һ���ع������ź�');
                            subplot(313);
                            plot(t,rebuild_data_h);ylabel('rebuild_data_h')
                            title('��һ���ع������ź�');
                        end
                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 aFdata = rebuild_data_r;
UPPER_LOWER_LEVEL_COEFF = 0.1;
        % ****** �ҳ����ֵ******             
        % countpartt ��ʾ��ֵ���Ӧ�ĵ���
        countpartt = [];
        
        for countparti = 2:length(aFdata)-1
            if(aFdata(countparti) >= aFdata(countparti-1) && aFdata(countparti) > aFdata(countparti+1))
                countpartt = [countpartt, countparti];
            end
            if(aFdata(countparti) <= aFdata(countparti-1) && aFdata(countparti) < aFdata(countparti+1))
                countpartt = [countpartt, countparti];
            end
        end
        
        % �ϲ�̫�����ļ�ֵ
        % i1 ��ʱ����
        for i1 = 1:length(countpartt)-1
            if(countpartt(i1+1)-countpartt(i1) <= floor(1))
                aFdata(countpartt(i1):countpartt(i1+1)) = aFdata(countpartt(i1));
            end
        end
               %  figure
                % plot(1:500,aFdata)
        
        
        
        % ���ڼƲ�
        center = mean(aFdata);
        max_num = max(aFdata);
        min_num = min(aFdata);
        upper = UPPER_LOWER_LEVEL_COEFF * (max_num - min_num) + center;
        lower = UPPER_LOWER_LEVEL_COEFF * (min_num - max_num) + center;
        max_flag = false;
        min_flag = false;
        flag = false;
        breath_num = 0;
        for i2 = 1:1000
            if(aFdata(i2) > center)                  %��ʼʱ�Ǵ���center
                if(aFdata(i2) > upper)
                    max_flag = true;
                end
                if(flag)                             %֮ǰ����center�·�
                    if(min_flag || max_flag)         %��һ�μ�ֵ�´��ϴ󣬻��߱����ϴ��ϴ󣬲�����һ�ֲ�û�м�¼��                        
                        flag = false;                %��ǰ�Ѿ�����center�Ϸ�
                        min_flag = false;
                        breath_num = breath_num + 1;
                    end
                end
            elseif(aFdata(i2) < center)              %�´�center��
                if(~flag)                            %���ֵ�һ�ε���center
                    
                    flag = true;                     %��ʾ�Ѿ�����center�·�
                    max_flag = false;                %�����һ�ֵ�max��־
                    
                elseif(~min_flag && aFdata(i2) < lower)
                    
                    min_flag = true;                 %��ʾ����lower
                end
            end
        end
        breath_perminute = floor(breath_num );
        three_chanel_breath = [three_chanel_breath,breath_perminute];    
        end
        mean_breath = floor(mean(three_chanel_breath(1:3))); % ��������ͨ��
        dynatise_breath = [dynatise_breath,mean_breath];
        dynatise_breath_all_channel = [dynatise_breath_all_channel,three_chanel_breath(1:3)']; % ����2��ͨ��
        breath_all = sum (dynatise_breath_all_channel) 
        breath = sum(breath_all)/3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %% ������һ���ع��źŵ�Ƶ��
                        fre_raw_One = getpsd(rebuild_data_h,nfft,Fs);
                        
                        %figure
                        %plot(x_f, fre_raw_One);title('������һ���ع��źŵ�Ƶ��');
                        %xlim([0 2]);grid minor;
 
                        %% �ڶ��ηֽ�õ�ģ̬����
                        % ʹ��EEMD�ֽ��ź�
                        Nstd = 0.2;
                        NE = 100;
                        allmode_2 = eemd(rebuild_data_h,Nstd,NE,-1); % N*(m+1) matrix��allmodeΪimf��re
                        M = size(allmode_2,1)-1; % m=imf index

                        % ����imf��reͼ��
                        if plotlevel6
                            for i = 0:4:M
                                figure
                                for j = 1:min(4,M - i + 1)
                                    subplot(4,1,j),plot(t,allmode_2(i+j,:));
                                    grid minor;title('�����ڶ���imf��reͼ��');
                                end
                            end
                        end

                        %% �ڶ���imf ����ռ�ȣ��õ��ع�����
                        % ÿ��imf����
                        for i = 1:(M+1)
                            power_imf{i} =  bandpower(allmode_2(i,:),50,[0.2 2]);
                        end
                        % ÿ��imf_h ���ʲ�����ռ����
                        per_power_imf_h = [];
                        for i = 1:(M+1)
                            power_imf_h{i}  =  bandpower(allmode_2(i,:),50,[1 2]);
                            per_power_imf_h_temp{i} = power_imf_h{i}  / power_imf{i};
                            per_power_imf_h = [per_power_imf_h,per_power_imf_h_temp{i}];
                        end
                        % ÿ��imf_r ���ʲ�����ռ����
                        per_power_imf_r = [];
                        for i = 1:(M+1)
                            power_imf_r{i} =  bandpower(allmode_2(i,:),50,[0.2 0.5]);
                            per_power_imf_r_temp{i} = power_imf_r{i}  / power_imf{i};
                            per_power_imf_r = [per_power_imf_r,per_power_imf_r_temp{i}];
                        end
                        % �ع�����
                        r_index_Two = [];
                        h_index_Two = [];
                        for i = 1:M+1 
                            if per_power_imf_r(i) > 0.5 
                                r_index_Two =  [r_index_Two, i]
                            end
                            if per_power_imf_h(i) > 0.5 
                                h_index_Two =  [h_index_Two, i]
                            end
                        end
                        r_index_max_Two = max(r_index_Two);
                        r_index_min_Two = min(r_index_Two);
                        h_index_max_Two = max(h_index_Two);
                        h_index_min_Two = min(h_index_Two);

                        %% �ڶ����ź��ع�
                        % ���ú���rebuild( input,k1,k2 )
                        rebuild_data_r = rebuild(allmode_2,r_index_min_Two,r_index_max_Two);% �ع������ź�
                        rebuild_data_h_two = rebuild(allmode_2,h_index_min_Two+2,M-2);% �ع������ź� % ǰ����������������������
                        if plotlevel7
                            figure
                             subplot(211);plot(t,rebuild_data_r);ylabel('rebuild_data_r');
                            subplot(212);plot(t,rebuild_data_h_two);ylabel('rebuild_data_h');title('rebuild_data_h');

                        end

                        %% �����ڶ����ع��źŵ�Ƶ��
                        fre_raw = getpsd(rebuild_data_h_two,nfft,Fs);
                        %figure
                        %plot(x_f, fre_raw);
                       % xlim([0 2]);grid minor;

 end
         










                        %% ģ̬������Ƶ��
                        % ���ú�����ÿһ��imf������red������Ƶ�� getpsd( xn,nfft,Fs)
                        frequen = cell(1,m+1);
                        for i = 1:(m+1)
                            frequen{i} = getpsd(allmode(i,:),nfft,Fs);
                        end

                        %����ԭʼ�źŵ�Ƶ��

                        fre_raw = getpsd(data,nfft,Fs);
                        figure
                        plot(x_f, fre_raw);
                        xlim([0 2]);grid minor;

                        %  ����imf��reͼ�ε�Ƶ��
                        if plotlevel2

                            for i = 0:4:m
                                figure
                                for j = 1:min(4,m-i+1 )
                                    subplot(4,1,j), plot(x_f, frequen{i+j});
                                    xlim([0 2]);grid minor;
                                end
                            end
                        end

                        %% ģ̬���������������������ٷֱ�
                        % ���ú�����ÿһ��imf������Ӧ������ getenergy( xn )
                        energy = zeros(1,m);
                        for i = 1:(m)
                            energy(i) = getenergy(allmode(i,:));
                        end
                        % ����������ռ�ٷֱȣ�����ͼ
                        Energy = sum(energy);
                        percent_energy = energy/Energy;
                        if plotlevel3
                            figure
                            bar(percent_energy);
                        end



                        % �����ع��źŵ�Ƶ��
                        %
                        fre_rebuild = getpsd(rebuild_data,nfft,Fs);
                        figure
                        plot(x_f, fre_rebuild);
                        xlim([0 2]);grid minor;
                        fre_rebuild_temp = fre_rebuild(1:21);
                        figure
                        plot( x_f(1:21),fre_rebuild_temp);
                        maxfre = max(fre_rebuild_temp);
                        find(maxfre == fre_rebuild_temp);




