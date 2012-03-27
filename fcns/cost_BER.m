function [ out ] = cost_BER( pred, target )
% cost_BER Uses the Balanced Error Rate as the cost function for the GA.
%   [ out ] = cost_BER( pred, target )
% Louis Mayaud, Dec 5th : BER for cost function


TP=sum(pred(target==1) >= 0.5);
FP=sum(pred(target==0) >= 0.5);
FN=sum(pred(target==1) < 0.5);
TN=sum(pred(target==0) < 0.5);

out = 0.5*(FP/(TN+FP) + FN/(FN+TP)) ;

end

