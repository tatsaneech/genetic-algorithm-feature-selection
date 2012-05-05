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

%=== Create default cost values
tr_cost=ones(KI,1)*defaultCost;
t_cost=ones(KI,1)*defaultCost;

%=== Extract features as logicals
FS = parents(1,:) == 1;
lbl = fitOpt.lbl(FS);
%=== Preallocate
L1O_test_pred = zeros(KI,1);
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
    
    if ischar(fitFcn) && strcmp(fitFcn,'fit_MYPSO')
        % temporary hack
        [ train_pred, test_pred ]  = feval(fitFcn,...
            train_data,train_target,test_data,fitOpt,lbl);
    else
        % Use fitness function to train model/get predictions
        [ train_pred, test_pred ]  = feval(fitFcn,...
            train_data,train_target,test_data,fitOpt);
    end
    
    [ tr_cost(ki) ] = callStatFcn(costFcn,...
        train_pred, train_target);
    [ t_cost(ki) ] = callStatFcn(costFcn,...
        test_pred, test_target);
    L1O_test_pred(ki) = mean(test_pred);
end

[~,idx]=min(abs(t_cost-nanmedian(t_cost))); % find split that provides median value

%=== Get data for stats calculations
if normalizeDataFlag
    [train_data, test_data] = ...
        normalizeData(DATA(train(:,idx),:),DATA(test(:,idx),:));
else
    train_data = DATA(train(:,idx),:);
    test_data = DATA(test(:,idx),:);
end
train_target = data_target(train(:,idx));
test_target = data_target(test(:,idx));

if ischar(fitFcn) && strcmp(fitFcn,'fit_MYPSO')
    % temporary hack
    [ train_pred, test_pred ]  = feval(fitFcn,...
        train_data,train_target,test_data,fitOpt,lbl);
else
    % Use fitness function to train model/get predictions
    [ train_pred, test_pred ]  = feval(fitFcn,...
        train_data,train_target,test_data,fitOpt);
end
[other.TrainStats,other.TrainStats.roc]=ga_stats(train_pred,train_target,'all');

% Is it LeaveOne Out? ( there is only one observation in test per data split)
if sum(sum(test,1))==size(test,2)
    % Remove observed from RMSE to get predicted
    [other.TestStats,other.TestStats.roc]=ga_stats( L1O_test_pred', data_target, 'all');
else % All other cross validation techniques
    [other.TestStats,other.TestStats.roc]=ga_stats(test_pred,test_target,'all');
end

%=== Output model, statistics
other.trainPred = train_pred;
other.testPred = test_pred;

% ...get median results on TEST and TRAIN set
SCORE_test =  nanmedian(t_cost );
SCORE_train =  nanmedian(tr_cost );

end