% % demo1
% % This demo shows the user how to perform feature selection with the GA
% % toolbox using all default parameters.
% loaddata;
load AlistairDATA_mv2.mat
matlabpool;
fprintf('Here we go! \n');
% % First, load the data
% load arrhythmia;
% disp(Description)

% Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'MinimizeFeatures',true,...
    'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',[],...
    'Repetitions', 4,'MaxIterations',50,'Display','none');

% Run the GA, ~8.5 hours per rep
[ga_out1, ga_options1] =  AlgoGen(data,outcome,opts);
save('GA_ALISTAIR_mv2_1.mat','ga_out1','ga_options1');
matlabpool close;
matlabpool;
% Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'MinimizeFeatures',false,...
    'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',[],...
    'Repetitions', 4,'MaxIterations',50,'Display','none');

% Run the GA, ~8 hours
[ga_out2, ga_options2] =  AlgoGen(data,outcome,opts);
save('GA_ALISTAIR_mv2_2.mat','ga_out2','ga_options2');

matlabpool close;
matlabpool;

% Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'MinimizeFeatures',false,...
    'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',8,...
    'Repetitions', 4,'MaxIterations',50,'Display','none');

% Run the GA, ~8 hours
[ga_out3, ga_options3] =  AlgoGen(data,outcome,opts);
save('GA_ALISTAIR_mv2_3.mat','ga_out3','ga_options3');


matlabpool close;
matlabpool;
% Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'MinimizeFeatures',true,...
    'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',8,...
    'Repetitions', 4,'MaxIterations',50,'Display','none');

% Run the GA, ~8.5 hours
[ga_out1b, ga_options1b] =  AlgoGen(data,outcome,opts);
save('GA_ALISTAIR_mv2_1b.mat','ga_out1b','ga_options1b');

matlabpool close;

% Can plot some interesting features