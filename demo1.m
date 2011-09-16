% demo1
% This demo shows the user how to perform feature selection with the GA
% toolbox using all default parameters.
% loaddata;
% matlabpool;
% First, load the data
% load arrhythmia;
% disp(Description)

% Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',30,...
    'Repetitions', 50,'MaxIterations',200,'Display','none');

% Run the GA
[ga_out, ga_options] =  AlgoGen(data,outcome,opts);

% matlabpool close;