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
%                       [ 'Plot' | 'Text' | {'none'} ]
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
%   PlotFcn             - The plotting function used for display
%                       [ function name string | function handle | {[]} ]
%   ErrorGradient       - The minimum improvement required to prevent error termination
%                       [ positive scalar | {0.01} ]
%   ErrorIterations      - The number of iterations over which the error change must be higher than the defined error gradient
%                       [ positive scalar | {10} ]
%   FileName            - The file name used for output
%                       [ string | {'AlgoGen.csv'} ]
%   Parallelize         - Whether genome fitness operations should be parallelized.
%                       [ logical | 0 | {1} ]
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

if nargin==0 && nargout==0
    % TODO: display all field names with descriptions
    
    return;
else
    %=== create defaults
    options=struct( ...
        'Display', 'Plot', ...
        'MaxIterations', 100, ...
        'PopulationSize', 50, ...
        'MaxFeatures', 0, ...
        'MinFeatures', 0, ...
        'ConfoundingFactors', [], ...
        'Repetitions', 100, ...
        'OptDir', 0, ...
        'FitnessFcn', 'fit_LR', ...% This should have the exact same name as the .m function
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

%=== allowed parameters
okargs=fieldnames(options);
numargs=length(varargin);

if nargin==0
    return;
end

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
        %         pname = fn{s};
        %         pval = varargin{k}.(fn{s});
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
    
    % COMMENT: Louis July 1st 11 : The next 3 lines are converting
    % the string indicating the confounding variables in the GUI to
    % some readable format. ->Not sure this should go here<-
    
    %TODO: Make sure command line input style (linear indices) and
    %GUI input style (label titles) work seemlessly here
    %Additionally, allow for both input types!
    if strcmp(pname,'ConfoundingFactors')
        if iscell(pval) % Assumed GUI input - cell array
            eval(['pval = ' pval{1}]);
        elseif isnumeric(pval)
            % TODO: Do something! Anything! Yes, let's buy a new car!
        end
    end
    
    %=== Check if parameter is of valid variable type
    [valid1,errmsg1]=validateParamType(pname,pval);
    %=== Check if parameter is one of a set of acceptable values
    [valid2,errmsg2]=validateParamIsSubset(pname,pval);
    
    if valid1==1 && valid2==1 % Everything is OK, don't panic.
        options.(pname)=pval;
    elseif valid2==2 % Parameter must be converted to function handle
        options.(pname)=str2func(pval);
    elseif valid2==0
        % Parameter is not one of a set of acceptable defaults
        error(sprintf('ga_opt_set:%s:invalidParamVal',mfilename),errmsg2);
    else
        % Parameter is not of the right type
        error(sprintf('ga_opt_set:%s:invalidParamVal',mfilename),errmsg1);
    end
end

end

function [valid, errmsg] = validateParamType(param, val)
valid=1; errmsg='';
if isempty(val) % Default used
    return;
end

switch param
    % Strings
    case 'Display'
        if ~ischar(val)
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a string with a valid three char extension.',param);
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
        % Doubles
    case {'CrossValidationParam'}
        if ~isnumeric(val)
            valid=0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric',param);
        end
        % Positive definite doubles
    case {'MaxFeatures','MinFeatures','MaxIterations','PopulationSize',...
            'Repetitions','InitialFeatureNum'}
        if ~isnumeric(val) || val<0
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric',param);
        end
        if abs(val-floor(val))>1e-15 % Not an integer
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric',param);
        end
        
        % Functions/Strings
        
    case {'ErrorGradient', 'ErrorIterations',...
            'MutationRate','Elitism'}
        if ~isnumeric(val) || val<0
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive integer',param);
        end
    case {'FitnessFcn','CrossoverFcn','PlotFcn','CostFcn','CrossValidationFcn','MutationFcn'}
        if ~ischar(val) && ~iscell(val) &&  ~isa(val,'function_handle')
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s',param);
        end
        % Booleans/Doubles
    case {'GUIFlag','Parallelize','OptDir','MinimizeFeatures'}
        if ~islogical(val) && ~(isnumeric(val) && (val==1 || val==0))
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a logical value, 0 or 1',param);
        end
        % Lists
    case {'ConfoundingFactors'}
        % TODO: check variables Idx within confounding factors are smaller
        % than the number of variables in data
        % For Confounding factors the input should look like '[1 3 4]' when
        % more than one factor or simply '2' when only one confounding
        % factor variable #2 in this case
        % This should be done in validateParamIsSubset in the AlgoGen.m function
        
        % Axe handles
    case {'PopulationEvolutionAxe','FitFunctionEvolutionAxe',...
            'CurrentPopulationAxe','CurrentScoreAxe'}
        % TODO check if the axe exists. If not: error
    case {'GUIFlag'}
        % Nothing to do here really
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

%=== Get pname
if regexp(pname,'Fcn') > 1
    %=== Parse function
    % Define allowable function types
    okfcns={'FitnessFcn', 'CrossoverFcn','MutationFcn','CrossValidationFcn','PlotFcn','CostFcn'};
    okfcns_abbr={'fit_*.m','crsov_*.m','mut_*.m','xval_*.m','plot_*.m','cost_*.m'};
    
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
    files = dir(fcn);
    
    % Get acceptable file names
    okpnames = arrayfun(@(x) x.name,files,'UniformOutput',false);
    
    %=== If pval is a function handle, get the field name
    if ischar(pval)
        pvalName = [pval '.m'];
    else
        pvalName = [func2str(pval) '.m'];
    end
    
    %=== Check if pname exists in file names
    idxPval = strcmp(okpnames,pvalName);
    if any(idxPval)
        if ischar(pval)
            valid=2; % Informs caller to convert char->function handle
        else
            valid=1;
        end
    else
        valid=0;
        errmsg='Function name provided does not match any found in local directory';
    end
else
    % No membership set, return normally
end

%TODO: Check xvalFcn and xvalParam are internally consistent
end

function [options] = validateConsistency(options)

paramsChecked = {'CrossValidationParam',...
    'MinFeatures',...
    'MaxFeatures',...
    'ConfoundingFactors'};

for k=1:length(paramsChecked)
    param = paramsChecked{k};
    pval = options.(param);
    switch param
        case 'CrossValidationParam'
            %=== Ensure cross validation parameters match function
            xvalFcn = func2str(options.CrossValidationFcn);
            switch xvalFcn
                case {'xval_Bootstrapping','xval_JackKnifing'}
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
        otherwise
            % Recite Acadian Poetry ... or do nothing, your choice!
    end
end
end

