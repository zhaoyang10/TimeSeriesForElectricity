% Initial version of the code was adopted from Zakaria et al.
% https://sites.google.com/site/icdmclusteringts/
function [maxGap, dt, ratios] = ComputeGap(dis)
    shapeletsNumber = size(dis, 2);
    maxGap = zeros(shapeletsNumber, 1);
    dt = zeros(shapeletsNumber, 1);  
    ratios = zeros(shapeletsNumber, 1);
    for i=1:shapeletsNumber        
        disSorted = sort(dis);
        disSize = length(dis);
        startPoint = ceil(disSize * 0.167);
        endPoint = floor(disSize * 0.833);
        for j = startPoint:endPoint
            d = disSorted(j);
            [gap, ~, ~, ~, ~, ratio] = ComputeGapOne(dis(:, i), d);
            if (gap > maxGap(i))
                maxGap(i) = gap;
                dt(i) = d;
                ratios(i) = ratio;
            end
        end
    end