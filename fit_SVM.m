function [ train_pred, test_pred  ] = ...
    fit_TEMPLATE(train_data,train_target,test_data,test_target)
% Apply the TEMPLATE model to the data
% [ train_pred, test_pred  ] = 
%   fit_TEMPLATE(train_data,train_target,test_data,test_target)
% Louis Mayaud, Oct. 4th 2011


% train your model
model = train_funtion(train_data,train_target) ;

% Apply to your data
[train_pred] = apply_model( train_data , model );
[test_pred] = apply_model( test_data , model );


    function model  = train_funtion(train_data,train_target)
        % train your model here
        
    end

    function prediction = apply_model( test_data , model )
        % Apply your model here
        
    end

end
  
    

    

            






