function [] = seperate_file_according_to_positon()
%   Seperating the whole csv file into sevaral csv files, which contains
%   information of one position (the same node id).
%
%   'position_path' - Path to save position csv file.
%
%   ************************************
%   Version : 2.0
%   Modified time : 2015-03-08
%   ************************************
% clear;
% clc;

global params;
input_file = params.file.input_file;
load_path = params.path.load_path;
save_path = params.path.save_path;
log_path = params.path.log_path;
position_path = [save_path, params.split_op, 'position'];
params.path.position_path = position_path;
if ~exist(position_path, 'dir')
    mkdir(position_path);
end

% Log file.
diary([log_path, params.split_op, 'seperate_file_according_to_position.log']);
diary on;

% Load data.
fid = fopen([load_path, params.split_op, input_file]);
data = textscan(fid, '%[^\n]');

display([load_path, params.split_op, input_file, ' loaded successfully! --- ',...
    datestr(now)]);
diary off;
diary on;

% Parse file.
% Dealing file with block. Block size is changable.
len = length(data{1});
len_error = 0;
width = 20;
block_size = 10000;
j = 1 - block_size;

positionsets = {};


% This first line is ignored, since it represents the name of the column.
be = 2; en = be + len -2;
for i = be : en
    % Get information of every time point.
    data{1}{i} = data{1}{i};
    data_tmp = textscan(data{1}{i}, '%s', 'delimiter', ',');
    
    if length(data_tmp{1}) < 2
        % Detect error of input.
        % We only met one kind of error.
        % We can change this part to deal with new input errors.
        filename = [position_path, params.split_op, 'position_error.csv'];
        fid = fopen(filename, 'a+');
        fprintf(fid, [data{1}{i}, '\n']);
        fclose(fid);
        len_error = len_error + 1;
        display(['Error string ', num2str(len_error), ' out of ', num2str(i), ...
            ' is ', data{1}{i}, ' --- ', datestr(now)]);
        diary off;
        diary on;
    else
        % Dealing with right input.
        % Use position name as file name.
        filename = [position_path, params.split_op, data_tmp{1}{1}, '.csv']; 
        positionsets{length(positionsets) + 1} = data_tmp{1}{1};
        % Write information from same position to same file.
        fid = fopen(filename, 'a+');
        fprintf(fid, [data{1}{i}, '\n']);
        fclose(fid);
    end
    
    % Report according to block. 
    if mod(i, block_size) == 0
        positionsets = unique(positionsets);
        j = i - block_size + 1;
        display([position_path, params.split_op, input_file, ' from ', ...
            num2str(j), ' to ', num2str(i) ,'dealed successfully!', ' --- ', datestr(now)]);
        display(['length of error file of ', num2str(len_error), ' out of ',...
            num2str(i), ' --- ', datestr(now)]);
        diary off;
        diary on;
    end
end
j = j + block_size;
if j ~= len
    positionsets = unique(positionsets);
    display([position_path, params.split_op, input_file, ' from ', num2str(j),...
        ' to ', num2str(len) ,' dealed successfully!', ' --- ', datestr(now)]);
end
display(['length of error file of ', num2str(len_error), ' out of ', ...
    num2str(len), ' --- ', datestr(now)]);

params.file.positionsets = positionsets;
display([position_path, params.split_op, 'seperate_file_according_to_position.mat saved successfully!',...
    ' --- ', datestr(now)]);
diary off;
end



