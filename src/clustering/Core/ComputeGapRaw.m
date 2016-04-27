% Initial version of the code was adopted from Zakaria et al.
% https://sites.google.com/site/icdmclusteringts/
function [maxGap, dt, dis, locations] = ComputeGapRaw(shapelets, dataset)
    [dis, locations] = ComputeDistanceMatrix(shapelets, dataset);  
    dis = real(dis);
    [maxGap, dt] = ComputeGap(dis);