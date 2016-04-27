function [] = seperate_file_according_to_sensor()
%   Seperate one position csv file into several csv files, which contains
%   information of one sensor.
%
%   'sensor_path' - Path to save sensor csv file.
%
%   ************************************
%   Version : 1.0
%   Modified time : 2015-01-18
%   ************************************


% clear;
% clc;
% save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% filesets = {'927', '948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};

global params;
positionsets = params.file.positionsets;
entitysets = params.file.entitysets;
entity_path = params.path.entity_path;
save_path = params.path.save_path;
log_path = params.path.log_path;
sensor_path = [save_path, params.split_op, 'sensor'];
params.path.sensor_path = sensor_path;
if ~exist(sensor_path, 'dir')
    mkdir(sensor_path);
end

% Log file.
diary([log_path, params.split_op, 'seperate_file_according_to_sensor.log']);
diary on;

sensorsets = {};
tic;
% Seperate every position file into sensor files.
for iposition = 1 : length(positionsets)
    for ientity = 1 : length(entitysets)
        if ~exist([entity_path, params.split_op, positionsets{iposition}, '_',...
                entitysets{ientity}, '.csv'], 'file')
            continue;
        end
        
        fid = fopen([entity_path, params.split_op, positionsets{iposition}, '_',...
                entitysets{ientity}, '.csv']);
        data = textscan(fid, '%[^\n]');
        display([entity_path, params.split_op, positionsets{iposition}, ...
            '.csv loaded successfully!', ' --- ', datestr(now)]);
        diary off;
        diary on;
        
        len = length(data{1});
        len_error = 0;
        width = 20;
        block_size = 10000;
        j = 1 - block_size;
        
        be = 1; en = be + len -1;
        for i = be : en
            data_tmp = textscan(data{1}{i}, '%s', 'delimiter', ',');
            if length(data_tmp{1}) < 2
                % Detecting error of input.
                filename = [sensor_path, params.split_op, 'sensor_error.csv'];
                fid = fopen(filename, 'a+');
                fprintf(fid, [data{1}{i}( data{1}{i} ~= '\' ), '\n']);
                fclose(fid);
                len_error = len_error + 1;
                display(['Error string ', num2str(len_error), ' out of ', num2str(i), ...
                    ' is ', data{1}{i}( data{1}{i} ~= '\' ), ' --- ', datestr(now)]);
                diary off;
                diary on;
            else
                % Dealing with right input.
                % Use position name and sensor name as file name.
                filename = [sensor_path, params.split_op, data_tmp{1}{1}, ...
                    '_', data_tmp{1}{2}, '_', data_tmp{1}{4}, '.csv'];
                sensorsets{length(sensorsets) + 1} = data_tmp{1}{4};
                fid = fopen(filename, 'a+');
                fprintf(fid, [data{1}{i}( data{1}{i} ~= '\' ), '\n']);
                fclose(fid);
            end
            
            % Report according to block.
            if mod(i, block_size) == 0
                % Get sensor names.
                sensorsets = unique(sensorsets);
                j = i - block_size + 1;
                display([entity_path, params.split_op, positionsets{iposition}, ...
                    ' from ', num2str(j), ' to ', num2str(i), ' of ', num2str(len),...
                    ' dealed successfully!', ' --- ', datestr(now)]);
                display(['length of error file of ', num2str(len_error), ' out of ',...
                    num2str(i), ' --- ', datestr(now)]);
                diary off;
                diary on;
            end
        end
        
        j = j + block_size;
        if j ~= len
            sensorsets = unique(sensorsets);
            display([entity_path, params.split_op, positionsets{iposition}, ' from ', ...
                num2str(j), ' to ', num2str(j + len - 1), ' of ', num2str(len), ...
                ' treated successfully!', ' --- ', datestr(now)]);
        end
        sensorsets = unique(sensorsets);
        params.file.sensorsets = sensorsets;
        display(['length of error file of ', num2str(len_error), ' out of ',...
            num2str(len), ' --- ', datestr(now)]);
        display([sensor_path, params.split_op, data_tmp{1}{1}, '_', data_tmp{1}{2}, '_', data_tmp{1}{4},...
            ' from ', num2str(be), ' to ', num2str(en), ' of ', num2str(len), ' in ', ...
            positionsets{iposition}, '.mat saved successfully!', ' --- ', datestr(now)]);
        diary off;
    end
    
end
end

