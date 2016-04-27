clear;
clc;
save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
filesets = {'927', '948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};

for ifile = 1 : length(filesets)
    data_nodeid = filesets{ifile};
    fid = fopen([save_path, 'historydata_node_10_trans_', filesets{ifile}, '.csv']);
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
        data{1}{i} = strcat(data{1}{i}, '\N');
        data_tmp = textscan(data{1}{i}, '%s', 'delimiter', ',');
        for k = 1 : min(width, length(data_tmp{1, 1}))
            data_mat{i,k} = data_tmp{1, 1}{k};
        end
        if mod(i, block_size) == 0
            toc;
            j = i - block_size + 1;
            display(['historydata_node_10_trans_', num2str(j), '_to_', ...
                num2str(i), ' of ', filesets{ifile}, ' treated successfully!']);
        end
    end
    j = j + block_size;
    if j ~= len
        toc;
        display(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', ...
            num2str(j), '_to_', num2str(j + len - 1) , ' of ', filesets{ifile}, ' treated successfully!']);
    end
    
    save(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', filesets{ifile}, '.mat'], 'data_mat', '-v7.3');
    toc;
    display(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', filesets{ifile}, '.mat saved successfully!']);
    
    %     nodeid = {data_mat{:,2}}';
    %     nodeid_uni = unique(nodeid);
    %     len_sample = size(data_mat, 1);
    %     len_nodeid = size(nodeid_uni, 1);
    %
    %     idx = cell(len_nodeid, 1);
    %
    %     for i = 1 : len_nodeid
    %         idx{i} = [];
    %         for j = 1 : len_sample
    %             if strcmp(data_mat{j, 2}, nodeid_uni{i})
    %                 idx{i} = [idx{i}; j];
    %             end
    %         end
    %     end
    %    save([save_path, 'historydata_node_10_trans_part_info_', num2str(be), '_to_', num2str(en), '.mat'], 'idx', 'nodeid_uni', '-v7.3');
    %    toc;
    %    display('historydata_node_10_trans_part_info_', num2str(be), '_to_', num2str(en), '.mat saved!');
    
    %     for i = 1 : len_nodeid
    %         data_sub = cell(length(idx{i}), 20);
    %         data_nodeid = nodeid_uni{i};
    %         for j = 1 : length(idx{i})
    %             for k = 1 : 20
    %                 data_sub{j, k} = data_mat{idx{i}(j), k};
    %             end
    %         end
    %         save([save_path, 'historydata_node_10_trans_', nodeid_uni{i}, '.mat'], 'data_sub', 'data_nodeid', '-v7.3');
    %         toc;
    %         display([save_path, 'historydata_node_10_trans_', nodeid_uni{i}, '.mat saved!']);
    %     end
    %
    %     clear data_mat data_sub;
    %     toc;
    
    %     for i1 = 1 : len_nodeid
    %        load([save_path, 'historydata_node_10_trans_', filesets{ifile}, '.mat']);
    
    data_sensorid = {data_mat{:,5}}';
    data_sensorid_uni = unique(data_sensorid);
    
    len_sample = length(data_mat);
    len_sensorid = length(data_sensorid_uni);
    sensor_name = cell(len_sensorid, 1);
    sensor_data = cell(len_sensorid, 1);
    sensor_reserve = cell(len_sensorid, 1);
    sensor_time = cell(len_sensorid, 1);
    alarm = cell(len_sensorid, 1);
    
    for i = 1 : len_sensorid
        sensor_name{i} = [];
        sensor_data{i} = [];
        sensor_reserve{i} = [];
        sensor_time{i} = [];
        alarm{i} = [];
        for j = 1 : len_sample
            if strcmp(data_mat{j, 5}, data_sensorid_uni{i})
                sensor_name{i} = [sensor_name{i}; data_mat{j, 6}];
                sensor_data{i} = [sensor_data{i}; str2num(data_mat{j, 12})];
                sensor_reserve{i} = [sensor_reserve{i}; str2num(data_mat{j, 13})];
                sensor_time{i} = [sensor_time{i}; str2num(data_mat{j, 14})];
                alarm{i} = [alarm{i}; str2num(data_mat{j, 15})];
            end
        end
        sensor_name{i} = unique(sensor_name{i});
        display(['sensor ', num2str(i), ' parted successfully!']);
    end
    save([save_path, 'historydata_node_10_trans_', data_nodeid, ...
        '_sensor_parted', '.mat'], 'sensor_name', 'sensor_data', 'sensor_reserve', ...
        'sensor_time', 'alarm', 'data_nodeid', '-v7.3');
    toc;
    display([save_path, 'historydata_node_10_trans_', data_nodeid, '_sensor_parted', '.mat saved successfully!']);
    %     end
    
%     for il = 1 : len_nodeid
%         load([save_path, 'historydata_node_10_trans_', filesets{ifile}, ...
%             '_sensor_parted', '.mat']);
        sensor_time_total = [];
        len_sensorid = length(sensor_name);
        for i = 1 : len_sensorid
            sensor_time_total = [sensor_time_total; sensor_time{i}];
        end
        sensor_time_total_uni = unique(sensor_time_total);
        sensor_time_sorted = sort(sensor_time_total_uni);
        len_sensor_time = length(sensor_time_sorted);
        
        sensor_time_complete = [];
        sensor_data_complete = [];
        alarm_complete = [];
        
        for i = 1 : len_sensorid
            [~, idx] = sort(sensor_time{i});
            sensor_data{i} = sensor_data{i}(idx);
            sensor_time{i} = sensor_time{i}(idx);
            alarm{i} = alarm{i}(idx);
        end
        
        now_idx = ones(len_sensorid, 1);
        for i = 1 : len_sensor_time
            find = 0;
            for j = 1 : len_sensorid
                while (sensor_time{j}(now_idx(j)) < sensor_time_sorted(i)) && (now_idx(j) < length(sensor_time{j}))
                    now_idx(j) = now_idx(j) + 1;
                end
                if sensor_time{j}(now_idx(j)) == sensor_time_sorted(i)
                    find = find + 1;
                end
            end
            
            if find == len_sensorid
                sensor_temp = [];
                alarm_temp = [];
                for j = 1 : len_sensorid
                    sensor_temp = [sensor_temp sensor_data{j}(now_idx(j))];
                    alarm_temp = [alarm_temp alarm{j}(now_idx(j))];
                end
                alarm_complete = [alarm_complete; alarm_temp];
                sensor_data_complete = [sensor_data_complete; sensor_temp];
                sensor_time_complete = [sensor_time_complete; sensor_time_sorted(i)];
            end
        end
        
        save([save_path,'historydata_node_10_trans_', data_nodeid, '_time_completed', '.mat'], 'data_nodeid', 'sensor_data_complete', 'sensor_time_complete', 'alarm_complete', 'sensor_name', '-v7.3');
        display([save_path,'historydata_node_10_trans_', data_nodeid, '_time_completed', '.mat saved successfully!']);
        
%     end
end
