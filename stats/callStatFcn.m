function [ cost ] = callStatFcn(costFcn,...
                pred, target)
%CALLSTATFCN	Calls the given statistic as the cost function for the GA
%	[ cost ] = callStatFcn(costFcn, pred, target) 
%	
%	Inputs:
%		costFcn - String name of cost function to use
%       pred    - Prediction vector
%       target  - Target vector
%		
%
%	Outputs:
%		cost    - Value of cost for given pred/target pair
%
%	Example
%		[ cost ] = callStatFcn('cost_AUROC', pred, target) 
%	
%	See also GA_STATS EVALUATE EVALUATE_PAR

%	Copyright 2011 Alistair Johnson

%	Originally written on GLNXA64 by Alistair Johnson, 14-Dec-2011 15:28:26
%	Contact: alistairewj@gmail.com

%=== Convert cost_ to stat_
costFcn = regexprep(costFcn,'cost_','stat_','once');

%=== Calculate cost
cost=feval(costFcn,pred,target);

end