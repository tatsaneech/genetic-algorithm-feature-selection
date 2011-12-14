function [ stat ] = stats_BER( pred, target )
% stats_BER Calculates the balanced error rate for a given pred/target pair
%   [ stats ] = stats_BER( pred, target )
%

% Louis Mayaud, Dec 5th : BER for cost function
% Updated Dec 14th for stats


TP=sum(pred(target==1) >= 0.5);
FP=sum(pred(target==0) >= 0.5);
FN=sum(pred(target==1) < 0.5);
TN=sum(pred(target==0) < 0.5);

stat = 0.5*(FP/(TN+FP) + FN/(FN+TP)) ;

end

