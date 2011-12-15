function [ out ] = plot_All( out, parent, h, options )
%PLOT_ALL Plots all the possible graphs to the figure
%   
% This includes:
%   Variables selected across iterations
%   Mean cost evaluation across iterations
%   ROC curve
%   Current population

%  saveas(h,['AG-current_' int2str(patient_type) '.jpg'])
if ~options.GUIFlag
    set(0, 'CurrentFigure', h);
end
ite = out.CurrentIteration;
tries = out.CurrentRepetition;
set(gcf,'CurrentAxes',options.PopulationEvolutionAxe) ;
imagesc(~out.BestGenomePlot{tries}'); % Plot features selected
colormap('gray');
title([int2str(sum(out.BestGenomePlot{tries}(ite,:))) ' selected variables'],'FontSize',16);
ylabel('Variables','FontSize',16);

set(gcf,'CurrentAxes',options.FitFunctionEvolutionAxe);
plot(1:ite, out.EvolutionBestCostTest(1:ite,tries), 'b--',...
    1:ite, out.EvolutionMedianCost(1:ite,tries), 'g-');
xlabel('Generations','FontSize',16); ylabel('Mean cost','FontSize',16);
legend('Best','Median','Location','NorthWest'); %'RMSE train','AUC' ,

% TODO Get the plot function handle and plot : options.PlotFcn
set(gcf,'CurrentAxes',options.CurrentScoreAxe);
plot(out.EvolutionGenomeStats{ite,tries}.roc.x,out.EvolutionGenomeStats{ite,tries}.roc.y,'b--');

xlabel('Sensitivity'); ylabel('1-Specificity');

set(gcf,'CurrentAxes',options.CurrentPopulationAxe);
imagesc(~parent);
xlabel('Variables','FontSize',16);
ylabel('Genomes','FontSize',16);
title('Current Population','FontSize',16);
pause(0.5);

end

