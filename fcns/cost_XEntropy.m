function [ out ] = cost_XEntropy( pred, target )
%cost_XEntropy Uses the Cross-Entropy as the cost function for the GA.
%   [ out ] = cost_XEntropy( pred, target )
% Louis Mayaud, Oct 4th : Very simple implementation, refers to
% http://en.wikipedia.org/wiki/Cross_entropy

if size(pred,2)==size(target,1)
    pred=pred';
end

if length(unique(target))==2 % Binary outcome - classification
    pred = pred > 0.5 ;
    out = 0;
    for c=unique(target)'
        out = out + sum(target==c)*log(sum(pred==c)) ;
    end
    
else % Continous outcome - Regression 

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

end

