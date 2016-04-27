function [data, classLabels, dataFileName, sLen, idx] = macroscopic_cluster(data, ...
        classLabels, dataFileName, sLen)
days = length(data);
feat = cellfun(@mean, data);
feat(:, 2) = cellfun(@std, data);
[idx, c] = kmeans(feat, 2);
plot_clustering(data, idx);
figure;
s = 10;
scatter(feat(:, 1), feat(:, 2), s, idx);

if c(1,1) < c(2, 1)
    smallCluster = 1;
    largeCluster = 2;
else
    smallCluster = 2;
    largeCluster = 1;
end

isSeperate = 0;
if c(smallCluster, 1) + 3 * c(smallCluster, 2) < c(largeCluster, 1)
    isSeperate = 1;
end

if isSeperate == 1
   data = data(idx == largeCluster);
   if ~isempty(lassLabels)
   classLabels = data(idx == largeCluster);
   end
   if length(sLen) > 1
   sLen = sLen(idx == largeCluster);
   end
   idx(idx == smallCluster) = 0;
   idx(idx == largeCluster) = 1;
else
    idx = ones(days, 1); 
end


