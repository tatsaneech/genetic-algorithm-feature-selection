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
    % display all field names
    
    return;
else
    % create default options
    options=struct('Display', [], ...
        'MaxIterations', [], ...
        'PopulationSize', [], ...
        'MaxFeatures', [], ...
        'MinFeatures', [], ...
        'ConfoundingFactors', [], ...
        'Repetitions', [], ...
        'OptDir', [], ...
        'FitnessFcn', [], ...
        'CostFcn', [], ...
        'CrossoverFcn', [], ...
        'MutationFcn', [], ...
        'MutationRate', [], ...
        'CrossValidationFcn', [], ...
        'CrossValidationParam', [], ...
        'PlotFcn', [], ...
        'ErrorGradient', [], ...
        'ErrorIterations', [], ...
        'FileName', [], ...
        'Parallelize', [], ...
        'Elitism',[], ...
        'MinimizeFeatures',[],...
        'PopulationEvolutionAxe', [],...
        'FitFunctionEvolutionAxe', [],...
        'CurrentPopulationAxe', [],...
        'CurrentScoreAxe', []);
end

if nargin==0
    return;
end

%=== allowed parameters
okargs=fieldnames(options);
N=size(okargs,1);
numargs=length(varargin);

k=1; % Varargin index
% Check if first input is a structure
if isstruct(varargin{k})
    % Replace current options fields in options with old options
    
    k=k+1;
end


%=== check for the right number of inputs
if (k==1 && rem(nargin,2) == 1) || (k==2 && rem(nargin,2) == 0)
    error(sprintf('Options:%s:IncorrectNumberOfArguments',mfilename),...
        'Incorrect number of arguments to %s.',mfilename);
end

%=== parse inputs
while k<=numargs
    pname = varargin{k};
    pval = varargin{k+1};
    param = find(strcmpi(pname, okargs));
    if isempty(param) % Bad parameter name
        error(sprintf('Options:%s:UnknownParameterName', mfilename), ...
            'Unknown parameter name: %s.',pname);
    else % Add parameter to options
        % check if value is valid
        
        % COMMENT: Louis July 1st 11 : The next 3 lines are converting
        % the string indicating the confounding variables in the GUI to
        % some readable format. ->Not sure this should go here<-


        if strcmp(pname,'ConfoundingFactors') 
            eval(['pval = ' pval{1}]);
        end
        [valid,errmsg]=check_args(okargs{param},pval);
        if valid
            options.(okargs{param})=pval;
        else
            error(sprintf('Options:%s:invalidParamVal',mfilename),errmsg);
        end
    end
    k=k+2;
end

end

function [valid, errmsg] = check_args(param, val)
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
         % Louis July 6th 11 : Commented the whole thing because it crashed 
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
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive integer',param);
        end
    % Positive definite doubles
    case {'MaxFeatures','MinFeatures','MaxIterations','PopulationSize',...
            'ErrorGradient', 'ErrorIterations',...
            'MutationRate','Repetitions','Elitism'}
        if ~isnumeric(val) || val<0
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive integer',param);
        end
            
    % Functions/Strings
    case {'FitnessFcn','CrossoverFcn','PlotFcn','CostFcn','CrossValidationFcn','MutationFcn'}
        if ~ischar(val) && ~iscell(val) &&  ~isa(val,'function_handle')
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s',param);
        end
    % Booleans/Doubles
    case {'Parallelize','OptDir','MinimizeFeatures'}
        if ~islogical(val) && ~(isnumeric(val) && (val==1 || val==0))
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a logical value, 0 or 1',param);
        end
    % Lists
    case {'ConfoundingFactors'}
        % TODO check variables Idx within confounding factors are smaller
        % than the number of variables in data
        % For Confounding factors the input should look like '[1 3 4]' when
        % more than one factor or simply '2' when only one confounding
        % factor variable #2 in this case
        % This should be done in parse_inputs in the AlgoGen.m function
        
    % Axe handles
    case {'PopulationEvolutionAxe','FitFunctionEvolutionAxe',...
            'CurrentPopulationAxe','CurrentScoreAxe'}
        % TODO check if the axe exists. If not: error
    otherwise
        valid=0; 
        errmsg = sprintf('Unknown parameter field %s', param);
end

end

