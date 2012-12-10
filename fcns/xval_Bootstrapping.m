function [ tr_idx, t_idx, D ] = xval_Bootstrapping( data_target, options )
%XVAL_BOOTSTRAPPING Bootstrap of data.
%   [ tr_idx, t_idx, D ] = xval_Bootstrapping( data_target, options )
%   samples with replacement from the data set to generate training and
%   test data sets.
%
%
%	Inputs:
%		data_target - Input data targets
%		options     - options containing CrossValidationParam field
%				The field should be a numeric value indicating the number
%				of bootstrap repetitions to be performed.
%		
%
%	Outputs:
%		

D=options.CrossValidationParam(1);
N=length(data_target);

% generate numeric random indices from 1:N (sampling with replacement)
tr_idx = ceil(N*rand(N,D));

% Test indices are logical (values not used)
idx = sub2ind([N,D],tr_idx,repmat(1:D,N,1));
t_idx=true(N,D);
t_idx(idx) = false;

end
