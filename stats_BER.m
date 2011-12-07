function [ out ] = stats_BER( pred, target )
% stats_BER the Balanced Error Rate 
%   [ out ] = cost_BER( pred, target )
% Louis Mayaud, Dec 5th : BER


TP=sum(pred(target==1) >= 0.5);
FP=sum(pred(target==0) >= 0.5);
FN=sum(pred(target==1) < 0.5);
TN=sum(pred(target==0) < 0.5);

out = 0.5*(FP/(TN+FP) + FN/(FN+TP)) ;

end

