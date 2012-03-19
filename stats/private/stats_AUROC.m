function [ stat ] = stats_AUROC(pred,target)
%STATS_AUROC	Area under the receiver operator (characteristic) curve
%	[ stat ] = stats_AUROC(pred,target) calculates the AUROC (Wilcoxon
%	statistic) for each column in pred and target.
%
%	Inputs:
%		pred - Nx1 vector of predicted classes
%		target - Nx1 vector of true classes
%
%	Outputs:
%		stat - The desired test statistic.
%
%	Example using fisheriris data set (requires Statistics Toolbox)
%		load fisheriris % load data;
%		X=meas; % input data 
%       % Try to predict whether species is 'setosa'
%		target=double(strcmp('setosa',species)); 
%
%		stats=regstats(target,X,'linear','yhat'); % Create model
%
%		pred=double(stats.yhat>0.5); % Extract predictions
%       
%		[ stat ] = stats_AUROC(pred,target) 
%	
%	See also GA_STATS

%	References:
%	
%	
%	$Author: Alistair Johnson$
%	$Revision: 1.0.0.0$
%	$Date: 30-Sep-2011 16:17:46$
%	Contact: alistairewj@gmail.com
%	Originally written on: GLNXA64

%	Copyright 2011 Alistair Johnson


%=== Arrange outcomes
[pred,idx] = sort(pred,1,'ascend');
target=target(idx);
[N,P] = size(pred);

%=== Find location of negative targets
stat=zeros(1,P); % 1xP where P is # of AUROCs to calculate
negative=false(N,P);

for n=1:P
    negative(:,n) = target(:,n)==0;
    
    %=== Count the number of negative targets below each element
    negativeCS = cumsum(negative(:,n),1);
    
    %=== Only get positive targets
    pos = negativeCS(~negative(:,n));
    
    stat(n) = sum(pos);
end
count=sum(negative,1); %=== count number who are negative
count = count .* (N-count); %=== multiply by positives
stat=stat./count;

end