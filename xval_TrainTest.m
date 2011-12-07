function [ tr_idx, t_idx, D ] = xval_TrainTest( data_target, options )
%XVAL_TrainTest : for 2 distinctives Training and test sets
%   Default assigne indices 70%/30% training/test.

D=1; % Number of fitness repetitions
P=1/2; % Data split
N=length(data_target);
    
tr_idx = false(N,1);
tr_idx(1:floor(P*N)) = true ;
t_idx = ~tr_idx;


end
