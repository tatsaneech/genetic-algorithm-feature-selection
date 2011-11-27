function [ train_pred, test_pred  ] = ...
    fit_SVM(train_data,train_target,test_data,test_target)
% FIT_SVM uses an SVM as the fitness function (wrapper)

% train the model
model = svmtrain(train_target, train_data, '-b 1');

% Apply to your data
[train_pred, train_acc, train_prob] = ...
    svmpredict(train_target, train_data, model, '-b 1');
[test_pred, test_acc, test_prob] = ...
    svmpredict(test_target, test_data, model, '-b 1');

%=== Make sure SVM doesn't output opposite predictions
if ~isempty(train_prob)
    if min(round(train_prob(:,1))==train_pred)==1
        train_pred=train_prob(:,1);
    else
        train_pred=train_prob(:,2);
    end
end

if ~isempty(test_prob)
    if min(round(test_prob(:,1))==test_pred)==1
        test_pred=test_prob(:,1);
    else
        test_pred=test_prob(:,2);
    end
end

end
  
    

    

            






