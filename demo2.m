% demo2
% This demo shows the user how to perform feature selection with the GA
% toolbox using all default parameters.

% First, load the data
% loaddata;
%matlabpool 4;
% load arrhythmia;
% disp(Description)

% Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',10,...
    'Repetitions', 50,'MaxIterations',200,'Display','none');

% Run the GA1
[ga_out1, ga_options1] =  AlgoGen(data,outcome,opts);

% Change a few options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',20,...
    'Repetitions', 50,'MaxIterations',200,'Display','none');

% Run the GA1
[ga_out2, ga_options2] =  AlgoGen(data,outcome,opts);

save('aoife50rep200it_10and20feat.mat','ga_out1','ga_options1','ga_out2','ga_options2');
matlabpool close;