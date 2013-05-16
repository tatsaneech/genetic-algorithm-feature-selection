function [ options ] = ga_opt_set( varargin )
%GA_OPT_SET Sets the options used in the main genetic algorithm function.
%   GA_OPT_SET() displays the options available.
%
%   OPTIONS = GA_OPT_SET() creates a structure with default parameters
%
%   OPTIONS = GA_OPT_SET('PARAM1',VALUE1,'PARAM2',VALUE2,....) will create
%   a structure using default parameters. PARAMs specified in the input
%   will be assigned the corresponding VALUE.
%
%   OPTIONS = GA_OPT_SET(OLDOPTS,'PARAM',VALUE) will create a structure
%   using a prior options structure and reassigning fields corresponding to
%   the parameter value pairs.
%
%GA_OPT_SET PARAMETERS
%
%   PopulationSize      - The number of genomes in the population
%                       [ positive integer | {100} ]
%   Display             - What to display during execution
%                       [ 'plot' | 'text' | {'none'} ]
%   MaxFeatures         - The maximum allowable features in each genome
%                       [ positive scalar | {0} (no limit) ]
%   MinFeatures         - The minimum allowable features in each genome
%                       [ positive scalar | {0} (no limit) ]
%   MaxIterations       - Maximum number of generations/epochs
%                       [ positive scalar | {100} ]
%   ConfoundingFactors  - Features forced to be selected in all genomes
%                       [ positive scalar index | {0} (none) ]
%   Repetitions         - Number of distinct populations to optimize
%                       [ positive scalar | {10} ]
%   FitnessFcn          - The fitness function used to evaluate genomes
%                       [ function name string | function handle | {[]} ]
%   FitnessParam        - Parameters of the fitness function
%                       [Options structure | {[]} ]
%   CostFcn             - The cost function used to evaluate fitness predictions
%                       [ function name string | function handle | {[]} ]
%   MutationFcn          - The function used to mutate genomes
%                       [ function name string | function handle | {[]} ]
%   CrossoverFcn        - The type of genomic crossover used
%                       [ function name string | function handle | {[]} ]
%   CrossValidationFcn  - The type of cross-validation technique used
%                       [ function name string | function handle | {[]} ]
%   CrossValidationParam - Parameters of the cross-validation function
%                       [Double vector | {[]} ]
%   Elitism             - How many parents (%) should be passed down unchanged to next generation
%                       [ positive scalar between 0-100 | {10} ]
%   MutationRate       - Rate of ramndom mutations applied to children
%                       [ positive scalar between 0-1 | {.06} ]
%   OptDir             - The optimization direction, 0 - min, 1 - maximize
%                       [ 1 | {0} ]
%   OutputContent      - Specify the data stored in the output structure
%                       Note: may increase computationally intensity
%                       [ {'normal'} | 'detailed' | 'debug' ]
%   PlotFcn             - The plotting function used for display
%                       [ function name string | function handle | {[]} ]
%   ErrorGradient       - The minimum improvement required to prevent error termination
%                       [ positive scalar | {0.01} ]
%   ErrorIterations      - The number of iterations over which the error change must be higher than the defined error gradient
%                       [ positive integer | {10} ]
%   FileName            - The file name used for output
%                       [ string | {'AlgoGen.csv'} ]
%   Parallelize         - Whether genome fitness operations should be parallelized.
%                       [ logical | 0 | {1} ]
%   NormalizeData       - Whether data should be normalized during training
%                       [ logical | 0 | {1} ]
%   BalanceData         - Whether data classes should be balanced during training
%                       [ logical | 0 | {1} ]
%   BalanceRatio        - Ratio of largest class observations to smallest
%                       class observations (x:1, e.g. 1:1 is balanced)
%                       [ positive scalar greater than 0 | {1} ]
%   NumFeatures         - Number of features present in data set
%                       [ positive integer | {0} ]
%   PopulationEvolutionAxe      - Axe handle to plot the population
%   evolution over generations. Will be created if null.
%                               [ axe handle | 0 | {0} ]
%   FitFunctionEvolutionAxe      - Axe handle to plot the evolution
%   of fit function value over generations. Will be created if null.
%                               [ axe handle | 0 | {0} ]
%   CurrentPopulationAxe         - Axe handle to plot the current
%   population. Will be created if null.
%                               [ axe handle | 0 | {0} ]
%   CurrentScoreAxe              - Axe handle to plot the performence of
%   the best genome from the current generation. PlotFcn is the function
%   used to update this axe. Will be created if null.
%                               [ axe handle | 0 | {0} ]

%=== create defaults
if nargout==0
    displayGAOptions; % Call subfunction to display options
    return;
else
    options=struct( ...
        'Display', 'plot', ...
        'MaxIterations', 100, ...
        'PopulationSize', 50, ...
        'MaxFeatures', 0, ...
        'MinFeatures', 0, ...
        'NumFeatures', 0, ...
        'ConfoundingFactors', [], ...
        'Repetitions', 100, ...
        'OptDir', 0, ...
        'OutputContent', 'normal',...
        'FitnessFcn', 'fit_LR', ...% This should have the exact same name as the .m function
        'FitnessParam',[], ...
        'CostFcn', 'cost_RMSE', ... % This should have the exact same name as the .m function
        'CrossoverFcn', 'crsov_SP', ... % This should have the exact same name as the .m function
        'MutationFcn', 'mut_SP', ...
        'MutationRate', 0.06, ...
        'CrossValidationFcn', 'xval_None', ...
        'CrossValidationParam',[], ...
        'PlotFcn', 'plot_All', ...% This should have the exact same name as the .m function
        'ErrorGradient', 0.01, ...
        'ErrorIterations', 10, ...
        'FileName',[], ...
        'Parallelize', 0, ...
        'NormalizeData', 1, ...
        'BalanceData', 1, ...
        'BalanceRatio', 1, ...
        'Elitism',10 , ...
        'MinimizeFeatures',false, ...
        'PopulationEvolutionAxe', [],...
        'FitFunctionEvolutionAxe', [],...
        'CurrentPopulationAxe', [],...
        'CurrentScoreAxe', [],...
        'GUIFlag',true,...
        'InitialFeatureNum', 0 ...
        );
end
if nargin==0
    return;
end

%=== allowed parameters
okargs=fieldnames(options);
numargs=length(varargin);

%=== Loop through input arguments
k=1; % Varargin index

%=== Check if first input is a structure
if isstruct(varargin{k})
    %=== Scan through structure, use values if appropriate
    fn=fieldnames(varargin{k});
    fn_L=length(fn);
    %=== Loop through input options
    for s=1:fn_L
        %=== Commented code left for readability
        %         pname = fn{s}; pval = varargin{k}.(fn{s});
        %         param = find(strcmpi(pname, okargs)==1,1);
        [options] = updateOptionsField(options, ...
            fn{s}, varargin{k}.(fn{s}), find(strcmpi(fn{s}, okargs)==1,1));
    end
    k=k+1;
end

%=== check for incorrect number of inputs
if (k==1 && rem(nargin,2) == 1) || ... % No structure, odd number of inputs
        (k==2 && rem(nargin,2) == 0) % Structure, even number of inputs
    error(sprintf('Options:%s:IncorrectNumberOfArguments',mfilename),...
        'Incorrect number of arguments to %s.',mfilename);
end

%=== Parse remaining Parameter/Value inputs
while k<=numargs
    [options] = updateOptionsField(options, ...
        varargin{k}, varargin{k+1}, find(strcmpi(varargin{k}, okargs)==1,1));
    k=k+2;
end

%=== Validate intraconsistency of options parameters
[options] = validateConsistency(options);
end

function [options] = updateOptionsField(options, pname, pval, param)
% This function validates the input parameter name/value and updates the
% associated value in options
% This function calls the following other subfunctions:
%   validateParamType - Validates that the parameter is of the right type
%   validateParamIsSubset - Validates that the parameter has a correct value from a
%           set of acceptable values

if isempty(param) % Parameter name not found in okargs
    warning(sprintf('ga_opt_set:%s:UnknownParameterName', mfilename), ...
        'Unknown parameter %s was ignored.',pname);
    return;
else % Parameter name found
    %=== Check if parameter is the right type
    [valid1,errmsg1]=validateParamType(pname,pval);
    
    if valid1==0
        % Parameter is not of the right type
        error(sprintf('ga_opt_set:%s:invalidParamVal',mfilename),errmsg1);
    else
        %=== Check if parameter is one of a set of acceptable values
        [valid2,errmsg2]=validateParamIsSubset(pname,pval);
    end
        
    if valid2==0 
        error(sprintf('ga_opt_set:%s:invalidParamVal',mfilename),errmsg2);
    else % Everything is OK, don't panic.
        options.(pname)=pval;
    end
end

end

function [valid, errmsg] = validateParamType(param, val)
valid=1; errmsg='';
if isempty(val) % Default used
    return;
end

switch param
    case {'Display','OutputContent'}
    % Strings
        if ~ischar(val)
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a string.',param);
            return
        end
        
        % Louis July 6th 11 : Commented the whole thing because it crashed (very wise thing to do isn't it?)
    case 'FileName'
        %         if ~ischar(val) || ...
        %                 (~strcmpi(param,'none') && ~strcmpi(param,'plot') && ~strcmpi(param,'text'))
        %                  % TODO: (Louis 1st July 2011: I am not sure I fully understand
        %                  % the IF clause: don't we want something like:
        %                  % if fopen(FileName,'r')==0
        %                  %     There is an error here => valid=0; errmsg=...
        %                  % else fclose(fid)
        %
        %             valid = 0;
        %             errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be ''never'' or ''always''.',param);
        %        end
    case {'FitnessParam'}
        % Structures
        if ~isempty(val) && ~isstruct(val)
            valid=0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be empty or a structure',param);
        end
    case {'CrossValidationParam'} 
        % Doubles
        if ~isnumeric(val)
            valid=0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric',param);
        end
    case {'ErrorGradient', 'ErrorIterations',...
            'Elitism','BalanceRatio'}
        % Positive definite doubles
        if ~isnumeric(val) || val<0
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive double',param);
        end
    case {'MutationRate'}
        % Positive definite doubles < 1
        if ~isnumeric(val) || val<0 || val>1
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive definite double less than 1',param);
        end
    case {'MaxFeatures','MinFeatures','MaxIterations','PopulationSize',...
            'Repetitions','InitialFeatureNum', 'NumFeatures','BalanceData'}
        % Positive definite integers 
        if ~isnumeric(val) || val<0
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric',param);
        end
        if abs(val-floor(val))>1e-15 % Not an integer
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric',param);
        end
    case {'FitnessFcn','CrossoverFcn','PlotFcn','CostFcn','CrossValidationFcn','MutationFcn'}
        % Functions/Strings
        if ~ischar(val) && ~iscell(val) &&  ~isa(val,'function_handle')
            valid = 0;
            errmsg = sprintf(['Invalid value for OPTIONS parameter %s: must be a string or \n'...
                'function handle with valid three character prefix'],param);
        end
    case {'GUIFlag','Parallelize','OptDir','MinimizeFeatures','NormalizeData'}
        % Booleans/0 1 flags
        if ~islogical(val) && ~(isnumeric(val) && (val==1 || val==0))
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a logical value, 0 or 1',param);
        end
    case {'ConfoundingFactors'} 
        % Lists
        
        %TODO: Make sure command line input style (linear indices) and
        %GUI input style (label titles) work seemlessly here
        %Additionally, allow for both input types!
        % This probably needs to be done in the GA_GUI function, or
        % validateConsistency function
        %=== Check if parameter is of valid variable type
        
        if ~islogical(val) && ~(isnumeric(val))
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be numeric or logical indices',param);
        end
        % Axe handles
    case {'PopulationEvolutionAxe','FitFunctionEvolutionAxe',...
            'CurrentPopulationAxe','CurrentScoreAxe'}
        % TODO check if the axe exists. If not: error
    otherwise
        valid=0;
        errmsg = sprintf('Unknown parameter field %s', param);
end

end

function [valid,errmsg] = validateParamIsSubset(pname,pval)
% This function ensures that the given functions are members of a
% pre-defined set.
% For example:
%   pname - 'costFcn'
%   pval  - 'cost_AUROC'
% Ensure pval is a valid member of the costFcn set - i.e. that pval exists
% in the directory as a function
valid=1;
errmsg='';
curr_dir = mfilename('fullpath');
curr_dir = curr_dir(1:end-(numel('ga_opt_set'))); % remove m-file name
%=== Get pname
if regexp(pname,'CostFcn')
    %=== Cost function is a special case - uses embedded stats functions
    okfcns = arrayfun(@(x) x.name,dir([curr_dir 'stats/private/*.m']),'UniformOutput',false);
    
    %=== If pval is a function handle, convert to char
    if ~ischar(pval)
        pval = func2str(pval);
    end
    
    %=== Update pval in caller as needed
    %   This will either convert function handle->char, replace "cost_"
    %   with "stats_", or both.
    pval = regexprep(pval,'cost_','stats_','once');
    pvalName = [pval '.m'];
    assignin('caller','pval',pval);
    
    %=== Check if pname exists in file names
    fcnIdx = strcmp(okfcns,pvalName);
    if any(fcnIdx)
        valid=1;
        return;
    else
        valid=0;
        errmsg='Function name provided does not match any found in local directory';
    end
elseif regexp(pname,'Fcn') > 1
    %=== Parse function
    % Define allowable function types
    okfcns={'FitnessFcn', 'CrossoverFcn','MutationFcn','CrossValidationFcn','PlotFcn'};
    okfcns_abbr={'fit_*.m','crsov_*.m','mut_*.m','xval_*.m','plot_*.m'};
    
    % Determine which function type is used
    fcn = strcmp(okfcns,pname); % temporary index
    fcn_type = okfcns(fcn); % Type of function
    fcn = okfcns_abbr{fcn}; % Function template for directory scanning
    
    if isempty(fcn_type)
        %=== This error would only happen if a new fcn has been added to
        %the default options but not to this subfunction
        error(sprintf('validateParamIsSubset:%s:invalidParamVal',mfilename),...
            'Function has been defined in ga_opt_set but not in subfunction validateParamIsSubset');
    end
    
    % Scan files and find specific functions
    if exist([curr_dir 'fcns/'],'dir')==7
        files = dir([curr_dir 'fcns/' fcn]);
    else
        files=dir([curr_dir fcn]);
    end
    
    % Get acceptable file names
    okpnames = arrayfun(@(x) x.name,files,'UniformOutput',false);
    
    %=== If pval is a function handle, get the field name
    if ischar(pval)
        pvalName = [pval '.m'];
    else
        pval = func2str(pval);
        pvalName = [pval '.m'];
        % Convert function handle->char
        assignin('caller','pval',pval);
    end
    
    %=== Check if pname exists in file names
    idxPval = strcmp(okpnames,pvalName);
    if any(idxPval)
        valid=1;
        return;
    else
        valid=0;
        errmsg='Function name provided does not match any found in local directory';
    end
else
    % No membership set, return normally
end

end

function [options] = validateConsistency(options)

paramsChecked = {'CrossValidationParam',...
    'FitnessParam',...
    'MinFeatures',...
    'MaxFeatures',...
    'ConfoundingFactors',...
    'CostFcn'};

for k=1:length(paramsChecked)
    param = paramsChecked{k};
    pval = options.(param);
    switch param
        case 'FitnessParam'
            %=== Call optfit function to get default options
            def_opt = feval(['opt' options.FitnessFcn]);
            
            if isempty(pval)
                pval = def_opt;
            else
                %=== Update fields of def_opt with fields in pval
                pval = update_options(def_opt,pval);
            end
            options.(param) = pval;
        case 'CrossValidationParam'
            %=== Ensure cross validation parameters match function
            xvalFcn = options.CrossValidationFcn;
            switch xvalFcn
                case {'xval_Bootstrapping'}
                    if isempty(options.(param)) % Default values
                        options.(param) = zeros(1,1);
                        options.(param)(1)=5; % default 5 repetitions
                    else % Error check
                        if mod(options.(param),1)~=0 % not an integer
                            error(sprintf('validateConsistency:%s:InvalidParamValue',mfilename),...
                                ['Invalid CrossValidationParam value. \n' xvalFcn ' requires an integer value (number of repetitions).']);
                            
                        elseif options.(param)(1)<1 % negative or 0
                            error(sprintf('validateConsistency:%s:InvalidParamValue',mfilename),...
                                ['Invalid CrossValidationParam(1) value. \n' xvalFcn ' requires an integer value  > 0 (number of repetitions).']);
                            
                        end
                    end
                case {'xval_JackKnifing'}
                    if isempty(options.(param)) % Default values
                        options.(param) = zeros(1,2);
                        options.(param)(1)=100;
                        options.(param)(2)=0.3;
                    else % Error check
                        if length(options.(param))<2
                            error(sprintf('validateConsistency:%s:InvalidParamSize',mfilename),...
                                ['Invalid CrossValidationParam size. \n' xvalFcn ' requires a 1x2 double vector.']);
                            
                        elseif options.(param)(1)<1
                            error(sprintf('validateConsistency:%s:InvalidParamValue',mfilename),...
                                ['Invalid CrossValidationParam(1) value. \n' xvalFcn ' requires an integer number of iterations > 0.']);
                            
                        elseif options.(param)(2)>=1 || options.(param)(1)<=0
                            error(sprintf('validateConsistency:%s:InvalidParamValue',mfilename),...
                                ['Invalid CrossValidationParam(2) value. \n' xvalFcn ' requires a data split value between 0 and 1.']);
                            
                        end
                    end
                case {'xval_Kfold'}
                    if isempty(options.(param)) % Default values
                        options.(param) = zeros(1,1);
                        options.(param)(1)=5;
                    else % Error check
                        if length(options.(param))<1
                            error(sprintf('validateConsistency:%s:InvalidParamValue',mfilename),...
                                ['Invalid CrossValidationParam(1) value. \n' xvalFcn ' requires positive integer # of folds.']);
                            
                        elseif options.(param)(1)==1
                            error(sprintf('validateConsistency:%s:InvalidParamValue',mfilename),...
                                ['Invalid CrossValidationParam(1) value. \n' xvalFcn ' requires at least 2 folds']);
                            
                        end
                    end
                case {'xval_TrainTest'}
                    if isempty(options.(param)) % Default values
                        options.(param) = zeros(1,2);
                        options.(param)(1)=100;% Number of fitness repetitions
                        options.(param)(2)=0.3;% Data split
                    else % Error check
                        if length(options.(param))<2
                            error(sprintf('validateConsistency:%s:InvalidParamSize',mfilename),...
                                ['Invalid CrossValidationParam size. \n' xvalFcn ' requires a 1x2 double vector.']);
                            
                        elseif options.(param)(1)<1
                            error(sprintf('validateConsistency:%s:InvalidParamValue',mfilename),...
                                ['Invalid CrossValidationParam(1) value. \n' xvalFcn ' requires an integer number of iterations > 0.']);
                            
                        elseif options.(param)(2)>=1 || options.(param)(1)<=0
                            error(sprintf('validateConsistency:%s:InvalidParamValue',mfilename),...
                                ['Invalid CrossValidationParam(2) value. \n' xvalFcn ' requires a data split value between 0 and 1.']);
                            
                        end
                    end
                case {'xval_None'}
                    % Set default values regardless of input
                    options.(param) = zeros(1,2);
                    options.(param)(1)=100;
                    options.(param)(2)=0.3;
                otherwise
            end
        case 'MinFeatures'
            %=== Less than max features
            if pval > options.MaxFeatures
                error(sprintf('validateConsistency:%s:InvalidParamVal',mfilename),...
                    'Minimum number of features must be less than maximum number of features.');
            end
        case 'MaxFeatures'
            %=== Greater than min features
            if pval < options.MinFeatures
                error(sprintf('validateConsistency:%s:InvalidParamVal',mfilename),...
                    'Minimum number of features must be less than maximum number of features.');
            end
            
        case 'ConfoundingFactors'
            % TODO: check variables Idx within confounding factors are smaller
            % than the number of variables in data
            % For Confounding factors the input should look like '[1 3 4]' when
            % more than one factor or simply '2' when only one confounding
            % factor variable #2 in this case
            % This should be done in validateParamIsSubset in the AlgoGen.m function
            
            if options.NumFeatures~=0
                % NumFeatures has been set... perform checks..
                if islogical(options.ConfoundingFactors)
                    if length(options.ConfoundingFactors) ~= options.NumFeatures
                        % Logical indices are not correct size
                error(sprintf('validateConsistency:%s:InvalidParamVal',mfilename),...
                    'ConfoundingFactors logical indexing does not equal the number of features.');
                        
                    end
                else % numeric
                    if max(options.ConfoundingFactors) > options.NumFeatures
                        % Value is too large
                error(sprintf('validateConsistency:%s:InvalidParamVal',mfilename),...
                    'ConfoundingFactors contains numerical index greater than the number of features.');
                    else
                        % Goldilocks TIME!
                    end
                end
            else
                % NumFeatures is defaulted - cannot check
                % ConfoundingFactors yet..
            end
            
        case 'CostFcn'
            %TODO: Default the optimization direction based on the cost
            %function?
            % Ensure optimization direction and cost function are consistent
            defCost = {'stats_AUROC',1;   'stats_Accuracy',1;...
                'stats_BER',0;            'stats_Brier',0;...
                'stats_Cox',-1;           'stats_FN',0;...
                'stats_FP',0;             'stats_HL',0;...
                'stats_NPV',1;            'stats_Operating',-1;...
                'stats_PPV',1;            'stats_RMSE',0;...
                'stats_SMR',-1;           'stats_Sensitivity',1;...
                'stats_ShapiroR',0;       'stats_Specificity',1;...
                'stats_TN',1;             'stats_TP',1;...
                'stats_XEntropy',0;};
            
            idxCost = find(strcmp(defCost(:,1),options.CostFcn)==1,1);
            if isempty(idxCost)
                %=== did not find cost function in defaults, assume OptDir
                %is correct
            else
                if defCost{idxCost,2}==options.OptDir
                    %=== Optimization direction is correct
                elseif defCost{idxCost,2}==-1
                    %=== This function should not be used for optimization
                    warning(sprintf('ga_opt_set:%s:InvalidCostFunction', mfilename), ...
                    'The function %s should not be used for cost optimization.',options.CostFcn);
                else
                    %=== OptDir incorrectly set
                    options.OptDir = defCost{idxCost,2};
                    warning(sprintf('ga_opt_set:%s:InvalidOptDir', mfilename), ...
                    'OptDir has been set to %2.0f, rather than %2.0f, as the function %s requires this.',...
                    defCost{idxCost,2},options.OptDir,options.CostFcn);
                end
            end
        case 'Display'
            pval = lower(pval); % Remove upper case if present
            options.(param) = pval;
            
            switch pval
                case {'plot','text','none'}
                    %=== Correct input - nothing needed
                otherwise
                    %=== Incorrect - default to normal
                    warning(sprintf('ga_opt_set:%s:InvalidOutputContent', mfilename), ...
                    'Display was set to %s, an invalid value. Defaulted to ''none''.',...
                    pval);
                    options.(param) = 'none';
            end
        case 'OutputContent'
            pval = lower(pval); % Remove upper case if present
            options.(param) = pval;
            switch pval
                case {'normal','detailed','debug'}
                    %=== Correct input - nothing needed
                otherwise
                    %=== Incorrect - default to normal
                    warning(sprintf('ga_opt_set:%s:InvalidOutputContent', mfilename), ...
                    'OutputContent was set to %s, an invalid value. Defaulted to ''normal''.',...
                    pval);
                    options.(param) = 'normal';
                    
            end
        otherwise
            % Recite Acadian Poetry ... or do nothing, your choice!
            % there is beauttiful Acadian Poem at http://www.gov.ns.ca/legislature/library/digitalcollection/bookpart1.stm
    end
end
end


function [opt] = update_options(opt,new_opt)

fn = fieldnames(opt);
N_fn = numel(fn);

% Replace current options fields in options with old options
for m=1:N_fn
    pname = fn{m};
    if isfield(new_opt,pname)
        pval = new_opt.(pname);
        pold = opt.(pname);
        
        %=== Rudimentary error check...
        %   Ensure argument is of same class as default
        if ~isempty(pold)
            class_new = class(pval);
            class_old = class(pold);
            if strcmp(class_new,class_old)
                opt.(pname) = pval;
            else
                error(sprintf('%s:update_options:InvalidParamType',mfilename),...
                    'New parameter value %s of class %s, expected class %s', pname, class_new, class_old);
            end
        else
            warning(sprintf('%s:update_options:UnsetDefaultValue', mfilename), ...
                'Default parameter value %s for fitness function options is unset, rudimentary error check not performed.',pname);
        end
    end
end

if any(strcmp(fn,'libsvm'))
    %=== LIBSVM special case, handle the string -b 1 flag
    %=== Force b to whatever is set in libsvm string
    b = regexp(opt.libsvm,'-b ','once');
    if isempty(b)
        % Default -b is 1
        opt.libsvm = [strtrim(opt.libsvm) ' -b 1'];
    else
        if strcmp(opt.libsvm(b+3),'1')
            opt.b=1;
        elseif strcmp(opt.libsvm(b+3),'0')
            opt.b=0;
        else
            error('libsvm options string b value not properly set.');
        end
    end
end

end

function [] = displayGAOptions

fprintf('GA_OPT_SET PARAMETERS\n');
fprintf('\n');
fprintf('   PopulationSize      - The number of genomes in the population\n');
fprintf('                       [ positive integer | {100} ]\n');
fprintf('   Display             - What to display during execution\n');
fprintf('                       [ ''plot'' | ''text'' | {''none''} ]\n');
fprintf('   MaxFeatures         - The maximum allowable features in each genome\n');
fprintf('                       [ positive scalar | {0} (no limit) ]\n');
fprintf('   MinFeatures         - The minimum allowable features in each genome\n');
fprintf('                       [ positive scalar | {0} (no limit) ]\n');
fprintf('   MaxIterations       - Maximum number of generations/epochs\n');
fprintf('                       [ positive scalar | {100} ]\n');
fprintf('   ConfoundingFactors  - Features forced to be selected in all genomes\n');
fprintf('                       [ positive scalar index | {0} (none) ]\n');
fprintf('   Repetitions         - Number of distinct populations to optimize\n');
fprintf('                       [ positive scalar | {10} ]\n');
fprintf('   FitnessFcn          - The fitness function used to evaluate genomes\n');
fprintf('                       [ function name string | function handle | {[]} ]\n');
fprintf('   CostFcn             - The cost function used to evaluate fitness predictions\n');
fprintf('                       [ function name string | function handle | {[]} ]\n');
fprintf('   MutationFcn          - The function used to mutate genomes\n');
fprintf('                       [ function name string | function handle | {[]} ]\n');
fprintf('   CrossoverFcn        - The type of genomic crossover used\n');
fprintf('                       [ function name string | function handle | {[]} ]\n');
fprintf('   CrossValidationFcn  - The type of cross-validation technique used\n');
fprintf('                       [ function name string | function handle | {[]} ]\n');
fprintf('   CrossValidationParam - Parameters of the cross-validation function\n');
fprintf('                       [Double vector | {[]} ]\n');
fprintf('   Elitism             - What percentage of parents should be passed down\n');
fprintf('   \t\t\tunchanged to the next generation.\n');
fprintf('                       [ positive scalar between 0-100 | {10} ]\n');
fprintf('   MutationRate       - Rate of ramndom mutations applied to children\n');
fprintf('                       [ positive scalar between 0-1 | {.06} ]\n');
fprintf('   OptDir             - The optimization direction, 0 - min, 1 - maximize\n');
fprintf('                       [ 1 | {0} ]\n');
fprintf('   OutputContent      - Specify the data stored in the output structure\n');
fprintf('                       Note: may increase computationally intensity\n');
fprintf('                       [ {''normal''} | ''detailed'' | ''debug'' ]\n');
fprintf('   PlotFcn             - The plotting function used for display\n');
fprintf('                       [ function name string | function handle | {[]} ]\n');
fprintf('   ErrorGradient       - The minimum improvement required to prevent error termination\n');
fprintf('                       [ positive scalar | {0.01} ]\n');
fprintf('   ErrorIterations      - The number of iterations over which the error change must be higher than the defined error gradient\n');
fprintf('                       [ positive integer | {10} ]\n');
fprintf('   FileName            - The file name used for output\n');
fprintf('                       [ string | {''AlgoGen.csv''} ]\n');
fprintf('   Parallelize         - Whether genome fitness operations should be parallelized.\n');
fprintf('                       [ logical | 0 | {1} ]\n');
fprintf('   NormalizeData       - Whether data should be normalized during training\n');
fprintf('                       [ logical | 0 | {1} ]');
fprintf('   NumFeatures         - Number of features present in data set\n');
fprintf('                       [ positive integer | {0} ]\n');
fprintf('   PopulationEvolutionAxe      - Axe handle to plot the population\n');
fprintf('   \t\t\tevolution over generations. Will be created if null.\n');
fprintf('                               [ axe handle | 0 | {0} ]\n');
fprintf('   FitFunctionEvolutionAxe      - Axe handle to plot the evolution\n');
fprintf('   \t\t\tof fit function value over generations. Will be created if null.\n');
fprintf('                               [ axe handle | 0 | {0} ]\n');
fprintf('   CurrentPopulationAxe         - Axe handle to plot the current\n');
fprintf('   \t\t\tpopulation. Will be created if null.\n');
fprintf('                               [ axe handle | 0 | {0} ]\n');
fprintf('   CurrentScoreAxe             - Axe handle to plot the performence of\n');
fprintf('   \t\t\tthe best genome from the current generation. PlotFcn is the function\n');
fprintf('   \t\t\tused to update this axe. Will be created if null.\n');
fprintf('                               [ axe handle | 0 | {0} ]\n');

end

