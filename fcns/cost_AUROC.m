function [ c ] = cost_AUROC( pred, target )
%cost_AUROC Uses the AUROC as the cost function of the GA.
%   [ c ] = cost_AUROC( pred, target )
%       pred    - vector containing the predicted values, [0-1]
%       target     - vector containing the true values, [0,1]
%
%       The AUROC is a measure of model discrimination
%           Mathematically: Pr(pred|out==1 > pred|out==0)

if size(pred,2)==size(target,1)
    pred=pred';
end

alive=pred(target==0); dead=pred(target==1);
n=1; c=0;
%compare 0s to 1s
while n<=length(dead)
    c=c+sum(dead(n)>alive);
    n=n+1;
end

count=length(alive)*length(dead);
c=c/count;

end

