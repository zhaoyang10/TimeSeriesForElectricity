% Initial version of the code was adopted from Zakaria et al.
% https://sites.google.com/site/icdmclusteringts/
function [dis, locations] = ComputeDistanceMatrix(shapelets, data)
n = size(data,1);
F = size(shapelets,1);
dis(1:n,1:F) = 0;
locations = zeros(n, F);
for j = 1:n
    for i = 1:F
        [locations(j, i), dis(j,i)] = findNN(data(j,:),shapelets(i,:));
    end
end