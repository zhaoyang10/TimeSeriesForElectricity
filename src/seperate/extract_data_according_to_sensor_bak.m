clear;
clc;
save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
filesets = {'927', '948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};
sensorsets = {'A相温度', 'A相电流', 'B相温度', 'B相电流', 'C相温度', 'C相电流', '剩余电流', '环境温度' };
for ifile = 1 : length(filesets)
    data_nodeid = filesets{ifile};
    for isensor = 1 : length(sensorsets)
        if ~exist([save_path, 'historydata_node_10_trans_', filesets{ifile}, '_', sensorsets{isensor}, '.csv'], 'file')
            continue;
        end
        fid = fopen([save_path, 'historydata_node_10_trans_', filesets{ifile}, '_', sensorsets{isensor}, '.csv']);
        %fid = fopen('temp.csv');
        data = textscan(fid, '%[^\n]');
        len = length(data{1});
        %len = 1000000;
        width = 20;
        block_size = 10000;
        j = 1 - block_size;
        tic;
        data_mat = cell(len, 20);
        be = 1; en = be + len -1;
        for i = be : en
            data{1}{i} = strcat(data{1}{i});
            data_tmp = textscan(data{1}{i}, '%s', 'delimiter', ',');
            for k = 1 : min(width, length(data_tmp{1, 1}))
                data_mat{i,k} = data_tmp{1, 1}{k};
            end
            if mod(i, block_size) == 0
                toc;
                j = i - block_size + 1;
                display(['historydata_node_10_trans_', num2str(j), '_to_', ...
                    num2str(i), ' of ', filesets{ifile}, '_', sensorsets{isensor}, ' treated successfully!']);
            end
        end
        j = j + block_size;
        if j ~= len
            toc;
            display(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', ...
                num2str(j), '_to_', num2str(j + len - 1) , ' of ', filesets{ifile}, '_', sensorsets{isensor}, ' treated successfully!']);
        end
        
        save(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', filesets{ifile}, '_', sensorsets{isensor}, '.mat'], 'data_mat', '-v7.3');
        toc;
        display(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', filesets{ifile}, '_', sensorsets{isensor}, '.mat saved successfully!']);
        
        data_sensorid = {data_mat{:,5}}';        
        len_sample = length(data_mat);
        sensor_name = cell(1, 1);
        sensor_data = cell(1, 1);
        sensor_reserve = cell(1, 1);
        sensor_time = cell(1, 1);
        alarm = cell(1, 1);
                
        sensor_name{1} = [];
        sensor_data{1} = [];
        sensor_reserve{1} = [];
        sensor_time{1} = [];
        alarm{1} = [];
        for j = 1 : len_sample           
            sensor_name{1} = [sensor_name{1}; data_mat{j, 6}];
            sensor_data{1} = [sensor_data{1}; str2num(data_mat{j, 12})];
            sensor_reserve{1} = [sensor_reserve{1}; str2num(data_mat{j, 13})];
            sensor_time{1} = [sensor_time{1}; str2num(data_mat{j, 14})];
            alarm{1} = [alarm{1}; str2num(data_mat{j, 15})];
            
        end
        sensor_name{1} = unique(sensor_name{1});
        display(['sensor ', num2str(i), ' parted successfully!']);
        
        save([save_path, 'historydata_node_10_trans_', data_nodeid, ...
            '_', sensorsets{isensor}, '_sensor_parted', '.mat'], 'sensor_name', 'sensor_data', 'sensor_reserve', ...
            'sensor_time', 'alarm', 'data_nodeid', '-v7.3');
        toc;
        display([save_path, 'historydata_node_10_trans_', data_nodeid, '_', sensorsets{isensor}, '_sensor_parted', '.mat saved successfully!']);
    end
end
