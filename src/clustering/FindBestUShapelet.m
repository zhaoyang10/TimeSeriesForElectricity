% Brute force algorithm for u-shapelet discovery
function [bestShIndex, bestShapelets, sLen, clsNum] = FindBestUShapelet(data, classLabels, dataFileName, sLen)
    [~, bestShapelets, sLen, clsNum, computationStop, riNew, sNum] = ...
        FindFastUShapelet(data, classLabels, dataFileName, sLen);
    [maxGapCurrent, bestShIndex] = max(bestShapelets(:, 3));
    tic;
    % plot "Best So Far"
    for i = computationStop:sNum
        [gap, ri] = GetActualGap(sLen, bestShapelets, i, data, classLabels, clsNum);
        bestShapelets(i, 3) = gap;
        riNew(i) = ri;
        if (gap > maxGapCurrent)
            bestShIndex = i;
            maxGapCurrent = gap;        
        end
    end
    tElapsed = toc;
    statsFile = [dataFileName '_' int2str(sLen) '_stats.txt'];
    fileID = fopen(statsFile, 'a');
    fprintf(fileID, '%s', 'Gap Computing Time (the rest of the data): ');
    fprintf(fileID, '%d\n', int64(tElapsed));
    fclose(fileID);
    PlotFigures(data, bestShapelets, riNew, sLen, computationStop, bestShIndex, '', dataFileName);
    [~, fileName, ~] = fileparts(dataFileName);
%     save(['TestResults/Workspace/' fileName '_' int2str(sNum) '_' int2str(sLen)]);
    close all;