% SUSh algorithm for u-shapelet discovery
function [bestShIndex, bestShapelets, sLen, clsNum, computationStop, riNew, sNum, algTime] = ... 
            FindFastUShapelet(data, classLabels, dataFileName, sLen)
    statsFile = [dataFileName '_' int2str(sLen) '_stats.txt'];
    [ ~, bestShapelets, ~, hashingTime] = SortUshapelets(data, sLen);
        fileID = fopen(statsFile, 'a');
    fprintf(fileID, '%s', 'Hashing Time: ');
    fprintf(fileID, '%d\n', int64(hashingTime));
    fclose(fileID);
    % run gap computation
    [tsNumber, dataWidth] = size(data);
    if (~iscell(data))
        sPosSize = dataWidth - sLen+1;
        sNum = tsNumber*sPosSize;
    else
        tsLengths = cellfun('size', data, 2) - sLen+1;
        sNum = sum(tsLengths);
    end
    maxGapCurrent = 0;
    bestShIndex = 1;
    computationStop = 1;
    if (sNum > 100)
        tic;
        onePercentData = round(sNum*0.01);
        riNew = zeros(size(bestShapelets, 1), 1);
        i = 1;
        
        if (~isempty(classLabels))
            clsNum = length(unique(classLabels));
        else
            clsNum = 0;
        end
        for i = 1:onePercentData
            [gap, ri] = GetActualGap(sLen, bestShapelets, i, data, classLabels, clsNum);
            bestShapelets(i, 3) = gap;
            riNew(i) = ri;
            if (gap > maxGapCurrent)
                bestShIndex = i;
                maxGapCurrent = gap;
            end
        end
        %plot only best so far by hashing
        tElapsed = toc;
        fileID = fopen(statsFile, 'a');
        fprintf(fileID, '%s', 'Gap Computing Time (1%): ');
        fprintf(fileID, '%d\n', int64(tElapsed));
        fclose(fileID);
        computationStop = i;
        PlotFigures(data, bestShapelets, riNew, sLen, computationStop, bestShIndex, ' 1 percent', dataFileName);
        [~, fileName, ~] = fileparts(dataFileName);
%         save(['TestResults/Workspace/' fileName '_' int2str(sNum) '_' int2str(sLen)]);
        close all;
        algTime = hashingTime + tElapsed;
    end