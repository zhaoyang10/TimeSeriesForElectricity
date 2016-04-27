clear;
clc;

for i = 1 : len_sensorid
    %load('historydata_node_10_trans_681_sensor_parted.mat');
    save([save_path, 'historydata_node_10_trans_',  nodeid_uni{i}, ...
        '_sensor_parted.mat']);
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
    
    for i = 1 : len_sensorid
        [~, idx] = sort(sensor_time{i});
        sensor_data{i} = sensor_data{i}(idx);
        sensor_time{i} = sensor_time{i}(idx);
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
            for j = 1 : len_sensorid
                sensor_temp = [sensor_temp sensor_data{j}(now_idx(j))];
            end
            sensor_data_complete = [sensor_data_complete; sensor_temp];
            sensor_time_complete = [sensor_time_complete; sensor_time_sorted(i)];
        end
    end
    
    save(['historydata_node_10_trans_', data_nodeid, '_time_completed.mat'], 'data_nodeid', 'sensor_data_complete', 'sensor_time_complete', 'sensor_name', '-v7.3');
    toc;
    display(['historydata_node_10_trans_', data_nodeid, '_time_completed.mat saved successfully!']);
end

% col = 'ymcrgbwk';
% figure;
% for i = 1 : 6
%    if i == 5 || i == 1
%        continue;
%    end
%    plot(sensor_time_complete(1:1000), sensor_data_complete(1:1000, i), col(i));
%    hold on;
% end