function [] = align_data_according_to_minute()
% global save_path;
% global filesets;
% global sensorsets_filename;
%
global params;
log_path = params.path.log_path;
positionsets = params.file.positionsets;
entitysets = params.file.entitysets;
stage_5_day_split_path = params.path.stage_5_day_split_path;
stage_6_minute_align_path = [params.path.save_path, params.split_op, 'stage_6_minute_align_path'];
params.path.stage_6_minute_align_path = stage_6_minute_align_path;

% params.thresholdTimePoints = 200;
% params.split_op = '/';
% log_path = './results/log';
% stage_5_day_split_path = './results/stage_5_day_split';
% stage_6_minite_align_path = './results/stage_6_minite_align';
% params.split_op = '/';
%positionsets = {'925', '920', '914', '891', '828', '749', '650', '437', ...
%    '400', '251', '124'};
% positionsets = {'925', '920', '914', '891', '828'};
%
% entitysets = {'2544', '2516', '2515', '2514', '2513', '2512', '2226', '2212', ...
%     '2211', '2210', '2209', '2208', '2018', '2017', '2016', '2015', '2014', ...
%     '2013', '2012', '2011', '2010', '2009', '2008', '2007', '1864', '28151', ...
%     };
%

if ~exist(stage_6_minute_align_path, 'dir')
    mkdir(stage_6_minute_align_path);
end

xi = [0 : 60 : 86340];

for iposition = 1 : length(positionsets)
    data_nodeid = positionsets{iposition};
    for ientity = 1 : length(entitysets)
        data_entityid = entitysets{ientity};
        if ~exist([stage_5_day_split_path, params.split_op, data_nodeid, '_', data_entityid,...
                '_day_split.mat'], 'file')
            continue;
        end
        
        diary([log_path, params.split_op, data_nodeid, '_', data_entityid,...
            '_minute_align.log']);
        diary on;
        load([stage_5_day_split_path, params.split_op, data_nodeid, '_', data_entityid,...
            '_day_split.mat']);
        
        class miniteData;
        miniteData.sensorname = dayData.sensorname;
        miniteData.sensorfilename = dayData.sensorfilename;
        miniteData.sensorid = dayData.sensorid;
        miniteData.nodeid = dayData.nodeid;
        miniteData.entityid = dayData.entityid;
        
        
        sensorNum = length(dayData.sensorname);
        days = length(dayData.samplesOfOneDay);
        miniteData.samplesOfOneDay = cell(days, 1);
        originalDays = days;
        
        iDay = 1;
        while iDay <= days
            timePoints = length(dayData.samplesOfOneDay{iDay}.time);
            if timePoints < params.thresholdTimePoints
                dayData.samplesOfOneDay(iDay) = [];
                days = days - 1;
                continue;
            end
            clear miniteData.samplesOfOneDay{iDay}.data;
            clear miniteData.samplesOfOneDay{iDay}.time;
            miniteData.samplesOfOneDay{iDay}.second = cell(sensorNum, 1);
            miniteData.samplesOfOneDay{iDay}.data = cell(sensorNum, 1);
            time = dayData.samplesOfOneDay{iDay, 1}.time;
            time = time + datenum(1970,1,1,8,0,0) * 86400 - ...
                floor(time/86400 + datenum(1970,1,1,8,0,0)) * 86400;
            for iSensor = 1 : sensorNum
                miniteData.samplesOfOneDay{iDay}.second{iSensor} = xi;
                miniteData.samplesOfOneDay{iDay}.data{iSensor} = interp1(time, dayData.samplesOfOneDay{iDay,1}.data(:,iSensor), ...
                    xi, 'linear');
                miniteData.samplesOfOneDay{iDay}.second{iSensor}(isnan(miniteData.samplesOfOneDay{iDay}.data{iSensor})) = [];
                miniteData.samplesOfOneDay{iDay}.data{iSensor}(isnan(miniteData.samplesOfOneDay{iDay}.data{iSensor})) = [];
            end
            iDay = iDay + 1;
        end
        if originalDays > days
            miniteData.samplesOfOneDay((days+1):originalDays) = [];
        end
        
        save([stage_6_minute_align_path, params.split_op, data_nodeid, '_',...
            data_entityid, '_minute_align.mat'], 'miniteData', '-v7.3');
        display(['Save ',stage_6_minute_align_path, params.split_op, data_nodeid,...
            '_', data_entityid, '_minute_align.mat successfully!', ' --- ', datestr(now)]);
        diary off;      diary on;
    end
end
end