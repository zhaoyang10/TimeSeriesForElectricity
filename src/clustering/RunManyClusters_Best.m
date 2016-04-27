function [uShapelets, labelsResult, resultRI] = RunManyClusters_Best()
    addpath('Core');
    [data, classLabels, dataFileName, sLen] = ReadData();
    allClassLabels = classLabels;
    minGap = 0;
    dataSize = size(data, 1);
    uShapelets = [];
    gaps = [];
    remainingInd = 1:dataSize;
    labelsResult = zeros(dataSize, 1);
    currentClusterNum = 1;
    while (length(remainingInd) > 3) % do not cluster datasets with less than 4 time series
        [bestShIndex, bestShapelets, sLen, clsNum] = ...
            FindBestUShapelet(data, classLabels, dataFileName, sLen);
        maxGapCurrent = bestShapelets(bestShIndex, 3);
        [~, ~, newIDX] = GetActualGap(sLen, bestShapelets, bestShIndex, data, classLabels, clsNum);
        ts = remainingInd(bestShapelets(bestShIndex, 1));
        loc = bestShapelets(bestShIndex, 2);  
        bsfUsh = [ts loc sLen maxGapCurrent];
        bsfCurrentIDX = newIDX;
        gaps = [gaps; maxGapCurrent];
        if (minGap == 0)
            if (maxGapCurrent > 0)
                minGap = maxGapCurrent;
            else
                break;
            end
        else
            if (minGap / 2 > maxGapCurrent)
                break;
            end
        end
        indToDelete = find(bsfCurrentIDX);
        if (~(iscell(data)))
            data(indToDelete, :) = [];
        else
            data(indToDelete) = [];       
        end
        uShapelets = [uShapelets; bsfUsh];    
        if (~isempty(classLabels))
            classLabels(indToDelete) = [];
        end
        labelsResult(remainingInd(indToDelete)) = currentClusterNum;
        remainingInd(indToDelete) = [];
        currentClusterNum = currentClusterNum + 1;
    end
    if (~isempty(classLabels)) 
        resultRI = RandIndex(allClassLabels,labelsResult);
        disp('Resulting Rand Index:');
        disp(resultRI);
    else
        resultRI = 0;
        disp('No class labels provided, so no Rand Index computed.');
    end    
    statsFile = [dataFileName '_' int2str(sLen) '_stats.txt'];
    fileID = fopen(statsFile, 'a');
    fprintf(fileID, '----------------------------------------');
    fclose(fileID);
    [~, fileName, ~] = fileparts(dataFileName);
    save(['TestResults/Workspace/' fileName '_Many_' int2str(sLen)]);
    close all;