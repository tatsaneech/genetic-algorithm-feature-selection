% % demo1
% % This demo shows the user how to perform feature selection with the GA
% % toolbox using all default parameters.


%== First, load the data
load simulated_binary.mat

%=== Open parallel processing if using
matlabpool;

%=== Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'MinimizeFeatures',false,'PlotFcn','plot_All',...
    'PopulationSize', 48,'FitnessFcn','fit_LR',...
    'Repetitions', 4,'MaxIterations',50,'Display','none');

% Run the GA
fprintf('Here we go! \n');
[ga_out, ga_options] =  AlgoGen(data,outcome,opts);

%=== Save the output
save('GA_output_1.mat','ga_out','ga_options');


%=== Close the parallel toolbox
matlabpool close;