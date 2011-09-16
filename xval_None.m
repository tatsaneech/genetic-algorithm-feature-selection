function [ tr_idx, t_idx, D ] = xval_None( data_target, options )
%XVAL_NONE No Cross Validation used.
%   Default is 50 randomly assigned indices 70%/30% training/test.

if isempty(options.CrossValidationParam)
    D=50;
    P=0.3;
else
    D=options.CrossValidationParam(1);
    P=options.CrossValidationParam(2);
end

N=length(data_target);
    
%     random indices from 1:N
[~,temp] = sort(rand(N,D),1);
  
% Temporary numerical indices
tr_idx=false(N,D);
t_idx=false(N,D);

test1 = (temp(1:floor(N*P),:));
train1=temp(floor(N*P)+1:end,:);

%TODO: make this vectorized
for k=1:D
    tr_idx(train1(:,k),k)=true;
    t_idx(test1(:,k),k)=true;
end

end

