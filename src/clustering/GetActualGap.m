% Computes gap score, Rand Index and data labels assinged by clustering with
% u-shapelet
function [maxGapActual, ri, newIDX] = GetActualGap(sLen, bestShapelets, i, data, classLabels, clsNum)
    clsLabels = classLabels;    
    ts = bestShapelets(i, 1);
    loc = bestShapelets(i, 2);
    if (iscell(data))
        actualShapelet = data{ts}(loc:loc+sLen-1);
    else
        actualShapelet = data(ts, loc:loc+sLen-1);    
    end    
    if (isempty(find(diff(actualShapelet), 1)))
        maxGapActual = 0; ri = 0; newIDX = zeros(size(classLabels));
        return;
    end
    if (clsNum > 2)
        sClass = classLabels(ts);       
        clsLabels(clsLabels~=sClass) = sClass - 1;
    end  
    [maxGapActual, dt, dis_raw1] = ComputeGapRaw(actualShapelet, data);
    [ri, newIDX] = EvaluateShapelet(dis_raw1, dt, clsLabels);    