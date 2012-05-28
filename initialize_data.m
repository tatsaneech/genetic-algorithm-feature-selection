function [ data, target, idxResample ] = initialize_data(data,target,opt)
%INITIALIZE_DATA	Initialize data used in GA - preprocessing etc
%	[ data, target ] = initialize_data(data,target,opt) initializes the
%	data for the GA preprocessing. This involves balancing the data if
%	opt.BalanceData is set to true.
%
%	[ data, target, idxResample ] = initialize_data(data,target,opt) also
%	outputs the logical indices used to sub-sample the original data.
%
%
%	Inputs:
%		data    - Double matrix of data
%       target  - Double vector of ground truth targets
%		opt     - Options structure for GA
%
%	Outputs:
%		data    - Data after pre-processing (includes balancing)
%		target  - Targets after re-indexing to match data (if needed)
%
%	Example
%		[ data, target ] = initialize_data(data,target,opt)
%
%	See also ALGOGEN GA_GUI GA_OPT_SET

%	Copyright 2012 Alistair Johnson

%	$LastChangedBy$
%	$LastChangedDate$
%	$Revision$
%	Originally written on GLNXA64 by Alistair Johnson, 28-May-2012 08:56:26
%	Contact: alistairewj@gmail.com

%=== Check if balance is one
if opt.BalanceData
    %=== Balance data
    [numTar,ti,tj] = unique(target);
    Nt = numel(numTar);
    
    %=== Classification gives Nt==2
    %=== Regression gives Nt>2
    ti = false(numel(target),Nt);
    for k=1:Nt
        ti(:,k) = tj==k; % Loop through classes
    end
    
    %=== Sort according to number of observations in each class
    tisum = sum(ti,1);
    [tisum,tisort] = sort(tisum,2,'descend');
    
    ti = ti(:,tisort);
    
    %=== Rebalance classes if ratio is greater than specified in opt
    if abs(tisum(1)/tisum(end) - opt.BalanceRatio) > 0.01 % 1% tolerance
        %=== Calculate fraction of observations to sample
        N_undersample = tisum(end)/tisum(1);
        
        idxResample = false(size(ti));
        for k=1:(Nt-1)
            %=== Randomly undersample data from other classes
            ti_r = find(ti(:,k)==1); % Find indices of this class
            [~,idxSampled] = sort(rand(1,numel(ti_r)));
            idxSampled = idxSampled(1:ceil(numel(ti_r)*N_undersample*opt.BalanceRatio));
            ti_r = ti_r(idxSampled); % Select subset of indices
            idxResample(ti_r,k) = true; % Record as logical indices
        end
        idxResample(:,Nt) = ti(:,Nt); % push lowest class to new indices
        
        %=== Resample data according to logical vector created
        idxResample = any(idxResample,2);
        data = data(idxResample,:);
        target = target(idxResample);
    end
    
end

end