function [ SCORE_test, SCORE_train, other ] = ...
    evaluate_final(OriginalData, data_target, parents, options, train, test, KI)
%EVALUATE_FINAL	Final validation of best genome
%	[ SCORE_test, SCORE_train, other ] = ...
%       evaluate_final(OriginalData, data_target, parents, options, train, test, KI)
%
%	Inputs:
%		OriginalData - NxD double matrix of data used for GA development
%		data_target  - Nx1 double vector of targets for prediction
%       parents      - PxD logical matrix of genome rows, with each element
%           indicating whether a feature is used (1) or not used (0) in
%           prediction
%       options      - A structure containing algorithm specific option
%           fields
%       train        - NxKI double matrix of indices used for each training
%           repetition of the fitness function on the data
%       test         - NxKI double matrix of indices used for each test
%           repetition of the fitness function on the data
%       KI           - The number of fitness repetitions
%
%	Outputs:
%		SCORE_test   - Median cost evaluation of genomes across KI
%           repetitions on the test data sets
%		SCORE_train  - Median cost evaluation of genomes across KI
%           repetitions on the train data sets
%		other        - Catch all structure used for additional outputs
%
%
%	See also ALGOGEN GA_OPT_SET EVALUATE EVALUATE_PAR

%	Copyright 2012 Alistair Johnson

%	$LastChangedBy$
%	$LastChangedDate$
%	$Revision$
%	Originally written on GLNXA64 by Alistair Johnson, 19-Jan-2012 13:47:41
%	Contact: alistairewj@gmail.com

[N,D] = size(OriginalData);
%=== Error check
if size(parents,1) > 1
    % Final validation should only have 1 genome
    error(sprintf('AlgoGen:%s:IncorrectNumberOfGenomes',mfilename),...
        'Incorrect number of genomes to %s, final validation requires only 1 genome.',mfilename);
elseif sum(parents,2) < 1
    % No features selected for best genome - something is wrong
    error(sprintf('AlgoGen:%s:BadGenome',mfilename),...
        'The genome input to %s does not select features - algorithm optimization is failing.',mfilename);
end

fitFcn=options.FitnessFcn;
fitOpt = options.FitnessParam;
costFcn=options.CostFcn;
optDir = options.OptDir;
normalizeDataFlag = options.NormalizeData;

%=== Default cost values to very sub-optimal
% If the algorithm does not assign a cost value (due to missing values or
% unselected features), the genome will be heavily penalized

%TODO: Figure out a better limits than 9999 and -9999
if optDir % Maximizing cost -> low default value
    defaultCost=-9999;
else % Minimizing cost -> high default value
    defaultCost=9999;
end

%=== Update hyperparameters if using hyperparameter optimization
if ~isempty(options.Hyperparameters)
    hyper = parents(1,size(OriginalData,2)+1:end);
    fitOpt = parseHyperparameters(fitOpt,fitFcn,hyper(1,:),options);
end 

%=== Extract features as logicals
FS = parents(1,1:size(OriginalData,2)) == 1;
%=== Create default cost values
tr_cost=ones(KI,1)*defaultCost;
t_cost=ones(KI,1)*defaultCost;

%=== Preallocate
L1O_test_pred = zeros(KI,1);
pred = zeros(N,KI);
model = cell(1,KI);
DATA = OriginalData(:,FS);
for ki=1:KI % Repeat fitness function KI times to get good estimate of cost
    if normalizeDataFlag
        [train_data, test_data] = ...
            normalizeData(DATA(train(:,ki),:),DATA(test(:,ki),:));
    else
        train_data = DATA(train(:,ki),:);
        test_data = DATA(test(:,ki),:);
    end
    
    train_target = data_target(train(:,ki));
    test_target = data_target(test(:,ki));
    
    % Use fitness function to train model/get predictions
    [ train_pred, test_pred, model{ki} ]  = feval(fitFcn,...
        train_data,train_target,test_data,fitOpt);
    
    [ tr_cost(ki) ] = callStatFcn(costFcn,...
        train_pred, train_target, model{ki});
    [ t_cost(ki) ] = callStatFcn(costFcn,...
        test_pred, test_target, model{ki});
    
    pred(train(:,ki),ki) = train_pred;
    pred(test(:,ki),ki) = test_pred;
    
    L1O_test_pred(ki) = mean(test_pred);
end

% find median index
[~,idx]=min(abs(t_cost-nanmedian(t_cost))); 

%=== Extract median predictions
train_pred = pred(train(:,idx),idx);
train_target = data_target(train(:,idx));
test_pred = pred(test(:,idx),idx);
test_target = data_target(test(:,idx));

[other.TrainStats,other.TrainStats.roc]=ga_stats(train_pred,train_target,'all');

% Is it LeaveOne Out? ( there is only one observation in test per data split)
if sum(sum(test,1))==size(test,2)
    % Remove observed from RMSE to get predicted
    [other.TestStats,other.TestStats.roc]=ga_stats( L1O_test_pred', data_target, 'all');
else % All other cross validation techniques
    [other.TestStats,other.TestStats.roc]=ga_stats(test_pred,test_target,'all');
end

%=== Output model and predictions
other.model = model{idx};

other.TrainIndex = train(:,idx);
other.TestIndex = test(:,idx);

% ...get median results on TEST and TRAIN set
SCORE_test =  nanmedian(t_cost );
SCORE_train =  nanmedian(tr_cost );

end