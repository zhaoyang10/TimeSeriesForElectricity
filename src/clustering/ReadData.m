% Reads necessary data (dataset, u-shapelet length)
function [data, classLabels, dataFileName, sLen] = ReadData()
global params;
split_op = params.split_op;
aligned_data = params.path.aligned_data;
test_results = params.path.test_results;
workspace = params.path.workspace;

dataFilePath = input('Please enter dataset file name: ', 's');
defaultDataset = false;
if(strcmp(dataFilePath, 'default'))
    dataFilePath = [aligned_data, params.split_op, 'FourClasses.txt'];
    sLen = 30;
    defaultDataset = true;
end
data = load(dataFilePath);
[~,dataFileName,~] = fileparts(dataFilePath);
if (exist(test_results, 'dir') < 7)
    mkdir(test_results);
    mkdir(workspace);
end
dataFileName = [test_results, split_op, dataFileName];
if (~defaultDataset)
    lblIncluded = false;
    labIncludAns = input('Are labels included in the dataset file? Y/N ', 's');
    if (strcmpi(labIncludAns, 'Y'))
        lblIncluded = true;
    else
        fName = input('Would you like to load labels from a different file? Input a filename or "N" to skip: ', 's');
        if (~strcmpi(fName, 'N'))
            classLabels = load(fName);
        else
            classLabels = [];
        end
    end
    if (isstruct(data))
        SNames = fieldnames(data); 
        data = data.(SNames{1});
        if (lblIncluded)
            classLabels = cellfun(@(v) v(1), data(:, 1));
            tsNum = length(data);
            for i = 1:tsNum
                data{i} = data{i}(2:end);
            end
        end
    else
        if (lblIncluded)
            classLabels = data(:,1);
            data(:,1) = [];
        end
    end
    sLen = input('Please enter the u-shapelet length (points number): ');
else
    classLabels = data(:,1);
    data(:,1) = [];
end