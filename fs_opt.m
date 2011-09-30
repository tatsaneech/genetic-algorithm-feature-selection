function [ tr_cost, t_cost ] = fs_opt( tr_cost, t_cost, FS, options )
%FS_OPT Alters algorithm costs to minimize features selected.

% Check if FS_opt is desired
if options.MinimizeFeatures==false
    return; % do nothing
end

L=sum(FS); % the "level" - penalty for num of features

% define threshold and margin - I hate parametric methods
t=0.85;
m=1;

% transform costs
tr_p=(exp((tr_cost-t)/m)-1) / (exp(1)-1);
t_p=(exp((t_cost-t)/m)-1) / (exp(1)-1);
if options.OptDir==0
    tr_cost=L+tr_p;
    t_cost=L+t_p;
else
    tr_cost=-L-tr_p;
    t_cost=-L-t_p;
end

end

