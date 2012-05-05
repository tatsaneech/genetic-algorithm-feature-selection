function [ opt ] = optfit_GLM
% Generates a default structure for the fitness function fit_GLM
%   [ opt  ] = optfit_GLM 

opt=struct('Distribution', 'normal', ...
        'link', 'identity', ...
        'constant', 'off',...
        'estdisp', 'off');
    
% train the multivariate linear regression using GLM
b2=glmfit(train_data,train_target,'normal','link','identity','constant','off');
train_pred=glmval(b2,train_data,'identity','constant','off');
test_pred=glmval(b2,test_data,'identity','constant','off');

end