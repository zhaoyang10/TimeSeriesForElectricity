function [] = extract_data_according_to_sensor()
%   Extract data from sensor file to .mat.
%
%
%
%
% clear;
% clc;
% save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';

%global sensorsets_filename;
%global save_path;
global params;

positionsets = params.file.positionsets;
entitysets = params.file.entitysets;
sensorsets = params.file.sensorsets;
sensor_path = params.path.sensor_path;
save_path = params.path.save_path;
log_path = params.path.log_path;
extracted_path = [save_path, params.split_op, 'stage_1_extracted'];
params.path.extracted_path = extracted_path;

if ~exist(extracted_path, 'dir')
    mkdir(extracted_path);
end

% filesets = {'948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};%'927',
% sensorsets = {'A相温度', 'A相电流', 'B相温度', 'B相电流', 'C相温度', 'C相电流', '剩余电流', '环境温度' };
% sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
%     'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };

for iposition = 1 : length(positionsets)
    data_nodeid = positionsets{iposition};
    for ientity = 1 : length(entitysets)
        data_entityid = entitysets{ientity};
        for isensor = 1 : length(sensorsets)
            
            % Find if data_nodeid has the isensor-th sensor.
            if ~exist([sensor_path, params.split_op, data_nodeid, ...
                    '_', data_entityid, '_', sensorsets{isensor}, '.csv'], 'file')
                continue;
            end
            
            % Use English name to replace Chinese name for convenience's sake.
            sensorsets_filename = convert_sensor_name(sensorsets{isensor});
            diary([log_path, params.split_op, data_nodeid, '_', data_entityid, '_',...
                sensorsets_filename, '_sensor_parted.log']);
            diary on;
            display(['Logfile is ', log_path, params.split_op, data_nodeid, '_',...
                data_entityid, '_', sensorsets_filename, '_sensor_parted.log', ' --- ', datestr(now)]);
            tic;
            
            % Load data.
            fid = fopen([sensor_path, params.split_op, data_nodeid, '_', ...
                data_entityid, '_', sensorsets{isensor}, '.csv']);
            display([sensor_path, data_nodeid, '_', data_entityid, '_', ...
                sensorsets{isensor}, '.csv load successfully!', ' --- ', datestr(now)]);
            diary off;      diary on;
            
            
            data = textscan(fid, '%[^\n]');
            len = length(data{1});
            
            % Use 'sensor_data' to store information of certain sensor of certain
            % position.
            class sensor_data;
            sensor_data.nodeid = data_nodeid;
            sensor_data.entityid = data_entityid;
            sensor_data.sensorname = sensorsets{isensor};
            sensor_data.sensorfilename = sensorsets_filename;
            
            sensor_data.data = zeros(len, 1);
            sensor_data.time = zeros(len, 1);

            
            data_tmp = textscan(data{1}{1}, '%s', 'delimiter', ',');
            sensor_data.sensorid = data_tmp{1, 1}{3};
            sensor_data.nodename = data_tmp{1, 1}{4};
            
            width = 20;
            block_size = 10000;
            j = 1 - block_size;
            
            be = 1; en = be + len -1;
            
            display(['Initialization is finished!', ' --- ', datestr(now)]);
            diary off;
            diary on;
            
            for i = be : en
                data_tmp = textscan(data{1}{i}, '%s', 'delimiter', ',');
                % Get information in every time point.
                sensor_data.data(i) = str2num(data_tmp{1, 1}{5});
                sensor_data.time(i) = str2num(data_tmp{1, 1}{6});
                
                if mod(i, block_size) == 0
                    j = i - block_size + 1;
                    display([ num2str(j), ' to ', num2str(i), ' of ', num2str(len),...
                        ' in ', data_nodeid, '_', sensorsets_filename, ...
                        '_sensor_parted treated successfully!', ' --- ', datestr(now)]);
                    diary off;
                    diary on;
                end
            end
            j = j + block_size;
            if j ~= len
                display([num2str(j), ' to ', num2str(j + len - 1) , ' of ', num2str(len),...
                    ' in ', data_nodeid, '_', sensorsets_filename, ...
                    '_sensor_parted treated successfully!', ' --- ', datestr(now)]);
                diary off;
                diary on;
            end
            
            save([extracted_path, params.split_op, data_nodeid, '_', ...
                data_entityid, '_', sensorsets_filename, '_sensor_parted.mat'], ...
                'sensor_data', '-v7.3');
            display([extracted_path, params.split_op, data_nodeid, '_', ...
                data_entityid, '_', sensorsets_filename, '_sensor_parted.mat saved successfully!',...
                ' --- ', datestr(now)]);
            
            diary off;
        end
    end
end
end
