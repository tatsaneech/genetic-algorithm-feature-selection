function [ stat ] = stats_XEntropy( pred, target )
%cost_XEntropy Calculates the Cross-Entropy of a given pred/target pair
%   [ stat ] = stats_XEntropy( pred, target )

% Louis Mayaud, Oct 4th : Very simple implementation, refers to
% http://en.wikipedia.org/wiki/Cross_entropy

if size(pred,2)==size(target,1)
    pred=pred';
end

if length(unique(target))==2 % Binary statcome - classification
    pred = pred > 0.5 ;
    stat = 0;
    for c=unique(target)'
        stat = stat + sum(target==c)*log(sum(pred==c)) ;
    end
    
else % Continous statcome - Regression 

     % Estimate the density distribution for both
    [fPred,xiPred] = ksdensity(pred,'width',.010);
    [fTarget,xiTarget] = ksdensity(target,'width',.010);

    % Merge the two densities
    x = sort([xiPred xiTarget]);
    fPred = interp1(xiPred,fPred,x,'linear','extrap'); fPred = fPred - min(fPred) +1e-6;
    fTarget = interp1(xiTarget,fTarget,x,'linear','extrap');

    % compute cross-entropy
    stat = trapz(x,fTarget.*log(fPred));
end

end

