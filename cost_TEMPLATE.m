function [ out ] = cost_TEMPLATE( pred, target )
% cost_TEMPLATE Uses the Cross-Entropy as the cost function for the GA.
%   [ out ] = cost_TEMPLATE( pred, target )
% Louis Mayaud, Oct 4th : Template for cost function

        % Do whatever here that is a function of pred,target and you would
        % like the GA to optimize
out = sqrt(sqrt(mean(pred-target).^2)) ;

end

