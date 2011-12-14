function [ stat ] = stats_RMSE( pred, target )
%cost_RMSE Calculates the root mean square error for a pred/target pair
%   [ stat ] = stats_RMSE( pred, target )

if size(pred,2)==size(target,1)
    pred=pred';
end

stat=sqrt( mean((pred - target).^2));

end

