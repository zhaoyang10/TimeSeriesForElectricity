% Gets best so far gap score and Rand index
function [bestSoFarGapScore, bestSoFarRandIndex] = getBestSoFar(shapelets, RI)
    bestShLen = size(shapelets, 1);
    bestSoFarGapScore = zeros(bestShLen, 1);
    bestSoFarGapScore(1) = shapelets(1, 3);
    bestSoFarRandIndex = zeros(bestShLen, 1);
    bestSoFarRandIndex(1) = RI(1);
    for i=2:bestShLen
        if (shapelets(i, 3) > bestSoFarGapScore(i-1))
            bestSoFarGapScore(i) = shapelets(i, 3);
            bestSoFarRandIndex(i) = RI(i);
        else
            bestSoFarGapScore(i) = bestSoFarGapScore(i-1); 
            bestSoFarRandIndex(i) = bestSoFarRandIndex(i-1);
        end
    end

