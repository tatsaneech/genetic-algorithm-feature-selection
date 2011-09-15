function [ out, roc ] = stat_calc_struct( pred, target )
%stat_calc_struct Unleashes many statistical tests to determine the efficacy
% of a given set of predictions, pred, on a set of dichotomous targets,
% target. Predictions should range between 0-1, and represent the
% probability estimate that the target is 1.
%   [ out ] = stat_calc_struct(pred,target) calculates the following
%   statistical tests and stores them in the corresponding structure fields
%   listed:
%
%       AUROC   - Area under the receiver operator (characteristic) curve
%       HL      - Hosmer-Lemeshow Statistic
%       acc     - Mean accuracy of the prediction using a threshold of 0.5
%       R       - Shapiro's R, the geometric mean of positive outcomes
%       B       - Brier's score, the mean square error
%       SMR     - Standardized mortality ratio. Mean observed outcomes
%                   divided by mean predicted outcomes.
%       coxA    - Alpha coefficient in cox calibration.
%       coxB    - Beta coefficient in cox calibration.
%                   Cox calibration involves a linear regression of the
%                   predictions onto the targets. coxA is the constant
%                   offset, while coxB is the slope.
%       TP      - True positives.
%       FP      - False positives.
%       TN      - True negatives.
%       FN      - False negatives.
%       sens    - Sensitivity. Calculated as: TP/(TP+FN)
%       spec    - Specificity. Calculated as: TN/(TN+FP)
%       ppv     - Positive predictive value. Calculated as: TP/(TP+FP)
%       npv     - Negative predictive value. Calculated as: TN/(TN+FN)
% 
%   [ out,roc ] = stat_calc_struct(pred,target) additionally calculates the
%       values pairs which form the ROC curve.
%           roc.x - Stores 1-specificity, plotted on the x-axis
%           roc.y - Stores Sensitivity, plotted on the y-axis


if max(pred>1) || max(pred<0)
    warning('stat_calc_struct:IllConditioned',['This function will return potentially erroneous values \n]' ...
        'when predictions are not in the range [0,1].']);
end
% c-stat
out.AUROC=cstat(pred,target);

% Shapiro's R (geometric mean of positive targetcomes)
% transform into naural logarithm, take arithmetic mean, transform back
out.R=exp(sum(log(pred(logical(target))))/sum(target));

% Brier's Score, B (mean square error)
out.B=mean((target-pred).^2);

% Accuracy
out.acc=1-(sum(abs(round(target-pred)),1)/length(target));

% hosmer-lemeshow
out.HL=hltest(pred,target);

% SMR
out.SMR=sum(target)/sum(round(pred));

% cox linear regression testing
b=glmfit(target,pred,'normal');
out.coxA=b(1); out.coxB=b(2);
    
out.TP=sum(pred(target==1) >= 0.5);
out.FN=sum(pred(target==1) < 0.5);
out.FP=sum(pred(target==0) >= 0.5);
out.TN=sum(pred(target==0) < 0.5);

out.sens=out.TP/(out.TP+out.FN);
out.spec=out.TN/(out.TN+out.FP);
out.ppv=out.TP/(out.TP+out.FP);
out.npv=out.TN/(out.TN+out.FN);

if nargout>1
    [roc.x,roc.y]=perfcurve(target,pred,1);
end

end

function [ G ] = hltest( pred, outcome )
%hltest hosmer lemeshow test
%   [ G ] = hltest(pred, outcome) calculates the hosmer-lemeshow C statistic
%   for a given set of predictions and outcomes. Steps include:
%       1) Sort data from lowest pred to highest
%       2) Split the data into 10 bins with equal size
%       3) Calculate the mean square error for each bin
%       4) Divide the each bin by the number of samples in each bin
%       5) Divide each bin by the mean prediction in that bin
%       6) Divide each bin by (1-mean prediction) in that bin
%       7) Sum across all bins
%   
bins=10;

% sort predictions from lowest to highest
[pred,ind]=sort(pred,1,'ascend');
outcome=outcome(ind);
G=zeros(10,1);


bin = floor(1+length(pred)*(0:bins)/bins);
for q = 1:bins
    int = bin(q):(bin(q+1)-1); %bin indexes
    N = length(int); % number of patients in bin
    E=sum((pred(int))); % expected
    O=sum(round(outcome(int))); % observed
    Eprob = mean(pred(int)) ; % expected probability
    G(q) = (E-O)^2 / (Eprob*N*(1-Eprob));
end
G = sum(G);


end

function [ c ] = cstat( pred, out )
%cstat Calculates the c-statistic
%   [ c ] = cstat (pred, out)
%       pred    - vector containing the predicted values
%       out     - vector containing the true values
%
%       c is equivalent to the AUROC, a measure of model discrimination
%           Mathematically: Pr(pred|out==1 > pred|out==0)

alive=pred(out==0); dead=pred(out==1);
n=1; c=0;
%compare 0s to 1s
while n<=length(dead)
    c=c+sum(dead(n)>alive);
    n=n+1;
end

count=length(alive)*length(dead);
c=c/count;

end