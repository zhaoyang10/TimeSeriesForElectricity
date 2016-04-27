function [] = init_params()

global params;

% Define paremeters.
% Define computer structure.
archstr = computer('arch');
if strcmp(archstr, 'glnxa64') || strcmp(archstr, 'glnx86')  % Linux
    params.ostype = 1;
    params.split_op = '/';
elseif strcmp(archstr, 'win32') || strcmp(archstr, 'win64')  % Windows
    params.ostype = 2;
    params.split_op = '\';
elseif strcmp(archstr, 'maci') || strcmp(archstr, 'maci64')  % Apple
    params.ostype = 3;
    params.split_op = '/';
else    % Undefined
    params.ostype = 0;
    params.split_op = '/';
end

% Input information.input_
input_file = 'historydata_org11.csv';
%input_file = 'test.csv';
params.file.input_file = input_file;

load_path = '/home/star/datasets/hangzhoujiahe/2016-03-08-data/';
tlength = length(load_path);
if load_path(tlength) == '\' || load_path(tlength) == '/'
    load_path(tlength) = [];
end
params.path.load_path = load_path;

% Creat path to save results.
save_path = ['.', params.split_op, 'results'];
if ~exist(save_path, 'dir')
    mkdir(save_path);
end
params.path.save_path = save_path;

log_path = [save_path, params.split_op, 'log'];
if ~exist(log_path, 'dir')
    mkdir(log_path);
end
params.path.log_path = log_path;

params.file.positionsets = [];
params.file.sensorsets = [];
params.file.sensorsets_filename = {'ATemperature', 'ACurrent', ...
    'BTemperature', 'BCurrent', 'CTemperature', 'CCurrent', ...
    'LeakingCurrent', 'Temperature' };




end

