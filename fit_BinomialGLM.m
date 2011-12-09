function [ train_pred, test_pred  ] = fit_BinomialGLM(train_data,train_target,test_data,test_target)

% train the multivariate linear regression using GLM
b2=glmfit(train_data,train_target,'binomial','link','logit','constant','off');
train_pred=glmval(b2,train_data,'logit','constant','off');
test_pred=glmval(b2,test_data,'logit','constant','off');

end