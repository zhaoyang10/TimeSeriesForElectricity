% Initial version of the code was adopted from Zakaria et al.
% https://sites.google.com/site/icdmclusteringts/
% Gets Manhattan distance
function [ D ] = ManhattanDistance(p,q)
    D = (sum(abs(p-q)));
end
