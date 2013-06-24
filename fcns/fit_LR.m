function [ train_pred, test_pred, model ] = ...
    fit_LR(train_data,train_target,test_data,opt)


train_target(train_target==0)=-1;

b2 = robustfit(full(train_data),train_target,opt.wfun,opt.tune,'off');

train_pred = train_data*b2;
test_pred = test_data*b2 ;

% scale using logit
train_pred = 1./(1+exp(-train_pred));
test_pred = 1./(1+exp(-test_pred));

model = b2;
end
  
    

    

            






