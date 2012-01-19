function [ SCORE_test, SCORE_train, stats ] = ...
    evaluate(OriginalData, data_target, parents, options, train, test, KI )

fitFcn=options.FitnessFcn;
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

if size(parents,1)>1 % There is more than one individual to evaluate (return fitness function)
    % For each individual
    for individual=1:P
        % If you want to remove multiples warnings
        warning off all
        tr_cost=ones(KI,1)*defaultCost;
        t_cost=ones(KI,1)*defaultCost;
        
        % Convert Gene into selected variables
        FS = parents(individual,:)==1;
        % If enough variables selected to regress
        if sum(FS)>0
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
                
                % Use fitness function to calculate costs
                 [ train_pred, test_pred ]  = feval(fitFcn,...
                    train_data,train_target,test_data,test_target);
               
                %TODO: Remove this check and ensure that train_pred is
                %always output in proper format (rows = observations)
                if size(train_pred,2)>size(train_pred,1)
                    train_pred = train_pred';
                    test_pred = test_pred';
                end
                
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
        SCORE_test(individual) =  nanmedian(t_cost);
        SCORE_train(individual) =  nanmedian(tr_cost);
    end
else  % There is only one individual to estimate then, this is final validation
    %=== Create default cost values
    tr_cost=ones(KI,1)*defaultCost;
    t_cost=ones(KI,1)*defaultCost;
    
    %=== Extract features
    FS = parents(1,:) == 1;
    
    %=== Preallocate
    L1O_test_pred = zeros(KI,1); 
    if sum(FS)>0
        DATA = OriginalData(:,FS);
        for ki=1:KI
            if normalizeDataFlag
                [train_data, test_data] = ...
                    normalizeData(DATA(train(:,ki),:),DATA(test(:,ki),:));
            else
                train_data = DATA(train(:,ki),:);
                test_data = DATA(test(:,ki),:);
            end
                
            train_target = data_target(train(:,ki));
            test_target = data_target(test(:,ki));
            
            % Use fitness function to calculate costs
            [ train_pred, test_pred ]  = feval(fitFcn,...
                train_data,train_target,test_data,test_target);
            
            % TODO: do the next line only if nvargout>1
            [ tr_cost(ki) ] = callStatFcn(costFcn,...
                train_pred, train_target);
            [ t_cost(ki) ] = callStatFcn(costFcn,...
                test_pred, test_target);
            L1O_test_pred(ki) = mean(test_pred);
        end
        
        
        % Is it LeaveOne Out? ( there is only one observation in test per data split)
        if sum(sum(test,1))==size(test,2)
            % Remove observed from RMSE to get predicted
            [stats,stats.roc]=ga_stats( L1O_test_pred' , data_target ,'all');
            
        else % All other cross validation techniques
            [~,idx]=min(abs(t_cost-nanmedian(t_cost))); % find split that provides median value
            
            if normalizeDataFlag
                [train_data, test_data] = ...
                    normalizeData(DATA(train(:,idx),:),DATA(test(:,idx),:));
            else
                train_data = DATA(train(:,idx),:);
                test_data = DATA(test(:,idx),:);
            end
            
            train_target = data_target(train(:,idx));
            test_target = data_target(test(:,idx));
            
            [ train_pred, test_pred ]  = feval(fitFcn,...
                train_data,train_target,test_data,test_target);
            
            [stats,stats.roc]=ga_stats(test_pred,test_target,'all');
        end
    else
        % No features are selected, default costs used..
        stats = [];
    end
    
    % ...get median results on TEST and TRAIN set
    SCORE_test =  nanmedian(t_cost );
    SCORE_train =  nanmedian(tr_cost );
end


end

