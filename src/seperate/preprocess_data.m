%   This file is the beginning script.
%   run preprocess_data.m
%
%   'filesets' - The names of input files. Cell.
%   'sensorsets' -  The names of sensors in input files. Cell.
%   'sensorsets_filename' - The names of sensors  in English for saving. Cell.
%   'save_path' - The path to save results.
%   'load_path' - The path of input file.
%   'input_file' - The name of input file. 
%   'params' -   Parameters of operating system.
%
%   ************************************
%   Version : 1.0
%   Modified time : 2015-01-18
%   ************************************

init_params;

%filesets = {'948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};
%filesets = {'927'};%{'681', '749', '793', '851', '877', '895'}%, '927'};
%sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
%    'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };
%sensorsets = {'A相温度', 'A相电流', 'B相温度', 'B相电流', 'C相温度', 'C相电流', ...
%    '剩余电流', '环境温度' };

seperate_file_according_to_positon;
seperate_file_according_to_entity;
seperate_file_according_to_sensor;
extract_data_according_to_sensor;
check_data_error;
integerate_into_time_complete;
check_time_complete_data_error;
read_data_time;
align_data_according_to_minute; 
get_single_view_data;