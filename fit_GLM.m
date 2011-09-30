function [ train_pred, test_pred  ] = fit_GLM(train_data,train_target,test_data,test_target)

% train the multivariate linear regression using GLM
b2=glmfit(train_data,train_target,'normal','link','identity','constant','off');
train_pred=glmval(b2,train_data,'identity','constant','off');
test_pred=glmval(b2,test_data,'identity','constant','off');

end