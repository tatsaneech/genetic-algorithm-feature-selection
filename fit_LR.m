function [ train_pred, test_pred ] = ...
    fit_LR(train_data,train_target,test_data,test_target)

train_target(train_target==0)=-1;
test_target(test_target==0)=-1;

b2 = robustfit(full(train_data),train_target,[],[],'off');

train_pred = train_data*b2;
test_pred = test_data*b2 ;

% convert to logistic regression
train_pred = 1./(1+exp(-train_data*b2));
test_pred = 1./(1+exp(- test_data*b2));

end
  
    

    

            






