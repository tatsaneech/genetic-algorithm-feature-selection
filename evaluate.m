function [ SCORE_test, SCORE_train, miscOutputContent ] = ...
    evaluate(OriginalData, data_target, parents, options, train, test, KI)


% miscOutputContent contains, for the BEST GENOME ONLY:
%   TestStats
%   TrainStats
%   model (only if ModelStorage==1)
%   TrainIndex
%   TestIndex

%=== Extract parameters used from options structure
fitFcn=options.FitnessFcn;
fitOpt=options.FitnessParam;
optDir = options.OptDir;
normalizeDataFlag = options.NormalizeData;
mdlStorage = options.ModelStorage;

% Pre-allocate
P=size(parents,1);
SCORE_test=zeros(P,1);
SCORE_train=zeros(P,1);

% Output parameters
TestStats = cell(P,1);
TrainStats = cell(P,1);
TrainIndex = false(size(train,1),P);
TestIndex = false(size(test,1),P);

if mdlStorage==1
model = cell(P,1);
end

if optDir % Maximizing cost -> low default value
    defaultCost=-Inf;
else % Minimizing cost -> high default value
    defaultCost=Inf;
end

if isfield(fitOpt,'lbl')
    lbl = fitOpt.lbl;
else
    lbl = [];
end

%=== Default cost values to very sub-optimal
% If the algorithm does not assign a cost value (due to missing values or
% unselected features), the genome will be heavily penalized

%=== the genomes at the end will be indexing hyperparameters
if ~isempty(options.Hyperparameters)
    hyper = parents(:,size(OriginalData,2)+1:end);
    parents = parents(:,1:size(OriginalData,2));
else
    hyper = false(size(parents,1),1);
end


% For each individual
for individual=1:P
    % If you want to remove multiples warnings
    warning off all
    
    % Convert Gene into selected variables
    FS = parents(individual,:)==1;
    
    if ~isempty(options.Hyperparameters)
        fitOpt = parseHyperparameters(fitOpt,fitFcn,hyper(individual,:),options);
    end
    
    curr_model = cell(1,KI);
    curr_train_stats = cell(1,KI);
    curr_test_stats = cell(1,KI);
    train_pred = cell(1,KI);
    test_pred = cell(1,KI);
    % If enough variables selected to regress
    if any(FS)
        DATA = full(OriginalData(:,FS));
        
        %=== update fitOpt label - needed for PSO range calculation
        if ~isempty(lbl) 
            fitOpt.lbl = lbl(FS);
        end
        
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
            [ train_pred{ki}, test_pred{ki}, curr_model{ki} ]  = feval(fitFcn,...
                train_data,train_target,test_data, fitOpt);
            
            %TODO: Probably need to replace this with GA toolbox specific code.
            curr_train_stats{ki} = stat_calc_struct(train_pred{ki},train_target);
            curr_test_stats{ki} = stat_calc_struct(test_pred{ki},test_target);
        end
        
        %=== This function will perform the following:
        %   1) Apply regularization, if requested
        %   2) Get the overall performance across K model developments
        %       This could be calculated by mean, median, etc ...
        [ tr_cost, t_cost, idxMedian ] = fs_opt( train_pred, train_target, ...
            test_pred, test_target, ...
            train, test, ...
            curr_model, FS, options, KI );
        
    else
        % leave costs as worse possible value
        t_cost = defaultCost;
        tr_cost = defaultCost;
        idxMedian = [];
    end
    
    % ...get estimate performance results calculated by fs_opt
    SCORE_test(individual) = t_cost;
    SCORE_train(individual) =  tr_cost;
    
    if any(FS)
        % ... save misc details
        TestStats{individual} = curr_test_stats{idxMedian};
        TrainStats{individual} = curr_train_stats{idxMedian};
        TrainIndex(:,individual) = train(:,idxMedian);
        TestIndex(:,individual) = test(:,idxMedian);
        if mdlStorage==1
            model{individual} = curr_model{idxMedian};
        end
    end
end
miscOutputContent.TestStats = TestStats;
miscOutputContent.TrainStats = TrainStats;
miscOutputContent.TrainIndex = TrainIndex;
miscOutputContent.TestIndex = TestIndex;
if mdlStorage==1
    miscOutputContent.model = model;
end


end

