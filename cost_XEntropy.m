function [ out ] = cost_XEntropy( pred, target )
%cost_XEntropy Uses the Cross-Entropy as the cost function for the GA.
%   [ out ] = cost_XEntropy( pred, target )
% Louis Mayaud, Oct 4th : Very stupid implementation, refers to
% http://en.wikipedia.org/wiki/Cross_entropy

if size(pred,2)==size(target,1)
    pred=pred';
end

target = target + 0.;
out = sum(pred.*log(target));

end

