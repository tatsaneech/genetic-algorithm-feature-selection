function [ tr_cost, t_cost, train_pred, test_pred ] = ...
    fit_LR(train_data,train_target,test_data,test_target,costFcn)

b2 = robustfit(train_data,train_target,[],[],'off');

test_pred = test_data*b2 ;
train_pred = train_data*b2;
t_cost = feval(costFcn, test_pred, test_target);
tr_cost = feval(costFcn, train_pred, train_target);

end
  
    

    

            






