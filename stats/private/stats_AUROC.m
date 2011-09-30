function [ stat ] = stats_AUROC(pred,target)
%STATS_AUROC	Area under the receiver operator (characteristic) curve
%	[ stat ] = stats_AUROC(pred,target) 
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

alive=pred(target==0); dead=pred(target==1);
n=1; stat=0;
%compare 0s to 1s
while n<=length(dead)
    stat=stat+sum(dead(n)>alive);
    n=n+1;
end

count=length(alive)*length(dead);
stat=stat/count;

end