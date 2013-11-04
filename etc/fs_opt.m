function [ tr_cost, t_cost, idxMedian ] = fs_opt(train_pred, train_target, ...
            test_pred, test_target, ...
            idxTrain, idxTest, ...
            curr_model, FS, options, KI )
%FS_OPT Alters algorithm costs to minimize features selected.


costFcn=options.CostFcn;
optDir = options.OptDir;

%TODO: Figure out a better limits than 9999 and -9999
if optDir % Maximizing cost -> low default value
    defaultCost=-Inf;
else % Minimizing cost -> high default value
    defaultCost=Inf;
end


%=== Now depending on the xval type, calculate the median cost
switch options.CrossValidationFcn
    case 'TODO' % Incomplete because unsure what model to save for final results..
%     case {'xval_Kfold', 'xval_KfoldD'}
        holdout_pred = nan(size(test_target,1),1);
        tr_cost=ones(KI,1)*defaultCost;
        for ki=1:KI
            holdout_pred(idxTest(:,ki),1) = test_pred{ki};
            
            [ tr_cost(ki) ] = callStatFcn(costFcn,...
                train_pred{ki}, train_target, curr_model{ki});
        end
        [tr_cost,idxModel] = mean(tr_cost);
        
        %FIXME: Use of idxModel here is probably inappropriate
        t_cost = callStatFcn(costFcn,...
            holdout_pred, test_target, curr_model{idxModel});
        
        
    otherwise
        tr_cost=ones(KI,1)*defaultCost;
        t_cost=ones(KI,1)*defaultCost;
        for ki=1:KI
            [ tr_cost(ki) ] = callStatFcn(costFcn,...
                train_pred{ki}, train_target, curr_model{ki});
            [ t_cost(ki) ] = callStatFcn(costFcn,...
                test_pred{ki}, test_target, curr_model{ki});
        end
        
        % ...get median results on TEST set
        t_cost_median =  nanmedian(t_cost);
        idxMedian = find(t_cost==t_cost_median,1);
        t_cost = t_cost_median;
        
        % ...save corresponding result from training set
        tr_cost =  tr_cost(idxMedian);
end


% Check if regularization is required
if options.MinimizeFeatures==true
if isa(options.CostFcn,'function_handle')
    costFcn = func2str(options.CostFcn);
else
    costFcn = options.CostFcn;
end

%=== If PSO model, have to modify the number of free parameters ...
if isa(options.FitnessFcn,'function_handle')
    FitnessFcn = func2str(options.FitnessFcn);
else
    FitnessFcn = options.FitnessFcn;
end
%=== Choose AIC depending on cost function
if strcmp(costFcn,'stats_LL')
    if strcmp(FitnessFcn,'fit_MYPSO');
        k=2*5;
    else
        k=2;
    end
    
    %=== Do LL version of AIC
    tr_cost = k*sum(FS) + 2*tr_cost;
    t_cost = k*sum(FS) + 2*t_cost;
else
    %=== Parametric version of AIC
    
    L=sum(FS); % the "level" - penalty for num of features
    
    % define threshold and margin - I hate parametric methods
    t=0.85;
    m=1;
    
    % transform costs
    tr_p=(exp((tr_cost-t)/m)-1) / (exp(1)-1);
    t_p=(exp((t_cost-t)/m)-1) / (exp(1)-1);
    if options.OptDir==0
        tr_cost=L+tr_p;
        t_cost=L+t_p;
    else
        tr_cost=-L-tr_p;
        t_cost=-L-t_p;
    end
end
end

end

