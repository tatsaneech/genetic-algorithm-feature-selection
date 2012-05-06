function [ SCORE_test, SCORE_train, other ] = ...
    evaluate_par(OriginalData , data_target, parents, options, train, test, KI)

fitFcn=options.FitnessFcn; 
fitOpt=options.FitnessParam;
lbl = fitOpt.lbl;
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

% For each individual
parfor individual=1:P
    % If you want to remove multiples warnings
    warning off all
    tr_cost=ones(KI,1)*defaultCost;
    t_cost=ones(KI,1)*defaultCost;
    
    % Convert Gene into selected variables
    FS = parents(individual,:)==1;
    % If enough variables selected to regress
    if sum(FS)>0
        DATA = OriginalData(:,FS);
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
            
            if ischar(fitFcn) && strcmp(fitFcn,'fit_MYPSO')
                % temporary hack
                tmpLbl = lbl(FS);
                [ train_pred, test_pred ]  = feval(fitFcn,...
                    train_data,train_target,test_data,fitOpt,tmpLbl);
            else
                % Use fitness function to train model/get predictions
                [ train_pred, test_pred ]  = feval(fitFcn,...
                    train_data,train_target,test_data,fitOpt);
            end
            
            if size(train_pred,2)>size(train_pred,1)
                train_pred = train_pred';
                test_pred = test_pred';
            end
            
            % TODO: do the next line only if nvargout>1
            [ tr_cost(ki) ] = callStatFcn(costFcn,...
                train_pred, train_target);
            [ t_cost(ki) ] = callStatFcn(costFcn,...
                test_pred, test_target);
        end
        
        % Check/perform minimal feature selection is desired
        [ tr_cost, t_cost ] = fs_opt( tr_cost, t_cost, FS, options );
    else
        % Do nothing - leave costs as they were preallocated
    end
    
    % ...get median results on TEST and TRAIN set
    SCORE_test(individual) =  nanmedian(t_cost );
    SCORE_train(individual) =  nanmedian(tr_cost );
end
other.stats = [];
other.trainPred = [];
other.testPred = [];

end

