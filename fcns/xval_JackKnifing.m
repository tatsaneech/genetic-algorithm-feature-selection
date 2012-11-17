function [ tr_idx, t_idx, D ] = xval_JackKnifing( data_target, options )
%XVAL_JACKKNIFING Jack-knifing of data.
%   [ tr_idx, t_idx, D ] = xval_JackKnifing( data_target, options ) samples
%   without replacement from the original training data set.
%   Returns logical indices.

D=options.CrossValidationParam(1);
P=options.CrossValidationParam(2);

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
