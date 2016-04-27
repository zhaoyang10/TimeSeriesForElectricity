% Computes Rand index obtained by clustering with a u-shapelet
function [RI, IDX] = EvaluateShapelet(distanceMatrix, dt, dataLabels)
    IDX = zeros(size(dataLabels));
    IDX(distanceMatrix <= dt) = 1;
    if (~isempty(dataLabels))
        RI = RandIndex(dataLabels,IDX); %% rand index using ground truth
    else
        RI = 0;
    end
end
