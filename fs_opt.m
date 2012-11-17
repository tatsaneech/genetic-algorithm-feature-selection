function [ tr_cost, t_cost ] = fs_opt( tr_cost, t_cost, FS, options )
%FS_OPT Alters algorithm costs to minimize features selected.

% Check if FS_opt is desired
if options.MinimizeFeatures==false
    return; % do nothing
end

if isa(options.CostFcn,'function_handle')
    costFcn = func2str(options.CostFcn);
else
    costFcn = options.CostFcn;
end

%=== If PSO model, have to modify the number of free parameters ...
if isa(options.FitnessFcn,'function_handle')
    FitnessFcn = func2str(options.FitnessFcn);
else
    FitnessFcn = options.FitnessFcn;
end
%=== Choose AIC depending on cost function
if strcmp(costFcn,'stats_LL')
    if strcmp(FitnessFcn,'fit_MYPSO');
        k=2*5;
    else
        k=2;
    end
    
    %=== Do LL version of AIC
    tr_cost = k*sum(FS) + 2*tr_cost;
    t_cost = k*sum(FS) + 2*t_cost;
else
    %=== Parametric version of AIC
    
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
end

