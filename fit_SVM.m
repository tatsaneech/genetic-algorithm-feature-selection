function [ train_pred, test_pred  ] = ...
    fit_SVM(train_data,train_target,test_data,test_target)
% FIT_SVM uses an SVM as the fitness function (wrapper)
%   Requires the Bioinformatics toolbox

%=== Create a function handle for the original svmtrain
org_svmtrain = str2func([matlabroot '/toolbox/bioinfo/biolearning/svmtrain']);

% train the model
model = org_svmtrain(train_data,train_target,...
    'Kernel_Function', 'rbf',...
    'RBF_Sigma', 1,...
    'Method', 'SMO');

% Apply to your data
[train_pred] = ...
    svmclassify(model, train_data);
[test_pred] = ...
    svmclassify(model, test_data);

end
  
    

    

            






