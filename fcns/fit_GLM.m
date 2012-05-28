function [ train_pred, test_pred, b2  ] = fit_GLM(train_data,train_target,test_data,opt)



% train the multivariate linear regression using GLM
b2=glmfit(train_data,train_target,...
    opt.Distribution,'link',opt.link,...
    'constant',opt.constant,'estdisp',opt.estdisp);
train_pred=glmval(b2,train_data,opt.link,'constant',opt.constant);
test_pred=glmval(b2,test_data,opt.link,'constant',opt.constant);

end