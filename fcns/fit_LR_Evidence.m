function [ train_pred, test_pred , model ] = ...
    fit_LR_Evidence(train_data,train_target,test_data,opt)


[b , ~, stats] = glmfit(train_data,train_target,opt.Distribution);
train_pred = glmval(b,train_data,opt.link);
test_pred = glmval(b,test_data,opt.link);
model = struct();
model.stats = stats;
model.betas = b;

end
  
    

    

            






