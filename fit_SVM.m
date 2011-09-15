function [ t_cost, tr_cost ] = fit_SVM(DATA,data_target,costFcn)

% Randomly select training and test sets.
if nargin<3
    costFcn=@cost_RMSE;
end
   ki = 1;
   KI=100;
   IDEX = 100 ;
   tr_cost=zeros(KI,1);
   t_cost=zeros(KI,1);
   
    % repeat until the mean of the AUC is significant
    while ki<=KI
       [train valid] = crossvalind('HoldOut', data_target , .3); 

       train_data = DATA(train,:);
       train_target = data_target(train);
       valid_data = DATA(valid,:);
       valid_target = data_target(valid);

        % train the SVM using LIBSVM
        mdl = svmtrain(train_target, train_data, '-b 1');
        [train_pred, tr_acc, tr_prob] = svmpredict(train_target, train_data, mdl, '-b 1');
        [valid_pred, v_acc, v_prob] = svmpredict(valid_target, valid_data, mdl, '-b 1');
        
        if sum(round(v_prob(:,1)))==sum(valid_pred)
            train_pred=tr_prob(:,1);
            valid_pred=v_prob(:,1);
            
        else
            train_pred=tr_prob(:,2);
            valid_pred=v_prob(:,2);
        end
        t_cost(ki) = feval(costFcn, valid_pred, valid_target);
        tr_cost(ki) = feval(costFcn, train_pred, train_target);
        ki = ki+1;
        
    end
  
    

    

            






