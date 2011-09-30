function [ SCORE_test SCORE_train stats ] = evaluate( OriginalData , data_target , parents, options )

fitFcn=options.FitnessFcn; 
costFcn=options.CostFcn;
xvalFcn=options.CrossValidationFcn;

% Pre-allocate
P=size(parents,1);
SCORE_test=zeros(P,1);
SCORE_train=zeros(P,1);

% Calculate indices from crossvalidation
% Determine cross validation indices
[ train, test, KI ] = feval(xvalFcn,data_target,options);

% For each individual
for individual=1:P
    % If you want to remove multiples warnings
    warning off all
    
    % Convert Gene into selected variables
    FS = parents(individual,:)==1;
    % If enough variables selected to regress               
    if sum(FS)>0
        DATA = OriginalData(:,FS);
        % RUN PCA if needed to avoid linear correlation between input
        % variables
        % model = pca(DATA',0.01); % 1% variance is discarded only
        % DATA = linproj(DATA',model);
        tr_cost=zeros(KI,1);
        t_cost=zeros(KI,1);
        
        % repeat until the mean of the AUC is significant
        for ki=1:KI
            %TODO: Use arrayfun and a wrapper to vectorize this
            train_data = DATA(train(:,ki),:);
            train_target = data_target(train(:,ki));
            test_data = DATA(test(:,ki),:);
            test_target = data_target(test(:,ki));
            
            % Use fitness function to calculate costs
            [ tr_cost(ki), t_cost(ki) ]  = feval(fitFcn,...
                train_data,train_target,test_data,test_target,...
                costFcn);
        end
        
        % Check/perform minimal feature selection is desired
        [ tr_cost, t_cost ] = fs_opt( tr_cost, t_cost, FS, options );
        
        % ...and get the results on TEST and TRAIN set 
        SCORE_test(individual) =  nanmedian(t_cost );
        SCORE_train(individual) =  nanmedian(tr_cost );
        
    else
        %TODO: Figure out a better upper limit than 9999
        SCORE_test(individual) = options.OptDir*9999;
        SCORE_train(individual) = options.OptDir*9999;
    end
end

if nargout>2
    % Assumes running a final validation, and t_cost has carried over from
    % single loop iteration above
    [~,idx]=min(abs(t_cost-nanmedian(t_cost))); % find median
    [ tr_cost, t_cost, train_pred, test_pred ]  = feval(fitFcn,...
                DATA(train(:,idx),:),data_target(train(:,idx)),...
                DATA(test(:,idx),:),data_target(test(:,idx)),...
                costFcn);
    [stats,stats.roc]=stat_calc_struct(test_pred,data_target(test(:,idx)));
end

