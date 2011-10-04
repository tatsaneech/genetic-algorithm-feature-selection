function [ out ] = cost_XEntropy( pred, target )
%cost_XEntropy Uses the Cross-Entropy as the cost function for the GA.
%   [ out ] = cost_XEntropy( pred, target )
% Louis Mayaud, Oct 4th : Very stupid implementation, refers to
% http://en.wikipedia.org/wiki/Cross_entropy

if size(pred,2)==size(target,1)
    pred=pred';
end

% convert to logistic regression
pred = 1./(1+exp(-pred));
% convert target to doubles in case it's boolean
target = target + 0.;

% Estimate the density distribution for both
[fPred,xiPred] = ksdensity(pred,'width',.010);
[fTarget,xiTarget] = ksdensity(target,'width',.010);

% Merge the two densities
x = sort([xiPred xiTarget]);
fPred = interp1(xiPred,fPred,x,'linear','extrap'); fPred = fPred - min(fPred) +1e-6;
fTarget = interp1(xiTarget,fTarget,x,'linear','extrap');

% compute cross-entropy
out = trapz(x,fTarget.*log(fPred));

end

