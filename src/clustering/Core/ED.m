% Initial version of the code was adopted from Zakaria et al.
% https://sites.google.com/site/icdmclusteringts/
function [ D ] = ED(p,q )
    D = sqrt(sum((p-q).^2));
end
