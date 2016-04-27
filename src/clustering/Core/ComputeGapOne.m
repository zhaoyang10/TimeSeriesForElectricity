% Initial version of the code was adopted from Zakaria et al.
% https://sites.google.com/site/icdmclusteringts/
function [gap, ma, mb, sa, sb, r] = ComputeGapOne(dis, d)
    ma = 0; mb = 0; sa = 0; sb = 0;
    Da = find(dis <= d);
    Db = find(dis > d);
    gap = 0;
    r = 0;
    if (length(Da)<2 || length(Db)<2)
       return;
    end
    r = length(find(Da))/length(find(Db));
    
    if ((0.2 < r) && (r < 5)) %hardcoded
        ma = mean(dis(Da));
        mb = mean(dis(Db));
        sa = std(dis(Da));
        sb = std(dis(Db));
        gap = mb - sb - (ma + sa);
    end
end