% Plots figures of the progress of u-shapelet discovery
function PlotFigures(data, bestShapelets, riNew, sLen, computationStop, bestShIndex, titleStr, dataFileName)
    if (strcmp(titleStr, ''))
        cs = length(riNew);
    else
        cs = computationStop;
    end
    figure;
    [bestSoFarGapScore, bestSoFarRandIndex] = getBestSoFar(bestShapelets(1:cs, :), riNew);
    plot(bestSoFarGapScore); hold on;
    plot(bestSoFarRandIndex, 'LineStyle', '--'); %hold on;
    plot([computationStop computationStop], [0 max([max(bestSoFarGapScore); max(bestSoFarRandIndex)])], 'r');
    hold off;
    legend('Gap Score', 'Rand Index', 'Algorithm Converged');
    xlabel('Number u-shapelet candidates checked');
    ylabel('Gap score or Rand Index value');
    saveas(gcf, [dataFileName '_' int2str(length(bestShapelets)) '_' ...
        int2str(sLen) '_' titleStr '_all.png'], 'png');

    figure;
    ts = bestShapelets(bestShIndex, 1);
    loc = bestShapelets(bestShIndex, 2);
    if (~(iscell(data)))
        plot(data(ts, :)); hold on;
        plot(loc:loc+sLen-1, data(ts, loc:loc+sLen-1), 'r'); hold off;
    else
        plot(data{ts}); hold on;
        plot(loc:loc+sLen-1, data{ts}(loc:loc+sLen-1), 'r'); hold off;
    end
    title(['Best u-shapelet found' titleStr]);
    saveas(gcf, [dataFileName '_' int2str(length(bestShapelets)) '_' ...
        int2str(sLen) '_' titleStr '_bestUshapelet.png'], 'png');