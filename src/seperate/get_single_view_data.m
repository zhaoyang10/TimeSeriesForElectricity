function [] = get_single_view_data()


global params;
log_path = params.path.log_path;
positionsets = params.file.positionsets;
entitysets = params.file.entitysets;
split_op = params.split_op;
% stage_5_day_split_path = params.path.stage_5_day_split_path;
stage_6_minute_align_path = params.path.stage_6_minute_align_path;
stage_7_single_view_path = [params.path.save_path, params.split_op, 'stage_7_single_view_path'];
params.path.stage_7_single_view_path = stage_7_single_view_path;



% positionsets = {'925', '920', '914', '891', '828'};

% entitysets = {'2544', '2516', '2515', '2514', '2513', '2512', '2226', '2212', ...
%     '2211', '2210', '2209', '2208', '2018', '2017', '2016', '2015', '2014', ...
%     '2013', '2012', '2011', '2010', '2009', '2008', '2007', '1864', '28151', ...
%     };
% stage_6_minute_align_path = '../results/stage_6_minute_align';
% stage_7_single_view_path = '../results/stage_7_single_view_path';
% split_op = '/';

if ~exist(stage_7_single_view_path, 'dir')
    mkdir(stage_7_single_view_path);
end

for iPosition = 1 : length(positionsets)
    data_nodeid = positionsets{iPosition};
    for iEntity = 1 : length(entitysets)
        data_entityid = entitysets{iEntity};
        if ~exist([stage_6_minute_align_path, split_op, data_nodeid,...
                '_', data_entityid, '_minute_align.mat'], 'file')
            continue;
        end
        diary([log_path, split_op, data_nodeid, '_', data_entityid,...
            '_get_single_view_data.log']);
        diary on;
        load([stage_6_minute_align_path, split_op, data_nodeid,...
                '_', data_entityid, '_minute_align.mat']);
        for iSensor = 1 : length(minuteData.sensorfilename)
            days = length(minuteData.samplesOfOneDay);
            data = cell(days, 1);
            for iDay = 1 : days
                data{iDay} = minuteData.samplesOfOneDay{iDay}.data{2, :};
            end
            save([stage_7_single_view_path, split_op, data_nodeid, '_', data_entityid, '_', ...
                minuteData.sensorfilename{iSensor},'.mat'], 'data', '-v7.3');
            display(['Save ', data_nodeid, '_', data_entityid, '_', ...
                minuteData.sensorfilename{iSensor}, '.mat successfully!', ...
                ' --- ', datestr(now)]);
        diary off;      diary on;
        end
        
    end
end


