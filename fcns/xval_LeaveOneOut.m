function [ tr_idx, t_idx, D ] = xval_LeaveOneOut( data_target, options )
%XVAL_LEAVEONEOUT Leave one out validation.
%   Implements leave one out validation - a single data point is used for
%       testing, and all data points are tested on once.

N=length(data_target);
D=N;

t_idx=diag(true(N,1)); % One test data point per column located on main diag
tr_idx=~t_idx;

end