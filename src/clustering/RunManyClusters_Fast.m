function [uShapelets, labelsResult, resultRI, totalTime] = RunManyClusters_Fast(varargin)
    
    global params;
    split_op = params.split_op;
    params.path.aligned_data = ['data', split_op, 'aligned_data'];
    test_results = ['results', split_op, 'test_results'];
    workspace = [test_results, split_op, 'workspace'];
    params.path.test_results = test_results;
    params.path.workspace = workspace;
    
    addpath('Core');
    if (isempty(varargin))
        [data, classLabels, dataFileName, sLen] = ReadData();
    else
        data = varargin{1};
        classLabels = varargin{2};
        dataFileName = varargin{3};
        sLen = varargin{4};       
    end
    backData = data;
    [data, classLabels, dataFileName, sLen, idx] = macroscopic_cluster(data, ...
        classLabels, dataFileName, sLen);

    allClassLabels = classLabels;
    minGap = 0;
    dataSize = size(data, 1);
    uShapelets = [];
    gaps = [];
    remainingInd = 1:dataSize;
    labelsResult = zeros(dataSize, 1);
    currentClusterNum = 1;
    totalTime = 0;
    
    while (length(remainingInd) > 3) % do not cluster datasets with less than 4 time series
        [bestShIndex, bestShapelets, sLen, clsNum, ~, ~, ~, algTime] = ...
            FindFastUShapelet(data, classLabels, dataFileName, sLen);
        totalTime = totalTime + algTime;
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
    
    classNumber = length(unique(labelsResult)) + length(unique(idx)) - 1;
    myLabels = zeros(length(idx), 1);
    myLabels(idx == 1) = labelsResult;
    myLabels(idx == 0) = classNumber;
    
    statsFile = [dataFileName '_' int2str(sLen) '_stats.txt'];
    fileID = fopen(statsFile, 'a');
    fprintf(fileID, '----------------------------------------\n');
    fprintf(fileID, ['Rand Index: ' num2str(resultRI) '\n']);
    fprintf(fileID, '----------------------------------------\n');
    fclose(fileID);
    [~, fileName, ~] = fileparts(dataFileName);
    save([workspace, split_op, fileName, '_Many_', int2str(sLen)]);
    close all;