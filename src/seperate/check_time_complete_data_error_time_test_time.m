% clear;
% clc;
% global save_path;
% % save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% save_path = '/home/star/datasets/hangzhoujiahe/test_time/';
% diary([save_path, 'seperate_file_according_to_position.log']);
% tic;
% 
% fid = fopen('/home/star/datasets/hangzhoujiahe/new_nodeid/historydata_node_10_trans_681.csv');
% data = textscan(fid, '%[^\n]');
% 
% toc;
% len = length(data{1});
% len_error = 0;
% width = 20;
% block_size = 10000;
% j = 1 - block_size;
% 
% be = 1; en = be + len -1;
% for i = be : en
%     data{1}{i} = strcat(data{1}{i}, '\N');
%     data_tmp = textscan(data{1}{i}, '%s', 'delimiter', ',');
%     
%     
%     filename = [save_path, 'historydata_node_10_trans_test_time.csv'];
%     fid = fopen(filename, 'a+');
%     fprintf(fid, [data{1}{i}( data{1}{i} ~= '\' ), '\n']);
%     fclose(fid);
%     if mod(i, block_size) == 0
%         toc;
%         j = i - block_size + 1;
%         display([save_path, 'historydata_node_10_trans_', num2str(j), '_to_', num2str(i) ,'treated successfully!']);
%         diary off;
%         diary on;
%     end
% end

% function [] = check_data_error_test_time()
% global filesets;
% global sensorsets_filename;
% global save_path;
% load_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% save_path = '/home/star/datasets/hangzhoujiahe/test_time/';
% filesets = {'681', '948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};
%  sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
%      'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };
% diary([save_path, 'check_data_error.log']);
% tic;
% diary on;
% for ifile = 1 : length(filesets)
%     for isensor = 1 : length(sensorsets_filename)
%         if exist([load_path, 'historydata_node_10_trans_', ...
%                 filesets{ifile}, '_', sensorsets_filename{isensor}, '_sensor_parted.mat'...
%                 ], 'file')
%             load([load_path, 'historydata_node_10_trans_', filesets{ifile},...
%                 '_', sensorsets_filename{isensor}, '_sensor_parted.mat']);
%             
%             toc;
%             display(['Load historydata_node_10_trans_', filesets{ifile},...
%                 '_', sensorsets_filename{isensor}, '_sensor_parted.mat successfully!']);
%             diary off;
%             diary on;
%             
%             sensor_data = check_repeat_error(sensor_data);
%             
%             save([save_path, 'historydata_node_10_trans_', filesets{ifile},...
%                 '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat'], ...
%                 'sensor_data', '-v7.3');
%             
%             toc;
%             display(['Save historydata_node_10_trans_', filesets{ifile},...
%                 '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat successfully']);
%             diary off;
%             diary on;
%             
%             
%             checked_data = check_missingdata_error(sensor_data);
%             
%             save([save_path, 'historydata_node_10_trans_', filesets{ifile},...
%                 '_', sensorsets_filename{isensor}, '_checked_missing_data.mat'], ...
%                 'checked_data', '-v7.3');
%             
%             toc;
%             display(['Save historydata_node_10_trans_', filesets{ifile},...
%                 '_', sensorsets_filename{isensor}, '_checked_missing_data.mat successfully']);
%             diary off;
%             diary on;
%             
%         end
%     end
% end
% diary off;
% end
% 
% 
% function [sensor_data] = check_repeat_error(sensor_data)
% tic;
% [~, IA, ~] = unique(sensor_data.time);
% sensor_data.data = sensor_data.data(IA);
% sensor_data.time = sensor_data.time(IA);
% sensor_data.alarm = sensor_data.alarm(IA);
% sensor_data.reserve = sensor_data.reserve(IA);
% toc;
% len =  length(sensor_data.time);
% display(['Sort ', num2str(len), ' data successfully!']);
% 
% end
% 
% function [checked_data] = check_missingdata_error(sensor_data)
% len = length(sensor_data.time);
% time_interval = sensor_data.time(2:len);
% time_interval = time_interval - sensor_data.time(1 : (len - 1));
% time_interval_mean = mean(time_interval);
% time_interval_std = std(time_interval);
% time_interval_threshold = time_interval_mean + 3 * time_interval_std;
% time_interval_up = time_interval > time_interval_threshold;
% time_interval_idx = find(time_interval_up);
% if time_interval_idx(end) ~= length(time_interval)
%     time_interval_idx = [time_interval_idx; length(time_interval)];
% end
% 
% toc;
% display(['Find ', num2str(length(time_interval_idx)), ' time intervals successfully!']);
% diary off;
% diary on;
% 
% class checked_data;
% checked_data.number = length(time_interval_idx);
% checked_data.sensor_data = cell(checked_data.number, 1);
% checked_data.nodeid = sensor_data.nodeid;
% checked_data.sensorname = sensor_data.sensorname;
% checked_data.sensorfilename = sensor_data.sensorfilename;
% checked_data.sensorid = sensor_data.sensorid;
% checked_data.nodename = sensor_data.nodename;
% 
% begin_idx = 1;
% for idata = 1 : checked_data.number
%     end_idx = time_interval_idx(idata);
%     checked_data.sensor_data{idata}.data = sensor_data.data(begin_idx : end_idx);
%     checked_data.sensor_data{idata}.time = sensor_data.time(begin_idx : end_idx);
%     checked_data.sensor_data{idata}.alarm = sensor_data.alarm(begin_idx : end_idx);
%     checked_data.sensor_data{idata}.reserve = sensor_data.reserve(begin_idx : end_idx);
%     begin_idx = end_idx + 1;
% end
% 
% toc;
% display('Construct checked_data successfully!');
% diary off;
% diary on;
% 
% end
% function [] = integerate_into_time_complete_time_test()
% 
% global save_path;
% global filesets;
% global sensorsets_filename;
% %save_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% filesets =  {'948', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3', '1074'};
% sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
%     'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };
% load_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
% save_path = '/home/star/datasets/hangzhoujiahe/test_time/';
% diary([save_path, 'integerate_into_time_complete.log']);
% tic;
% diary on;
% for ifile = 1 : length(filesets)
%     sensor_num = 0;
%     for isensor = 1 : length(sensorsets_filename)
%         if exist([load_path, 'historydata_node_10_trans_', ...
%                 filesets{ifile}, '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat'...
%                 ], 'file')
%             sensor_num = sensor_num + 1;
%         end
%     end
%     class node_data;
%     
%     data = cell(sensor_num, 1);
%     time = cell(sensor_num, 1);
%     alarm = cell(sensor_num, 1);
%     reserve = cell(sensor_num, 1);
%     node_data.sensorname = cell(sensor_num, 1);
%     node_data.sensorfilename = cell(sensor_num, 1);
%     node_data.sensorid = cell(sensor_num, 1);
%     
%     sensor_num = 0;
%     for isensor = 1 : length(sensorsets_filename)
%         sensor_time_total = [];
%         if exist([load_path, 'historydata_node_10_trans_', filesets{ifile},...
%                 '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat'...
%                 ], 'file')
%             load([load_path, 'historydata_node_10_trans_', filesets{ifile}, ...
%                 '_', sensorsets_filename{isensor}, '_delete_repeat_data.mat']) ;
%             node_data.nodeid = sensor_data.nodeid;
%             node_data.nodename = sensor_data.nodename;
%             sensor_num = sensor_num + 1;
%             node_data.sensorname{sensor_num} = sensor_data.sensorname;
%             node_data.sensorfilename{sensor_num} = sensor_data.sensorfilename;
%             node_data.sensorid{sensor_num} = sensor_data.sensorid;
%             data{sensor_num} = sensor_data.data;
%             time{sensor_num} = sensor_data.time;
%             alarm{sensor_num} = sensor_data.alarm;
%             reserve{sensor_num} = sensor_data.reserve;
%             sensor_time_total = [sensor_time_total; time{sensor_num}];
%             sensor_time_total = unique(sensor_time_total);
%             
%             toc;
%             display(['Load historydata_node_10_trans_', filesets{ifile}, '_',...
%                 sensorsets_filename{isensor}, '_delete_repeat_data.mat successfully!']);
%             diary off;
%             diary on;
%         end
%     end
%     
%     sensor_time_sorted = sort(sensor_time_total);
%     len_sensor_time = length(sensor_time_sorted);
%     node_data.alarm = zeros(len_sensor_time, 1);
%     node_data.time = zeros(len_sensor_time, 1);
%     node_data.data = zeros(len_sensor_time, sensor_num);
%     node_data.reserve = zeros(len_sensor_time, sensor_num);
%     
%     now_idx = ones(sensor_num, 1);
%     total_idx = 0;
%     for i = 1 : len_sensor_time
%         find = 0;
%         for j = 1 : sensor_num
%             while (time{j}(now_idx(j)) < sensor_time_sorted(i)) && (now_idx(j) < length(time{j}))
%                 now_idx(j) = now_idx(j) + 1;
%             end
%             if time{j}(now_idx(j)) == sensor_time_sorted(i)
%                 find = find + 1;
%             end
%         end
%         
%         if find == sensor_num
%             total_idx = total_idx + 1;
%             sensor_alarm_temp = 0;
%             for j = 1 : sensor_num
%                 node_data.data(total_idx, j) = data{j}(now_idx(j));
%                 node_data.reserve(total_idx, j) = reserve{j}(now_idx(j));
%                 if alarm{j}(now_idx(j))
%                     sensor_alarm_temp = 1;
%                 end
%             end
%             node_data.alarm(total_idx) = sensor_alarm_temp;
%             node_data.time(total_idx) = sensor_time_sorted(i);
%         end
%         
%         if mod(i, 100000) == 0
%            toc;
%            display(['Construct ', num2str(i), ' of ', num2str(len_sensor_time), ...
%                ' time complete data.']);
%            diary off;
%            diary on;
%         end
%     end
%     
%     node_data.data = node_data.data(1:total_idx, :);
%     node_data.reserve = node_data.reserve(1:total_idx, :);
%     node_data.alarm = node_data.alarm(1:total_idx, :);
%     node_data.time = node_data.time(1:total_idx, :);
%     
%     
%     toc;
%     display(['Finish constructing ', num2str(total_idx), ' time points time complete data!']);
%     diary off;
%     diary on;
%     
%     save([save_path, 'historydata_node_10_trans_', filesets{ifile}, '_time_completed.mat'], ...
%         'node_data', '-v7.3');
% end
% 
% 
% diary off;
% end
% 

function [] = check_time_complete_data_error_time_test_time()
global save_path;
global filesets;
global sensorsets_filename;
load_path = '/home/star/datasets/hangzhoujiahe/new_nodeid/';
save_path = '/home/star/datasets/hangzhoujiahe/test_time/';
filesets = {'948', '1074', '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};
sensorsets_filename = {'ATemperature', 'ACurrent', 'BTemperature', 'BCurrent', ...
    'CTemperature', 'CCurrent', 'LeakingCurrent', 'Temperature' };
diary([save_path, 'check_data_error.log']);
tic;
diary on;
for ifile = 1 : length(filesets)
    load([load_path, 'historydata_node_10_trans_', filesets{ifile}, '_time_completed.mat']);
    
    toc;
    display(['Load historydata_node_10_trans_', filesets{ifile}, '_time_completed.mat successfully!']);
    diary off;
    diary on;
    
    
    checked_node_data = check_time_complete_missingdata_error(node_data);
    
    save([save_path, 'historydata_node_10_trans_', filesets{ifile}, ...
        '_checked_time_completed.mat'], 'checked_node_data', '-v7.3');
    toc;
    display([save_path, 'historydata_node_10_trans_', filesets{ifile}, ...
        '_checked_time_completed.mat saved successfully!']);
    diary off;
    diary on;
    
end
diary off;
end


function [checked_node_data] = check_time_complete_missingdata_error(node_data)
len = length(node_data.time);
time_interval = node_data.time(2:len);
time_interval = time_interval - node_data.time(1 : (len - 1));
time_interval_mean = mean(time_interval);
time_interval_std = std(time_interval);
time_interval_threshold = time_interval_mean + 3 * time_interval_std;
time_interval_up = time_interval > time_interval_threshold;
time_interval_idx = find(time_interval_up);
if time_interval_idx(end) ~= length(time_interval)
    time_interval_idx = [time_interval_idx; length(time_interval)];
end

toc;
display(['Find ', num2str(length(time_interval_idx)), ' time intervals successfully!']);
diary off;
diary on;

class checked_node_data;
checked_node_data.number = length(time_interval_idx);
checked_node_data.node_data = cell(checked_node_data.number, 1);
checked_node_data.nodeid = node_data.nodeid;
checked_node_data.sensorname = node_data.sensorname;
checked_node_data.sensorfilename = node_data.sensorfilename;
checked_node_data.sensorid = node_data.sensorid;
checked_node_data.nodename = node_data.nodename;

begin_idx = 1;
for idata = 1 : checked_node_data.number
    end_idx = time_interval_idx(idata);
    checked_node_data.node_data{idata}.data = node_data.data(begin_idx : end_idx, :);
    checked_node_data.node_data{idata}.time = node_data.time(begin_idx : end_idx);
    checked_node_data.node_data{idata}.alarm = node_data.alarm(begin_idx : end_idx);
    checked_node_data.node_data{idata}.reserve = node_data.reserve(begin_idx : end_idx, :);
    begin_idx = end_idx + 1;
end

toc;
display('Construct checked_data successfully!');
diary off;
diary on;

end


