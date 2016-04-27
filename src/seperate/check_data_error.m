function [] = check_data_error()
% global filesets;
% global sensorsets_filename;
% global save_path;
% save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% filesets = {'948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};
% sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
%     'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };
global params;

extracted_path = params.path.extracted_path;
save_path = params.path.save_path;
log_path = params.path.log_path;
positionsets = params.file.positionsets;
entitysets = params.file.entitysets;
sensorsets_filename = params.file.sensorsets_filename;
stage_2_check_error_path = [save_path, params.split_op, 'stage_2_check_error'];
params.path.stage_2_check_error_path = stage_2_check_error_path;

if ~exist(stage_2_check_error_path, 'dir')
    mkdir(stage_2_check_error_path);
end

for iposition = 1 : length(positionsets)
    data_nodeid = positionsets{iposition};
    for ientity = 1 : length(entitysets)
        data_entityid = entitysets{ientity};
        for isensor = 1 : length(sensorsets_filename)
            % Judge if certain position has certarin sensor.
            if exist([extracted_path, params.split_op, data_nodeid, '_', ...
                     data_entityid, '_',  sensorsets_filename{isensor}, ...
                     '_sensor_parted.mat'], 'file')
                
                diary([log_path, params.split_op, data_nodeid, '_', ...
                    data_entityid, '_', sensorsets_filename{isensor}, ...
                    '_checked_repeat_and_missing_data.log']);
                diary on;
                
                
                load([extracted_path, params.split_op, data_nodeid,...
                    '_', data_entityid, '_', sensorsets_filename{isensor},...
                    '_sensor_parted.mat']);
                display(['Load historydata_node_10_trans_', data_nodeid,...
                    '_', data_entityid, '_', sensorsets_filename{isensor}, ...
                    '_sensor_parted.mat successfully!',...
                    ' --- ', datestr(now)]);
                diary off;
                diary on;
                
                % Check if there is repeated data.
                % Then delete the repeated data.
                sensor_data = check_repeat_error(sensor_data);
                save([stage_2_check_error_path, params.split_op, data_nodeid,...
                    '_', data_entityid, '_', sensorsets_filename{isensor}, ...
                    '_delete_repeat_data.mat'], ...
                    'sensor_data', '-v7.3');
                display(['Save ', stage_2_check_error_path, params.split_op, data_nodeid,...
                    '_', data_entityid, '_', sensorsets_filename{isensor}, ...
                    '_delete_repeat_data.mat successfully',...
                    ' --- ', datestr(now)]);
                diary off;
                diary on;
                
                % Check if there is missing data.
                % Then split one time-serie file into sevaral files.
                checked_data = check_missingdata_error(sensor_data);
                save([stage_2_check_error_path, params.split_op, data_nodeid,...
                    '_', data_entityid, '_', sensorsets_filename{isensor}, '_checked_missing_data.mat'], ...
                    'checked_data', '-v7.3');
                display(['Save ', stage_2_check_error_path, data_nodeid, '_', ...
                    data_entityid, '_', sensorsets_filename{isensor}, '_checked_missing_data.mat successfully',...
                    ' --- ', datestr(now)]);
                diary off;
            end
        end
    end
end
end


function [sensor_data] = check_repeat_error(sensor_data)

% Sort data according to time.
[~, sort_idx]  = sort(sensor_data.time);
sensor_data.data = sensor_data.data(sort_idx);
sensor_data.time = sensor_data.time(sort_idx);
len = length(sort_idx);
display(['Sort ', num2str(len), ' data successfully!', ' --- ', datestr(now)]);
diary off;  diary on;

% Delete repeated data according to time
[~,none_repeat_idx,~] = unique(sensor_data.time);
sensor_data.data = sensor_data.data(none_repeat_idx);
sensor_data.time = sensor_data.time(none_repeat_idx);
len2 = length(none_repeat_idx);
display(['Delete', num2str(len - len2), ' repeat data successfully!', ' --- ', datestr(now)]);
diary off;  diary on;
end

function [checked_data] = check_missingdata_error(sensor_data)
% Get all time intervals and find abnormal intervals, then split file.

% According to Gaussian Distribution, the number that is out of range
% [average - 3 * std, average + 3 * std] is abnormal number.
% Finding abnormal time intervals.
len = length(sensor_data.time);
time_interval = sensor_data.time(2:len);
time_interval = time_interval - sensor_data.time(1 : (len - 1));
time_interval_mean = mean(time_interval);
time_interval_std = std(time_interval);
time_interval_threshold = time_interval_mean + 3 * time_interval_std;
time_interval_up = time_interval > time_interval_threshold;
time_interval_idx = find(time_interval_up);
if length(time_interval_idx) == 0
    time_interval_idx = [length(time_interval)];
elseif time_interval_idx(end) ~= length(time_interval)
    time_interval_idx = [time_interval_idx; length(time_interval)];
end

display(['Find ', num2str(length(time_interval_idx)), ' time intervals successfully!',...
    ' --- ', datestr(now)]);
diary off;  diary on;


% Split file according to abnormal time intervals.
class checked_data;
checked_data.number = length(time_interval_idx);
checked_data.sensor_data = cell(checked_data.number, 1);
checked_data.nodeid = sensor_data.nodeid;
checked_data.sensorname = sensor_data.sensorname;
checked_data.sensorfilename = sensor_data.sensorfilename;
checked_data.sensorid = sensor_data.sensorid;
checked_data.nodename = sensor_data.nodename;

begin_idx = 1;
for idata = 1 : checked_data.number
    end_idx = time_interval_idx(idata);
    checked_data.sensor_data{idata}.data = sensor_data.data(begin_idx : end_idx);
    checked_data.sensor_data{idata}.time = sensor_data.time(begin_idx : end_idx);
    begin_idx = end_idx + 1;
end

display(['Construct checked_data successfully!', ' --- ', datestr(now)]);
diary off;  diary on;

end
