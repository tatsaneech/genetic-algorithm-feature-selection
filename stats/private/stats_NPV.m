function [ stat ] = stats_NPV(pred,target)
%STATS_NPV	Negative predictive value. Calculated as: TN/(TN+FN)
%	[ stat ] = stats_NPV(pred,target) 
%	
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
%		[ stat ] = stats_NPV(pred,target) 
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

TP=sum(pred(target==1) >= 0.5);
FP=sum(pred(target==0) >= 0.5);
FN=sum(pred(target==1) < 0.5);
TN=sum(pred(target==0) < 0.5);

npv=TN/(TN+FN);

end