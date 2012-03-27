function [ tr_idx, t_idx, D ] = xval_KfoldD( data_target, options )
%XVAL_KFOLDD	Deterministic K-Fold 
%   Returns training/test indices of k-fold cross validation using
% K-folds as defined in options (default 5). Indices are deterministically
% generated using the scheme:
%       [1, K, 2*K, ...] -> group 1
%       [2, K+1, 2*K+1, ...] -> group 2
%
%   [ tr_idx, t_idx, D ] = xval_Kfold( data_target, options )
%	
%
%	Inputs:
%		
%		
%
%	Outputs:
%		
%		
%
%	Example
%		[ ] = xval_KfoldD() 
%	
%	See also ALGOGEN

%	Copyright 2012 Alistair Johnson
%	Originally written on GLNXA64 by Alistair Johnson, 27-Mar-2012 14:53:34
%	Contact: alistairewj@gmail.com


D=options.CrossValidationParam(1);

N=length(data_target);

% Reproducible indices from 1:N
temp=1:N;

% Calculate cross-validation indices (randomly placed integers 1:D)
xval=mod(temp,D)+1;

% Pre-allocate
tr_idx=false(N,D);
t_idx=false(N,D);

%TODO: make this vectorized
for k=1:D
    t_idx(:,k)=xval==k;
    tr_idx(:,k)=~t_idx(:,k);
end

end