[data, classLabels, dataFileName, sLen] = ReadData();
numRestarts = 10;
RIs = zeros(numRestarts, 1);
execTimes = zeros(numRestarts, 1);
for i = 1:numRestarts
    [uShapelets, RIs(i), execTimes(i)] = RunManyClusters_Fast(data, classLabels, dataFileName, sLen);  
    disp('Time (sec):');
    disp(execTimes(i));
end