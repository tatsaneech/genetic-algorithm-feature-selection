function [ tr_idx, t_idx, D ] = xval_None( data_target, options )
%XVAL_NONE No Cross Validation used.

D=1;
N=length(data_target);
  
% Temporary numerical indices
tr_idx=true(N,D);
t_idx=true(N,D);

end

