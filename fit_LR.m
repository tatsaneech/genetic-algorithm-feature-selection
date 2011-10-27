function [ train_pred, test_pred ] = ...
    fit_LR(train_data,train_target,test_data,test_target)

b2 = robustfit(train_data,train_target,[],[],'off');

train_pred = train_data*b2;
test_pred = test_data*b2 ;

end
  
    

    

            






