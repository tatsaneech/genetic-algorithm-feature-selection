% --------------------------------------------------- %
% --------------------------------------------------- %
% Parses functions, including translating strings into function handles
function [fcn] = ...
    parse_functions(fcn_type,fcn)

% % NEW VERSION OF THE FUNCTION RIGHT HERE
% if ~isa(fcn,'function_handle')
%     if iscell(fcn)
%         fcn=fcn{1};
%     end
%     eval(['fcnH=@' fcn ';' ]);
% end

% allowable function types
okfcns={'FitnessFcn', 'CrossoverFcn','MutationFcn','CrossValidationFcn','PlotFcn','CostFcn'};
okfcns_abbr={'fit_.*.m$','crsov_.*.m$','mut_.*.m$','xval_.*.m$','plot_.*.m$','cost_.*.m$'};

% Scan files and find specific functions
files = dir('*.m');

% fcn_strs will be a cell array, with each cell containing the file names
% corresponding to that function type

okfcn_strs=cell(1,length(okfcns));
% Fplot = {}; Ffit = {}; Fxval = {} ; Fcrsov = {}; Fmut = {};
for f=1:length(files)
    tmp=regexp(files(f).name,okfcns_abbr);
    tmp_idx=find(~cellfun(@isempty,tmp)==1,1);
    if ~isempty(tmp_idx) % Pattern exists and has been found in file name
        if tmp{tmp_idx}==1 % Ensure pattern is found at beginning of file name
            okfcn_strs{tmp_idx}=[okfcn_strs{tmp_idx};{files(f).name(1:(end-2))}];
        end
    end
end

% Parse inputs if in non-cell form, i.e. just one function type and name
if ~iscell(fcn_type) || ~iscell(fcn)
    if ~iscell(fcn_type) && ~iscell(fcn)
        % Convert to cells
        fcn_type={fcn_type}; fcn={fcn};
    else
        error(sprintf('Options:%s:IncorrectFunctionType',mfilename),...
            'Function type and string should be of the same data type (cell or char).');
    end
end

% If inputs are unequal in size, throw error
if length(fcn_type)~=length(fcn)
    error(sprintf('Options:%s:IncorrectNumberOfArguments',mfilename),...
        'Number of function handles must equal number of corresponding function types.');
end

lf=length(fcn_type); % number of functions

% for each passed function string
for k=1:lf
    fcn_idx=find(strcmpi(okfcns,fcn_type{k}));
    if isempty(fcn_idx)
        error(sprintf('Options:%s:IncorrectFunctionType',mfilename),...
            'Specified function type does not exist.');
        
    end
    fcn_strs=okfcn_strs{fcn_idx};
    fcn_handles=cell(1,length(fcn_strs));
    for q=1:length(fcn_strs)
        fcn_handles{q}=str2func(fcn_strs{q});
    end
    
    % If it's a nested cell, get cell contents
    if iscell(fcn_type{k})
        fcn_type(k)=fcn_type{k};
    end
    
    % convert from function handle to string
    if isa(fcn{k},'function_handle')
        fcn_cmp=cellfun(@(x) isequal(x,fcn{k}),fcn_handles);
        if max(fcn_cmp)==1
            continue; % next iteration
        end
        error(sprintf('Options:%s:IncorrectFunctionHandles',mfilename),...
            'Specified function handle does not exist.');
    end
    
    if ischar(fcn{k})
        fcn_idx=strcmpi(fcn_strs,fcn{k});
        if ~any(fcn_idx)
            % Function string not found
            error(sprintf('Options:%s:IncorrectFunctionString',mfilename),...
                'Specified function string does not exist.');
        else
            fcn{k}=fcn_handles{fcn_idx};
        end
    end
    
end

if lf==1 % Convert from cell with one element to function handle
    fcn=fcn{k};
end

end