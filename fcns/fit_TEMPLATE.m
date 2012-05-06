function [ train_pred, test_pred, model  ] = ...
    fit_TEMPLATE(train_data,train_target,test_data,opt)
% Apply the TEMPLATE model to the data
% [ train_pred, test_pred, model  ] = 
%   fit_TEMPLATE(train_data,train_target,test_data,options)
% Louis Mayaud, Oct. 4th 2011


% train your model
model = train_function(train_data,train_target, opt) ;

% Apply to your data
[train_pred] = apply_model( train_data , model );
[test_pred] = apply_model( test_data , model );


    function model  = train_function(train_data,train_target, opt)
        % train your model here
        
    end

    function prediction = apply_model( test_data , model )
        % Apply your model here
        
    end

end