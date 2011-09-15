function [ v_cost, tr_cost, stats ] = fit_LR(DATA,data_target,costFcn)

% Randomly select training and test sets.
if nargin<3
    costFcn=@cost_RMSE;
end
   ki = 1;
   KI=50;
   IDEX = 100 ;
   tr_cost=zeros(KI,1);
   v_cost=zeros(KI,1);
   train=false(size(data_target,1),KI);
   valid=false(size(data_target,1),KI);
   
    % repeat until the mean of the AUC is significant
    while ki<=KI
%        [train(:,ki) valid(:,ki)] = crossvalind('HoldOut', data_target , .3); 
        [ train(:,ki) valid(:,ki)] = myholdout( data_target, 0.3 );
       train_data = DATA(train(:,ki),:);
       train_target = data_target(train(:,ki));
       valid_data = DATA(valid(:,ki),:);
       valid_target = data_target(valid(:,ki));

        % train the multivariate linear regression
         b2 = robustfit(train_data,train_target,[],[],'off');
         
         % Louis July 6th => The following 3 lines should go to  fit_GLM
         % function
%        b2=glmfit(train_data,train_target,'binomial','link','logit','constant','off');        
%        valid_pred=glmval(b2,valid_data,'logit','constant','off');
%        train_pred=glmval(b2,train_data,'logit','constant','off');
        valid_pred = valid_data*b2 ;  
        train_pred = train_data*b2;
        v_cost(ki) = feval(costFcn, valid_pred, valid_target);
        tr_cost(ki) = feval(costFcn, train_pred, train_target);
        ki = ki+1;
        
    end
    
    if nargout>2
        [~,idx]=min(abs(v_cost-nanmedian(v_cost))); % find median
        b2 = robustfit(DATA(train(:,idx),:),data_target(train(:,idx)),[],[],'off');
        valid_data=DATA(valid(:,idx),:);
          valid_pred = valid_data*b2 ;
        stats=stat_calc_struct(valid_pred,data_target(valid(:,idx)));
    end
  
    

    

            






