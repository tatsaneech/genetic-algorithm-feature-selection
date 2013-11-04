function [ c ] = cost_AUROC( pred, target, model )
%cost_AUROC Uses the AUROC as the cost function of the GA.
%   [ c ] = cost_AUROC( pred, target )
%       pred    - vector containing the predicted values, [0-1]
%       target     - vector containing the true values, [0,1]
%
%       The AUROC is a measure of model discrimination
%           Mathematically: Pr(pred|out==1 > pred|out==0)


idxNotNan = isfinite(target);
if ~all(idxNotNan)
    pred = pred(idxNotNan); target = target(idxNotNan);
end
%=== Arrange predictions
[pred,idx] = sort(pred,1,'ascend');
target=target(idx);
N_POS = sum(target);
[N,P] = size(pred);


negative = target==0;
%=== Count the number of negative targets below each element
negativeCS = cumsum(negative,1);
%=== Only get positive targets
positive = reshape(negativeCS(~negative),N_POS,P);
c = sum(positive,1); %=== count number who are negative
count = N_POS .* (N-N_POS);  %=== multiply by positives
c = c./count; % 1xP where P is # of AUROCs to calculate



%=== OLD CODE
% if size(pred,2)==size(target,1)
%     pred=pred';
% end
% 
% alive=pred(target==0); dead=pred(target==1);
% n=1; c=0;
% %compare 0s to 1s
% while n<=length(dead)
%     c=c+sum(dead(n)>alive);
%     n=n+1;
% end
% 
% count=length(alive)*length(dead);
% c=c/count;

end

