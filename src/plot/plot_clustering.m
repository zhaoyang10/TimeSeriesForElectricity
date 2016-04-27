function [] = plot_clustering( data, index )

 clusterNum = length(unique(index));
 for iCluster = 1 : clusterNum
    figure(iCluster);
    title(['Clustering ', num2str(iCluster)]);
    plotIndex = find(index == iCluster);
    plotNum = min(100, length(plotIndex));
    for iPlot = 1 : plotNum
       subplot(10, 10, iPlot);
       plot(data{plotIndex(iPlot)});
    end
 end
end

