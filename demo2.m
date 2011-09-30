% demo2
% This demo shows the user how to perform feature selection with the GA
% toolbox using all default parameters.

% First, load the data
%loaddata;
% matlabpool 4;

% Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,'MutationRate',0.20,...
    'PopulationSize', 100,'FitnessFcn','fit_LR','MaxFeatures',20,...
    'MinFeatures',1,'Repetitions', 1,'MaxIterations',100,'Display','plot');

% Run the GA
 [ga_out, ga_options] =  AlgoGen(data,outcome,opts);
% save('aoife100repetitions_96pop20feat.mat','ga_out','ga_options');
% matlabpool close;