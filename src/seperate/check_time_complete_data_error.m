function [] = check_time_complete_data_error()
% Find abnormal time intervals and split the whole file into several
% consecutive files.
%
%
% global save_path;
% global filesets;
% global sensorsets_filename;
% save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% filesets = {'948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};
% sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
%     'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };

global params;
save_path = params.path.save_path;
log_path = params.path.log_path;
positionsets = params.file.positionsets;
entitysets = params.file.entitysets;
stage_3_integerate_path = params.path.stage_3_integerate_path;
stage_4_split_path = [params.path.save_path, params.split_op, 'stage_4_split'];
params.path.stage_4_split_path = stage_4_split_path;
if ~exist(stage_4_split_path)
    mkdir(stage_4_split_path);
end

% List all positions.
for iposition = 1 : length(positionsets)
    data_nodeid = positionsets{iposition};
    for ientity = 1 : length(entitysets)
        data_entityid = entitysets{ientity};
        if ~exist([stage_3_integerate_path, params.split_op, data_nodeid, '_', data_entityid,...
                '_time_completed.mat'], 'file')
            continue;
        end
        
        diary([log_path, params.split_op, data_nodeid, '_', data_entityid,...
            '_checked_time_completed.log']);
        diary on;
        
        load([stage_3_integerate_path, params.split_op, data_nodeid, '_', data_entityid,...
            '_time_completed.mat']);
        display(['Load ',stage_3_integerate_path, params.split_op, data_nodeid,...
            '_', data_entityid, '_time_completed.mat successfully!', ' --- ', datestr(now)]);
        diary off;      diary on;
        
        checked_node_data = check_time_complete_missingdata_error(node_data);
        
        save([stage_4_split_path, params.split_op, data_nodeid, '_', data_entityid, '_checked_time_completed.mat'],...
            'checked_node_data', '-v7.3');
        display([stage_4_split_path, params.split_op, data_nodeid, ...
            '_', data_entityid, '_checked_time_completed.mat saved successfully!', ...
            ' --- ', datestr(now)]);
        diary off;
    end
end
end


function [checked_node_data] = check_time_complete_missingdata_error(node_data)
% According to Gaussian Distribution.
% Find abnormal time intervals.
len = length(node_data.time);
time_interval = node_data.time(2:len);
time_interval = time_interval - node_data.time(1 : (len - 1));
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
display(['Find ', num2str(length(time_interval_idx)), ' time intervals successfully!', ...
    ' --- ', datestr(now)]);
diary off;      diary on;

class checked_node_data;
checked_node_data.number = length(time_interval_idx);
checked_node_data.node_data = cell(checked_node_data.number, 1);
checked_node_data.nodeid = node_data.nodeid;
checked_node_data.sensorname = node_data.sensorname;
checked_node_data.sensorfilename = node_data.sensorfilename;
checked_node_data.sensorid = node_data.sensorid;
checked_node_data.entityid = node_data.entityid;

begin_idx = 1;
for idata = 1 : checked_node_data.number
    end_idx = time_interval_idx(idata);
    checked_node_data.node_data{idata}.data = node_data.data(begin_idx : end_idx, :);
    checked_node_data.node_data{idata}.time = node_data.time(begin_idx : end_idx);
    begin_idx = end_idx + 1;
end

display(['Construct checked_data successfully!', ' --- ', datestr(now)]);
diary off;      diary on;

end
