dataFilePath = input('Please enter Birds dataset file name: ', 's');
data = load(dataFilePath);
labels = data(:, 1);
classItemsNum = sum(labels);
data(:, 1) = [];
sLen = 300;
dataSize = length(labels);
riUshapelets = zeros(dataSize, 1);
riKmeans = zeros(dataSize, 1);
rerunsNum = 10;
randNoiseOrder = zeros(dataSize - classItemsNum, rerunsNum);
for i = 1:rerunsNum
    randNoiseOrder(:, i) = randperm(size(randNoiseOrder, 1));
end
points = 90:5:dataSize;
for i = points 
    disp(['TS number: ' num2str(i)]);
    riU = zeros(rerunsNum, 1);
    riK = zeros(rerunsNum, 1);
    labelsSubset = labels(1:i);
    for j = 1:rerunsNum
        otherData = data(classItemsNum+1:end, :);
        dataSubset = [data(1:classItemsNum, :); otherData(randNoiseOrder(1:i-classItemsNum, j), :)];
        disp(['Run #' num2str(j)]);
        [uShapelets, resultRI, labelsResult] = CaseBirdsRunManyClustersExperiments([labelsSubset dataSubset], sLen);
        riU(j) = resultRI;
        IDX = kmeans(dataSubset, 2);
        riK(j) = RandIndex(labelsSubset, IDX);
        disp(riK(j));
    end
    riUshapelets(i) = mean(riU);
    riKmeans(i) = mean(riK);    
    disp('Result on i-th step:');
    disp(riUshapelets(i));
    disp(riKmeans(i));
end
plot(points, [riKmeans(points) riUshapelets(points)]);
xlabel('Time series number');
ylabel('Rand Index');
save('Birds10Reruns.mat');