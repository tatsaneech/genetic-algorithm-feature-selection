function [ train_pred, test_pred  ] = ...
    fit_SVM(train_data,train_target,test_data,test_target)
% FIT_SVM uses an SVM as the fitness function (wrapper)

% train the model
model = svmtrain(train_data,train_target);

% Apply to your data
[train_pred] = ...
    svmclassify(model, train_data);
[test_pred] = ...
    svmclassify(model, test_data);


end
  
    

    

            






