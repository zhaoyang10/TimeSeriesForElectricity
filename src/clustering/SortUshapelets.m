% Input parameters:
% data                  dataset of time series;
% sLen                  u-shapelet length

% Output parameters: 
% uShapeletsOrder       order of the u-shapelet candidates where most 
%                       promising candidates appear first;
% SAX_shapelets_TS      optional info, collection of tsPerShapelet numbers;
% stds                  optional info, standard deviation of collisions
%                       number per u-shapelet
% hashingTime           time elapsed during random masking stage
function [ uShapeletsOrder, SAX_shapelets_TS, stds, hashingTime ] = SortUshapelets(data, sLen)
    [tsNumber, dataWidth] = size(data);   
    lb = max(0.1*tsNumber, 2);
    ub = tsNumber * 0.9;
    if (~iscell(data))
        sPosSize = dataWidth - sLen+1;
        sNum = tsNumber*sPosSize;
    else
        tsLengths = cellfun(@length, data) - sLen+1;
        sNum = sum(tsLengths);
    end
    zScoredUshapelets = zeros(sNum, sLen + 2);
    SAX_shapelets_TS = zeros(sNum, 3);
    curRow = 1;
    for i = 1:tsNumber
        if (iscell(data))
            sPosSize = length(data{i}) - sLen+1;
            ts = data{i};
        else
            ts = data(i, :);
        end

        for j = 1:sPosSize
            SAX_shapelets_TS(curRow, 1) = i;
            SAX_shapelets_TS(curRow, 2) = j;
            sub_section = ts(j:j+sLen-1);
            zScoredUshapelets(curRow, 1) = i;
            zScoredUshapelets(curRow, 2) = j;
            if (std(sub_section) > 0.0000001)
                zScoredUshapelets(curRow, 3:end) = (sub_section - mean(sub_section))/std(sub_section);
            end                
            curRow = curRow + 1;
        end
    end
    [uShTS, hashingTime] = GetRandomProjectionsMatrix(zScoredUshapelets, sLen, sNum);
    SAX_shapelets_TS = [SAX_shapelets_TS uShTS];
    SAX_shapelets_TS_backup = SAX_shapelets_TS;
    hashesTotal = size(SAX_shapelets_TS, 2) - 3;
    rowsToDelete = zeros(sNum, 1);
    for i = 1:sNum   
        if (length(find(SAX_shapelets_TS(i, 4:end) > ub | SAX_shapelets_TS(i, 4:end) < lb)) > hashesTotal*0.5)
            rowsToDelete(i) = 1;
        end
    end
    SAX_shapelets_TS(find(rowsToDelete), :) = [];
    stds = std(SAX_shapelets_TS(:, 4:end), 0, 2);
    [stds, uShapeletsOrder] = sort(stds);
    if (~isempty(stds))
        medianStd = stds(round(length(stds) / 2));
        smallStds = stds(stds <= medianStd);
        uShapeletsOrder(stds <= medianStd) = randperm(length(smallStds));
        SAX_shapelets_TS = SAX_shapelets_TS(uShapeletsOrder, :);
    end
    otherInd = find(rowsToDelete);
    otherInd = otherInd(randperm(length(otherInd)));
    SAX_shapelets_TS = [SAX_shapelets_TS; SAX_shapelets_TS_backup(otherInd, :)];
end