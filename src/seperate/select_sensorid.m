clear;
clc;
load('/home/star/datasets/hangzhoujiahe/parted_nodeid_idx/historydata_node_10_trans_681.mat');
display('/home/star/datasets/hangzhoujiahe/parted_nodeid_idx/historydata_node_10_trans_681.mat loaded successfully!');
save_path = '/home/star/datasets/hangzhoujiahe/parted_nodeid_idx/';
% data_sub;
% data_nodeid;

data_sensorid = {data_sub{:,5}}';
data_sensorid_uni = unique(data_sensorid);

len_sample = length(data_sub);
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
        if strcmp(data_sub{j, 5}, data_sensorid_uni{i})
           sensor_name{i} = [sensor_name{i}; data_sub{j, 6}]; 
           sensor_data{i} = [sensor_data{i}; str2num(data_sub{j, 12})];
           sensor_reserve{i} = [sensor_reserve{i}; str2num(data_sub{j, 13})];
           sensor_time{i} = [sensor_time{i}; str2num(data_sub{j, 14})];
           alarm{i} = [alarm{i}; str2num(data_sub{j, 15})];
        end
    end
    sensor_name{i} = unique(sensor_name{i});
    display(['sensor ', i, ' parted successfully!']);
end
save([save_path, 'historydata_node_10_trans_', data_nodeid, ...
    '_sensor_parted.mat'], 'sensor_name', 'sensor_data', 'sensor_reserve', ...
    'sensor_time', 'alarm', 'data_nodeid'); 
display([save_path, 'historydata_node_10_trans_', data_nodeid, '_sensor_parted.mat saved successfully!']);