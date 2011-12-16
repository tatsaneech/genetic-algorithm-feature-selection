function [ stat ] = stats_NegativeLR(pred,target)
%STATS_NEGATIVELR	Negative likelihood ratio. 
%   Calculated as: sensitivity/(1-specificity);
%	[ stat ] = stats_NegativeLR(pred,target) 
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
%		[ stat ] = stats_NegativeLR(pred,target) 
%	
%	See also GA_STATS STATS_SENSITIVITY STATS_SPECIFICITY

%	References:
%	
%	
%	$LastChangedBy$
%	$LastChangedDate$
%	$Revision$
%	Contact: alistairewj@gmail.com
%	Originally written on: GLNXA64, 16-Dec-2011 14:20:09

%	Copyright 2011 Alistair Johnson


TP=sum(pred(target==1) >= 0.5);
FN=sum(pred(target==1) < 0.5);
sens=TP/(TP+FN);

FP=sum(pred(target==0) >= 0.5);
TN=sum(pred(target==0) < 0.5);
spec=TN/(TN+FP);

stat=sens/(1-spec);
end