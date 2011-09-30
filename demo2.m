% demo2
% This demo shows the user how to perform feature selection with the GA
% toolbox using all default parameters.

% First, load the data
%loaddata;
matlabpool;
fprintf('Aoife - 100rep, 96 pop, 20 feat\n');
% load arrhythmia;
% disp(Description)
% pmode start local 4
% mpiprofile on
% Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,'MutationRate',0.20,...
    'PopulationSize', 96,'FitnessFcn','fit_LR','NumActiveFeatures',20,...
    'Repetitions', 100,'MaxIterations',200,'Display','none');

% Run the GA1
[ga_out, ga_options] =  AlgoGen(data,outcome,opts);
save('aoife100repetitions_96pop20feat.mat','ga_out','ga_options');
matlabpool close;
% % Next, instantiate the GA options
% % A full list of options is available in the help file
% opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
%     'ErrorIterations',20,'ErrorGradient',0.005,...
%     'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',20,...
%     'Repetitions', 50,'MaxIterations',200,'Display','none');
% 
% mpiprofile viewer
% % Run the GA1
% [ga_out2, ga_options2] =  AlgoGen(data,outcome,opts);

% save('aoife50repetitions200it_twoGAs.mat','ga_out1','ga_options1','ga_out2','ga_options2');
% matlabpool close;