function [ SCORE_test, SCORE_train, other ] = ...
    evaluate(OriginalData, data_target, parents, options, train, test, KI)

fitFcn=options.FitnessFcn;
fitOpt=options.FitnessParam;
costFcn=options.CostFcn;
optDir = options.OptDir;
normalizeDataFlag = options.NormalizeData;

% Pre-allocate
P=size(parents,1);
SCORE_test=zeros(P,1);
SCORE_train=zeros(P,1);


%=== Default cost values to very sub-optimal
% If the algorithm does not assign a cost value (due to missing values or
% unselected features), the genome will be heavily penalized

%TODO: Figure out a better limits than 9999 and -9999
if optDir % Maximizing cost -> low default value
    defaultCost=-9999;
else % Minimizing cost -> high default value
    defaultCost=9999;
end

%=== the genomes at the end will be indexing hyperparameters
if ~isempty(options.Hyperparameters)
    hyper = parents(:,size(OriginalData,2)+1:end);
    parents = parents(:,1:size(OriginalData,2));
end


% For each individual
for individual=1:P
    % If you want to remove multiples warnings
    warning off all
    tr_cost=ones(KI,1)*defaultCost;
    t_cost=ones(KI,1)*defaultCost;
    
    % Convert Gene into selected variables
    FS = parents(individual,:)==1;
    
    if ~isempty(options.Hyperparameters)
        fitOpt = parseHyperparameters(fitOpt,fitFcn,hyper(individual,:),options);
    end
    
    % If enough variables selected to regress
    if any(FS)
        DATA = full(OriginalData(:,FS));
        % Cross-validation repeat for each data partition
        for ki=1:KI
            train_target = data_target(train(:,ki));
            test_target = data_target(test(:,ki));
            
            if normalizeDataFlag
                [train_data, test_data] = ...
                    normalizeData(DATA(train(:,ki),:),DATA(test(:,ki),:));
            else
                train_data = DATA(train(:,ki),:);
                test_data = DATA(test(:,ki),:);
            end
            
            % Use fitness function to train model/get predictions
            [ train_pred, test_pred, model ]  = feval(fitFcn,...
                train_data,train_target,test_data, fitOpt);
            
            [ tr_cost(ki) ] = callStatFcn(costFcn,...
                train_pred, train_target, model);
            [ t_cost(ki) ] = callStatFcn(costFcn,...
                test_pred, test_target, model);
        end
        
        % Check/perform minimal feature selection is desired
        [ tr_cost, t_cost ] = fs_opt( tr_cost, t_cost, FS, options );
        
    else
        % Do nothing - leave costs as they were preallocated
    end
    
    
    % ...get median results on TEST and TRAIN set
    SCORE_test(individual) =  nanmedian(t_cost);
    SCORE_train(individual) =  nanmedian(tr_cost);
end
other.stats = [];
other.trainPred = [];
other.testPred = [];

end

