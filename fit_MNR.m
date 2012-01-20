function [ train_pred, test_pred  ] = fit_MNR(train_data,train_target,test_data,test_target)

% train the multinomial parallel regression using MNRFIT
b=mnrfit(train_data,train_target,'model','nominal');
tr_pred=mnrval(b,train_data);
t_pred=mnrval(b,test_data);

%=== Convert from NxK matrix to Nx1 matrix with 1,...,K integers
train_pred=ones(size(tr_pred,1),1);
test_pred=ones(size(t_pred,1),1);

K=size(tr_pred,2);
threshold = 1/K;
for k=2:K
    train_pred(tr_pred(:,k)>threshold,1) = k;
    test_pred(t_pred(:,k)>threshold,1) = k;
end

end