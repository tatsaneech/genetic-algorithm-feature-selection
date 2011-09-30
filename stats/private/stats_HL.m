function [ stat ] = stats_HL(pred,target)
%STATS_HL	Hosmer-Lemeshow C Statistic
%	[ stat ] = stats_HL(pred,target) 
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
%		[ stat ] = stats_HL(pred,target) 
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

bins=10;

% sort predictions from lowest to highest
[pred,ind]=sort(pred,1,'ascend');
target=target(ind);
stat=zeros(10,1);


bin = floor(1+length(pred)*(0:bins)/bins);
for q = 1:bins
    int = bin(q):(bin(q+1)-1); %bin indexes
    N = length(int); % number of patients in bin
    E=sum((pred(int))); % expected
    O=sum(round(target(int))); % observed
    Eprob = mean(pred(int)) ; % expected probability
    stat(q) = (E-O)^2 / (Eprob*N*(1-Eprob));
end
stat = sum(stat);



end