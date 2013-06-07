function [ out ] = cost_RMSE( pred, target, model )
%cost_RMSE Uses the RMSE as the cost function for the GA.
%   [ out ] = cost_RMSE( pred, target )

if size(pred,2)==size(target,1)
    pred=pred';
end

out=sqrt( mean((pred - target).^2));

end

