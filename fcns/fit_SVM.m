function [ train_pred, test_pred, model  ] = ...
    fit_SVM(train_data,train_target,test_data,opt)
% FIT_SVM uses an SVM as the fitness function (wrapper)
%   Requires the Bioinformatics toolbox

%TODO: allow more options, this only really works for RBF

%=== Get function handle for the original svmtrain
org_svmtrain = opt.handle;

% train the model
model = org_svmtrain(train_data,train_target,...
    'Kernel_Function', opt.Kernel_Function,...
    'RBF_Sigma', opt.RBF_Sigma,...
    'Method', opt.Method);

% Apply to your data
[train_pred] = ...
    svmclassify(model, train_data);
[test_pred] = ...
    svmclassify(model, test_data);

end
  
    

    

            






