function [ English ] = convert_sensor_name( Chinese )
%   Convert from Chinese character to English character according to following rules.
%   We define 'UnknowmType' as new type.
%
% sensorsets = {'A相温度', 'A相电流', 'B相温度', 'B相电流',...
%       'C相温度', 'C相电流', '剩余电流', '环境温度' };
% sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
%       'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };

if ~isempty(strfind(Chinese, 'A')) && ~isempty(strfind(Chinese, '温')) &&...
    ~isempty(strfind(Chinese, '相')) && ~isempty(strfind(Chinese, '度'))
    English = 'ATemperature';
elseif ~isempty(strfind(Chinese, 'B')) && ~isempty(strfind(Chinese, '温')) &&...
    ~isempty(strfind(Chinese, '相')) && ~isempty(strfind(Chinese, '度'))
    English = 'BTemperature';
elseif ~isempty(strfind(Chinese, 'C')) && ~isempty(strfind(Chinese, '温')) &&...
    ~isempty(strfind(Chinese, '相')) && ~isempty(strfind(Chinese, '度'))
    English = 'CTemperature';
elseif ~isempty(strfind(Chinese, 'A')) && ~isempty(strfind(Chinese, '电')) &&...
    ~isempty(strfind(Chinese, '相')) && ~isempty(strfind(Chinese, '流'))
    English = 'ACurrent';
elseif ~isempty(strfind(Chinese, 'B')) && ~isempty(strfind(Chinese, '电')) &&...
    ~isempty(strfind(Chinese, '相')) && ~isempty(strfind(Chinese, '流'))
    English = 'BCurrent';
elseif ~isempty(strfind(Chinese, 'C')) && ~isempty(strfind(Chinese, '电')) &&...
    ~isempty(strfind(Chinese, '相')) && ~isempty(strfind(Chinese, '流'))
    English = 'CCurrent';
elseif ~isempty(strfind(Chinese, '剩')) && ~isempty(strfind(Chinese, '电')) &&...
    ~isempty(strfind(Chinese, '余')) && ~isempty(strfind(Chinese, '流'))
    English = 'LeakingCurrent';
elseif ~isempty(strfind(Chinese, '环')) && ~isempty(strfind(Chinese, '温')) &&...
    ~isempty(strfind(Chinese, '境')) && ~isempty(strfind(Chinese, '度'))
    English = 'Temperature';
else
    English = 'UnknownType';
end

