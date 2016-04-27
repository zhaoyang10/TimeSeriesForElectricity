function [] = read_data_time()
% global save_path;
% global filesets;
% global sensorsets_filename;
%
global params;
% save_path = params.path.save_path;
log_path = params.path.log_path;
positionsets = params.file.positionsets;
entitysets = params.file.entitysets;
stage_3_integerate_path = params.path.stage_3_integerate_path;
stage_5_day_split_path = [params.path.save_path, params.split_op, 'stage_5_day_split'];
params.path.stage_5_day_split_path = stage_5_day_split_path;



% log_path = './results/log';
% load_path = './results/stage_3_integerate/';
% stage_3_integerate_path = './results/stage_3_integerate';
% stage_5_day_split_path = './results/stage_5_day_split';
% params.split_op = '/';
%positionsets = {'925', '920', '914', '891', '828', '749', '650', '437', ...
%    '400', '251', '124'};
% positionsets = {'925', '920', '914', '891', '828'};

% entitysets = {'2544', '2516', '2515', '2514', '2513', '2512', '2226', '2212', ...
%     '2211', '2210', '2209', '2208', '2018', '2017', '2016', '2015', '2014', ...
%     '2013', '2012', '2011', '2010', '2009', '2008', '2007', '1864', '28151', ...
%     };


if ~exist(stage_5_day_split_path)
    mkdir(stage_5_day_split_path);
end


for iposition = 1 : length(positionsets)
    data_nodeid = positionsets{iposition};
    for ientity = 1 : length(entitysets)
        data_entityid = entitysets{ientity};
        if ~exist([stage_3_integerate_path, params.split_op, data_nodeid, '_', data_entityid,...
                '_time_completed.mat'], 'file')
            continue;
        end
        
        diary([log_path, params.split_op, data_nodeid, '_', data_entityid,...
            '_read_data_time.log']);
        diary on;
        
        
        dataName = [data_nodeid, '_', data_entityid, '_time_completed.mat'];
        
        load([load_path, dataName]);
        
        num = size(node_data.time, 1);
        timeString = cell(num, 1);
        year = zeros(num, 1);
        month = zeros(num, 1);
        day = zeros(num, 1);
        hour = zeros(num, 1);
        minite = zeros(num, 1);
        second = zeros(num, 1);
        
        
        
        [year month day hour minite second] = datevec(node_data.time/86400 + datenum(1970,1,1,8,0,0));
        % [year month day hour minite second] = datevec(node_data.time/86400);
        
        dayset = unique(floor(node_data.time/86400 + datenum(1970,1,1,8,0,0)));
        % dayset = unique(floor(node_data.time/86400));
        days = length(dayset);
        
        
        
        samplesOfOneDay = cell(days, 1);
        for iDay = 1 : days
            idx = (dayset(iDay) == floor(node_data.time/86400 + datenum(1970,1,1,8,0,0)));
            %    idx = (dayset(iDay) == floor(node_data.time/86400));
            samplesOfOneDay{iDay,1}.time = node_data.time(idx);
            samplesOfOneDay{iDay,1}.data = node_data.data(idx,:);
            samplesOfOneDay{iDay,1}.year = year(idx);
            samplesOfOneDay{iDay,1}.month = month(idx);
            samplesOfOneDay{iDay,1}.day = day(idx);
            samplesOfOneDay{iDay,1}.hour = hour(idx);
            samplesOfOneDay{iDay,1}.minite = minite(idx);
            samplesOfOneDay{iDay,1}.second = second(idx);
        end
        
        dayData = struct;
        dayData.samplesOfOneDay = samplesOfOneDay;
        dayData.sensorname = node_data.sensorname;
        dayData.sensorfilename = node_data.sensorfilename;
        dayData.sensorid = node_data.sensorid;
        dayData.nodeid = node_data.nodeid;
        dayData.entityid = node_data.entityid;
        
        save([stage_5_day_split_path, params.split_op, data_nodeid, '_', ...
            data_entityid, '_day_split.mat'], 'dayData', '-v7.3');
        display(['Save ', stage_5_day_split_path, params.split_op, data_nodeid,...
            '_', data_entityid, '_day_split.mat successfully!', ...
            ' --- ', datestr(now)]);
        diary off;      diary on;
    end
end


