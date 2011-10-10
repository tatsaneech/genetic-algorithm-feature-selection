function [ SCORE_test SCORE_train ] = evaluate_par( labData , labOut , parents, options )

fitFcn=options.FitnessFcn;
costFcn=options.CostFcn;
xvalFcn=options.CrossValidationFcn;
optDir=options.OptDir;

% Pre-allocate
P=size(parents,1);

% Calculate indices from crossvalidation
% Determine cross validation indices
% TODO: Add N (num observations) to options earlier to speed up code
[ train, test, KI ] = feval(xvalFcn,labOut{1},options);

spmd % spmd by default uses as many workers as are in the pool
    warning off all % Remove warnings
    
    % Distribute parents across labs by rows
    labParents=codistributed(parents==1, codistributor1d(1));
    
    % Initialize scores as codistributed arrays
    %TODO: Figure out a better upper limit than 9999
    SCORE_train=(optDir*9999)*ones(P,KI,'double',codistributor('1d',1));
    SCORE_test=(optDir*9999)*ones(P,KI,'double',codistributor('1d',1));
    
    % For each parent genome on the lab
    for individual=drange(1:size(labParents,1))
        % If enough variables selected to regress
        if sum(labParents(individual,:))>0
            % repeat until the mean of the AUC is significant
            for ki=1:KI
                %TODO: Use arrayfun and a wrapper to vectorize this
                train_data = labData(train(:,ki),labParents(individual,:));
                train_target = labOut(train(:,ki));
                test_data = labData(test(:,ki),labParents(individual,:));
                test_target = labOut(test(:,ki));
                
                % Use fitness function to calculate costs
                [ train_pred, test_pred ]  = feval(fitFcn,...
                    train_data,train_target,test_data,test_target);
                
                [ SCORE_train(individual,ki) ] = feval(costFcn,...
                    train_pred, train_target);
                [ SCORE_test(individual,ki) ] = feval(costFcn,...
                    test_pred, test_target);
            end
        else
            % Use pre-allocated "bad" costs when no features selected
        end
    end
    
end

% Extract SCOREs from codistributed arrays
SCORE_train=gather(SCORE_train);
SCORE_test=gather(SCORE_test);

% ...and get median results on TEST and TRAIN set
SCORE_train =  nanmedian(SCORE_train,2);
SCORE_test =  nanmedian(SCORE_test,2);

end
