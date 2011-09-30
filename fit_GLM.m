function [ tr_cost, t_cost, train_pred, test_pred  ] = fit_GLM(train_data,train_target,test_data,test_target,costFcn)

% train the multivariate linear regression using GLM
b2=glmfit(train_data,train_target,'normal','link','identity','constant','off');
train_pred=glmval(b2,train_data,'identity','constant','off');
test_pred=glmval(b2,test_data,'identity','constant','off');

tr_cost = feval(costFcn, train_pred, train_target);
t_cost = feval(costFcn, test_pred, test_target);

end