% Input parameters:
% data                  dataset;
% shapeletSize          u-shapelet length; 
% alphabetSize          cardinality; 
% SAXshapeletLen        dimensionality

% Output parameters: 
% shapeletsHash         hash map linking SAX representation of u-shapelet 
%                       candidates and time series containing this representation;  
% shapeletsStorage      hash map linking SAX representation of u-shapelet 
%                       candidates with their location in the dataset
function [shapeletsHash, shapeletsStorage] = ... 
    GetSaxHash(data, alphabetSize, shapeletSize, SAXshapeletLen)
shapeletsHash = containers.Map('KeyType', 'uint64', 'ValueType', 'any');
shapeletsStorage = containers.Map('KeyType', 'uint64', 'ValueType', 'any');
dataSize = data(end, 1);
for i=1:dataSize
    dataInd = find(data(:, 1) == i);
    lastPrevInd = dataInd(1) - 1;
    currentTS = data(dataInd, 3:end);
    lastPointer = size(currentTS, 1); 
    [symbolic_data, pointers] = timeseries2symbol(currentTS, shapeletSize, SAXshapeletLen, alphabetSize);
    symDataSize = size(symbolic_data, 1);
    for j = 1:symDataSize
        keySAX = symbolic_data(j, :);
        key = str2double(sprintf('%d', keySAX));
        if (isKey(shapeletsHash, key))
            if (~ismember(shapeletsHash(key), i))
                shapeletsHash(key) = [shapeletsHash(key) i];                
            end
            if (j == symDataSize)
                shapeletsStorage(key) = [shapeletsStorage(key) lastPrevInd+pointers(j):lastPrevInd+lastPointer];
            else
                shapeletsStorage(key) = [shapeletsStorage(key) lastPrevInd+pointers(j):lastPrevInd+pointers(j+1) - 1]; %[i pointers(j)];
            end
        else
            shapeletsHash(key) = i;
            if (j == symDataSize)
                shapeletsStorage(key) = lastPrevInd+pointers(j):lastPrevInd+lastPointer;
            else
                shapeletsStorage(key) = lastPrevInd+pointers(j):lastPrevInd+pointers(j+1) - 1; %[i pointers(j)];
            end
        end
    end
end