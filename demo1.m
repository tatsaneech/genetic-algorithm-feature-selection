% % demo1
% % This demo shows the user how to perform feature selection with the GA
% % toolbox using all default parameters.


%== First, load the data
addpath('./data/');
load simulated_binary.mat

%=== Open parallel processing if using
parallelizeFlag = 0;
if (exist('matlabpool','file')==2) && parallelizeFlag
    if matlabpool('size')<=0
        matlabpool 8;
    end
else
    parallelizeFlag=0; % No MATLAB toolbox
end

%=== Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',parallelizeFlag,'CostFcn',@cost_AUROC,'OptDir',1,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'MinimizeFeatures',false,'OutputContent','debug',...
    'PopulationSize', 16,'FitnessFcn','fit_LIBSVM',...
    'PlotFcn','plot_All','Display','plot',...
    'Repetitions', 1,'MaxIterations',10);

% Run the GA
fprintf('Here we go! \n');
[ga_out, ga_options] =  AlgoGen(X,y,opts);

%=== Save the output
save('GA_DemoOutput_1.mat','ga_out','ga_options');


%=== Close the parallel toolbox
if matlabpool('size')>0
    matlabpool close;
end