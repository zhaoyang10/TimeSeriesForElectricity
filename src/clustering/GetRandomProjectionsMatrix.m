% Random masking function
function [tsPerS, tElapsed] = GetRandomProjectionsMatrix(data, sLen, sNum)
    dimensionality = 16;
    cardinality = 4;

    [shapeletsHash, shapeletsStorage] = GetSaxHash(data, cardinality, sLen, dimensionality);
   
    R = 10; %10
    maskedNum = 3;
    masks = zeros(R, maskedNum);
    A = data(:, 1);
    x = unique(A);
    tsNumber = numel(x);
    tsLengths = zeros(tsNumber,1);
    for k = 1:tsNumber
      tsLengths(k) = sum(A==x(k));
    end
    
    shapelets = shapeletsHash.keys;
    shapelets = cell2mat(shapelets);
    shValues = shapeletsHash.values;
    shStorageValues = shapeletsStorage.values;
    shStorageVals = cellfun(@length, shStorageValues);
    shHashNum = cellfun(@length, shValues);

    shCount = length(shapelets);
    tsPerS = ones(sNum, 1);
    vals = zeros(sNum, 1);
    firstInd = 1;
    for i = 1:shCount
        vals(firstInd:firstInd + shStorageVals(i) - 1) = shHashNum(i);
        firstInd = firstInd + shStorageVals(i);
    end
    tsPerS(cell2mat(shStorageValues)) = vals;
    tsPerS = repmat(tsPerS, 1, R);
    tic;
    for i = 1:R %get 10 random projections   
        maskedPlaces = sort(random('unid', dimensionality, 1, maskedNum));   
        while(~isempty(find(ismember(masks,maskedPlaces,'rows'), 1)) || length(find(diff(maskedPlaces))) < maskedNum - 1)
            maskedPlaces = sort(random('unid', dimensionality, 1, maskedNum)); 
        end
        masks(i, :) = maskedPlaces;               
        newKeys = shapelets;
        for j = 1:maskedNum
            wCard = maskedPlaces(j);
            newKeys = uint64(double(idivide(newKeys, uint64(10^wCard)))*(10^wCard) ...
                + mod(double(newKeys), 10^(wCard-1)));
        end
        x = unique(newKeys);
        N = numel(x);
        count = zeros(N,1);
        for k = 1:N
          count(k) = sum(newKeys==x(k));
        end
        repInd = find(count>1);
        repIndLen = numel(repInd);
        for k = 1:repIndLen
            idxs = newKeys == x(repInd(k)); %found SAX shapelets
            allTS = shValues(idxs);
            allShPositions = shStorageValues(idxs);
            tss = cell2mat(allTS);%zeros(allTSsize, 1);
            shPositions = cell2mat(allShPositions);
            uniqTSnum = numel(unique(tss));
            tsPerS(shPositions, i) = uniqTSnum;
        end
    end  
    tElapsed = toc;