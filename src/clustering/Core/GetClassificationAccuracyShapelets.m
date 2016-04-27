% Initial version of the code was adopted from Zakaria et al.
% https://sites.google.com/site/icdmclusteringts/
% Gets accuracy of classification with particular shapelets, former
function accuracy = GetClassificationAccuracyShapelets(shapelets,labels)
    n = size(shapelets,1);
    correct = 0;    
    for i = 1:n
        bsf = inf;
        minI = -1;
        for j = 1:n
            if i == j
                continue;
            end
            d = ED(shapelets(i,:),shapelets(j,:));
            if d < bsf
                bsf = d;
                minI = j;
            end
        end
        if labels(minI) == labels(i)
            correct = correct + 1;
        end
    end
    accuracy = correct/n;
end