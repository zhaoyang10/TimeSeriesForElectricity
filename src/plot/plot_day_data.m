loadPath = 'E:\datasets\projects\hangzhoujiahe\test\stage_5_day_split\';
savePath = 'E:\工作\聚类工程\家和聚类数据\output\test v1.0\8-hours-later\hour-split\';
% datasets = {'681', '851', '877', '895', '793', '1074', '749', '927', '948', ...
%     '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};
datasets = { '851', '877', '895', '793', '1074', '749', '927', '948', ...
    '00-00-00-00-00-00-00-02-00-00-30-64-00-01-C3'};

xlabel = [0 : 86399];
for iData = 1 : length(datasets)
    figure(iData);
    dataName = [datasets{iData}, '_day_split.mat'];
    load([loadPath, dataName]);
    node_name = dayData.nodename;
    node_id = dayData.nodeid;
    if ~exist([savePath, node_id], 'dir')
        mkdir([savePath, node_id]);
    end
    sensorfilename = dayData.sensorfilename;
    for iSensor = 1 : length(sensorfilename)
        if ~exist([savePath, node_id, '/', sensorfilename{iSensor}], 'dir')
            mkdir([savePath, node_id, '/', sensorfilename{iSensor}]);
        end
    end
    days = length(dayData.samplesOfOneDay);
    
    for iDay = 11 : 50
        %       subplot(xPlotSize, yPlotSize, iDay);
        second = dayData.samplesOfOneDay{iDay, 1}.hour * 3600 + ...
            dayData.samplesOfOneDay{iDay, 1}.minite * 60 + ...
            dayData.samplesOfOneDay{iDay, 1}.second;
        for iSensor = 1 : length(sensorfilename)
            figure(iSensor);
            plot(second, dayData.samplesOfOneDay{iDay, 1}.data(:,iSensor)');
            xlim([0 86399]);
            title([datasets{iData},'\_',sensorfilename{iSensor}]);
            set(gca,'XTick',[0:3600:86399]);
            set(gca,'XTickLabel',[0:3600:86399]./3600);
            tmpSavePath = [savePath, node_id, '/', sensorfilename{iSensor}, '/'];
            saveas(iSensor, [tmpSavePath, num2str(iDay)], 'pdf');
            saveas(iSensor, [tmpSavePath, num2str(iDay)], 'fig');
        end
    end
end