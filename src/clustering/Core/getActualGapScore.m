% Computes a u-shapelet gap score, Rand index and orderline
function [SAX_shapelets_TS, RandIndexValues, dis_raw] = getActualGapScore(data, classLabels, fileToSave, actualShapeletSize, hashingCount)    
    
    dataSize = size(data);
    dataLen = dataSize(1);
    dataWidth = dataSize(2);

    shapeletPositionsSize = dataWidth - actualShapeletSize+1;
    allShapeletsNumber = dataLen*shapeletPositionsSize;
    SAX_shapelets_TS = zeros(allShapeletsNumber, hashingCount+3);
    RandIndexValues = zeros(allShapeletsNumber, 1);
    curRow = 1;
    dis_raw = [];
    for i = 1:dataLen
        for j = 1:shapeletPositionsSize
            actualShapelet = data(i, j:j+actualShapeletSize-1);
            [maxGapActual, ~, dis_raw1] = ComputeGapRaw(actualShapelet, data);
            SAX_shapelets_TS(curRow, 1) = i;
            SAX_shapelets_TS(curRow, 2) = j;
            SAX_shapelets_TS(curRow, 3) = maxGapActual;  
            RandIndexValues(curRow) = EvaluateShapelet(dis_raw1, classLabels);
            curRow = curRow+1;            
        end
    end
%     save([fileToSave '_1.mat'], 'RandIndexValues', 'SAX_shapelets_TS', 'actualShapeletSize', 'dis_raw'); %save current workspace