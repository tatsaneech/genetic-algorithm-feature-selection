% % demo1
% % This demo shows the user how to perform feature selection with the GA
% % toolbox using all default parameters.


%== First, load the data
addpath([pwd '/data/']);
addpath([pwd '/fcns/']);
addpath([pwd '/stats/']);
if exist('simulated_binary.mat','file')==2
    load simulated_binary.mat
else
    X = rand(100,10); X_round = rand(1,10);
    X = double(bsxfun(@lt, X, X_round));
    y = double((X(:,1) & X(:,2)) | X(:,4));
end
%=== Open parallel processing if using
parallelizeFlag = 0;
if (exist('matlabpool','file')==2) && parallelizeFlag
    if matlabpool('size')<=0
        matlabpool 4;
    end
else
    parallelizeFlag=0; % No MATLAB toolbox
end

%=== Next, instantiate the GA options
% A full list of options is available in the help file
opts=ga_opt_set('Parallelize',parallelizeFlag,...
    'ErrorIterations',20,'ErrorGradient',0.005,...
    'MinimizeFeatures',false,'OutputContent','debug',...
    'PopulationSize', 4,'FitnessFcn','fit_LIBSVM',...
    'PlotFcn','plot_All','Display','plot',...
    'Repetitions', 1,'MaxIterations',10,...
    'Hyperparameters',{'gamma',[0.001,512],@mybin2dec, 'cost',[0.25,10],@mybin2dec});

% Run the GA
fprintf('Here we go! \n');
[ga_out, ga_options] =  AlgoGen(X,y,opts);

%=== Save the output
save('GA_DemoOutput_1.mat','ga_out','ga_options');


%=== Close the parallel toolbox
if matlabpool('size')>0
    matlabpool close;
end