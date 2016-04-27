function [] = integerate_into_time_complete()
% integerate several sensors in same position into a file.
%
%
%

% save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% filesets = {'948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};
% sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
%     'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };

global params;
save_path = params.path.save_path;
log_path = params.path.log_path;
positionsets = params.file.positionsets;
entitysets = params.file.entitysets;
sensorsets_filename = params.file.sensorsets_filename;
stage_2_check_error_path = params.path.stage_2_check_error_path;
stage_3_integerate_path = [save_path, params.split_op, 'stage_3_integerate'];
params.path.stage_3_integerate_path = stage_3_integerate_path;
if ~exist(stage_3_integerate_path)
    mkdir(stage_3_integerate_path);
end

for iposition = 1 : length(positionsets)
    data_nodeid = positionsets{iposition};
    for ientity = 1 : length(entitysets)
        data_entityid = entitysets{ientity};
        
        sensor_num = 0;
        % Calculate the number of sensors in certain position.
        for isensor = 1 : length(sensorsets_filename)
            if exist([stage_2_check_error_path, params.split_op, data_nodeid, ...
                    '_', data_entityid, '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat'...
                    ], 'file')
                sensor_num = sensor_num + 1;
            end
        end
        
        if sensor_num == 0
            continue;
        end
        
        diary([log_path, params.split_op, 'integerate_into_time_complete.log']);
        diary on;
        
        % Save integerated data in 'node_data'.
        class node_data;
        data = cell(sensor_num, 1);
        time = cell(sensor_num, 1);
        node_data.sensorname = cell(sensor_num, 1);
        node_data.sensorfilename = cell(sensor_num, 1);
        node_data.sensorid = cell(sensor_num, 1);
        
        sensor_num = 0;
        for isensor = 1 : length(sensorsets_filename)
            sensor_time_total = [];
            if exist([stage_2_check_error_path, params.split_op, data_nodeid,...
                    '_', data_entityid, '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat'...
                    ], 'file')
                load([stage_2_check_error_path, params.split_op, data_nodeid, ...
                    '_', data_entityid, '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat']) ;
                node_data.nodeid = sensor_data.nodeid;
                node_data.entityid = sensor_data.entityid;
                sensor_num = sensor_num + 1;
                node_data.sensorname{sensor_num} = sensor_data.sensorname;
                node_data.sensorfilename{sensor_num} = sensor_data.sensorfilename;
                node_data.sensorid{sensor_num} = sensor_data.sensorid;
                data{sensor_num} = sensor_data.data;
                time{sensor_num} = sensor_data.time;
                % Get all time points and delete repeated ones.
                sensor_time_total = [sensor_time_total; time{sensor_num}];
                sensor_time_total = unique(sensor_time_total);
                display(['Load ', stage_2_check_error_path, params.split_op, data_nodeid, '_',...
                    data_entityid, '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat successfully!',...
                    ' --- ', datestr(now)]);
                diary off;      diary on;
            end
        end
        
        % Sort all time points and reserve time points that contain all sensor
        % data.
        sensor_time_sorted = sort(sensor_time_total);
        len_sensor_time = length(sensor_time_sorted);
        node_data.time = zeros(len_sensor_time, 1);
        node_data.data = zeros(len_sensor_time, sensor_num);
        
        now_idx = ones(sensor_num, 1);
        total_idx = 0;
        block_size = 100000;
        for i = 1 : len_sensor_time
            find = 0;
            for j = 1 : sensor_num
                while (time{j}(now_idx(j)) < sensor_time_sorted(i)) && (now_idx(j) < length(time{j}))
                    now_idx(j) = now_idx(j) + 1;
                end
                if time{j}(now_idx(j)) == sensor_time_sorted(i)
                    find = find + 1;
                end
            end
            
            if find == sensor_num
                total_idx = total_idx + 1;
                for j = 1 : sensor_num
                    node_data.data(total_idx, j) = data{j}(now_idx(j));
                end
                node_data.time(total_idx) = sensor_time_sorted(i);
            end
            
            if mod(i, block_size) == 0
                display(['Construct ', num2str(i), ' of ', num2str(len_sensor_time), ...
                    ' time complete data.', ' --- ', datestr(now)]);
                diary off;       diary on;
            end
        end
        
        node_data.data = node_data.data(1:total_idx, :);
        node_data.time = node_data.time(1:total_idx, :);
        
        display(['Finish constructing ', num2str(total_idx), ' time points time complete data!',...
            ' --- ', datestr(now)]);
        diary off;      diary on;
        
        save([stage_3_integerate_path, params.split_op, data_nodeid, '_', data_entityid,...
            '_time_completed.mat'], 'node_data', '-v7.3');
        display([stage_3_integerate_path, params.split_op, data_nodeid, '_',...
            data_entityid, '_time_completed.mat is saved successfully!',...
            ' --- ', datestr(now)]);
        diary off;
    end
end
end



