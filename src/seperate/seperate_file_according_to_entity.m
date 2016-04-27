function [] = seperate_file_according_to_entity()
%   Seperate one position csv file into several csv files, which contains
%   information of one entity.
%   
%   'entity_path' - Path to save entity csv file.
%
%   ************************************
%   Version : 2.0
%   Modified time : 2015-03-08
%   ************************************


% clear;
% clc;
% save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% filesets = {'927', '948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};

global params;
positionsets = params.file.positionsets;
position_path = params.path.position_path;
save_path = params.path.save_path;
log_path = params.path.log_path;
entity_path = [save_path, params.split_op, 'entity'];
params.path.entity_path = entity_path;
if ~exist(entity_path, 'dir')
    mkdir(entity_path);
end

% Log file.
diary([log_path, params.split_op, 'seperate_file_according_to_entity.log']);
diary on;

entitysets = {};
tic;
% Seperate every position file into sensor files.
for iposition = 1 : length(positionsets)
    fid = fopen([position_path, params.split_op, positionsets{iposition}, '.csv']);
    data = textscan(fid, '%[^\n]');
    display([position_path, params.split_op, positionsets{iposition}, ...
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
            filename = [entity_path, params.split_op, 'sensor_error.csv'];
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
            filename = [entity_path, params.split_op, data_tmp{1}{1}, ...
                '_', data_tmp{1}{2}, '.csv'];
            entitysets{length(entitysets) + 1} = data_tmp{1}{2};
            fid = fopen(filename, 'a+');
            fprintf(fid, [data{1}{i}( data{1}{i} ~= '\' ), '\n']);
            fclose(fid);
        end
        
        % Report according to block.
        if mod(i, block_size) == 0
            % Get sensor names.
            entitysets = unique(entitysets);
            j = i - block_size + 1;
            display([position_path, params.split_op, positionsets{iposition}, ...
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
        entitysets = unique(entitysets);
        display([position_path, params.split_op, positionsets{iposition}, ' from ', ...
            num2str(j), ' to ', num2str(j + len - 1), ' of ', num2str(len), ...
            ' treated successfully!', ' --- ', datestr(now)]);
    end
    params.file.entitysets = entitysets;
    display(['length of error file of ', num2str(len_error), ' out of ',...
        num2str(len), ' --- ', datestr(now)]);
    display([entity_path, params.split_op, data_tmp{1}{1}, '_', data_tmp{1}{2},...
        ' from ', num2str(be), ' to ', num2str(en), ' of ', num2str(len), ' in ', ...
        positionsets{iposition}, '.mat saved successfully!', ' --- ', datestr(now)]);
    diary off;
end

end

