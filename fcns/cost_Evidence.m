function [ out ] = cost_Evidence( pred, target, model )


if size(pred,2)==size(target,1)
    pred=pred';
end

% if length(unique(target))>2
%     % regression
%     Ed =  1/2*b*sum( ( target - pred ).^2 );
% else
%     % classification
%     Ed = -nansum( target.*log(realmin+pred) + (1-target).*log(realmin+1-pred) );
%     %Ed = exp(Ed);
% end 

Ed = nansum( target.*log(realmin+pred) + (1-target).*log(realmin+1-pred) );

% Best-fit Likelyhood 
% Ed = prod( pred.^(target).*(1-pred).^(1-target) );

%% Multiply by Occam's factor

%=== since covariance is positive definite we can do cholskey projection
% requires the lightspeed toolbox, though should double check this fast
if exist('inv_triu.m','file')==2
    hess = cholproj(model.stats.covb);
    hess = inv_triu(hess);
    hess = hess*hess';
else
    hess = inv(model.stats.covb);
end

% Probabily of parameters given assumptions. Assumptions is all betas are
% normally distributed with mean 0 and variance 3
% equivalent to 1/sigma_w where sigma is the prior uncertainty of the
% parameters
Log_Pw_H =  sum( log(pdf('norm', model.betas ,0 , 1)+1e-10) );
LogOccamFactor = Log_Pw_H - log( det( hess / (2*pi) ) )/2 ;
Ed = Ed + LogOccamFactor;

out = Ed;



end


