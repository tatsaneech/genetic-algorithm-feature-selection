
function [out,options] = AlgoGen(DATA, outcome, options)
% [out,options] = AlgoGen(DATA, outcome, options)
%       DATA - NxD double matrix containing N observations and D dimensions (N rows, D columns)
%       outcome - Nx1 double or logical array containing N observations.
%       options - Options specified by function ga_opt_set

%% Initialisation
if nargin <3
    options=ga_opt_set;
end

verbose=true; % Set true to view time evaluations
totTime=0;

% Define main parameters
[options] = ...
    parse_inputs(options);
    % COMMENT Louis 1st July 2011 : Why not parsing parameters and
    % functions handles when initializing/defining the options?
    
    % COMMENT Alistair 14 Sep 2011 : ga_opt_set checks the parameters are
    % valid and defaults undefined to []. parse_inputs makes sure they are 
    % internally consistent: i.e., ConfFact < Nbre_tot_var, etc
    %
    % To add an option field, follow these steps:
    %   Add to options in ga_opt_set (also add comment)
    %   Add to check_args subfunction in ga_opt_set
    %   Add to def_opt in parse_options (in AlgoGen.m)
    %   If it is a new type of sub-function, you will also need to 
    %       add it to parse_functions (in AlgoGen.m)

Nbre_var=size(DATA,2);

if strcmpi(options.Display,'plot')
 %   close all
    % Initialise visualization variable
    im = [];
%    h = figure;
end

% min or maximize cost
if options.OptDir==1
    min_or_max=@max;
    sort_str='descend';
else
    min_or_max=@min;
    sort_str='ascend';
end

% parallelize?
if options.Parallelize==1
    evalFcn=@evaluate_par;
else
    evalFcn=@evaluate;
end

% Initialize outputs
    out.EvolutionBestCost = zeros(options.MaxIterations,options.Repetitions);
    out.EvolutionBestCostTest = zeros(options.MaxIterations,options.Repetitions) ;
    out.EvolutionMedianCost = zeros(options.MaxIterations,options.Repetitions);
    out.BestGenomeStats = cell(1,options.Repetitions);
    out.BestGenome = cell(1,options.Repetitions) ;
    out.GenomePlot=cell(1,options.Repetitions);
    
for tries = 1:options.Repetitions
    %% Initialise GA
    % Create a random population of genomes with :
    % - options.PopulationSize genomes
    % - Nbre_var genes per genome
    % - options.NumActiveFeatures activated genes per genomes
    % - options.ConfoundingFactors genes (variables) having these indexes being
    % activated by default
    
    parent = initialise_pop(options.PopulationSize,options,Nbre_var);
    
    % Check if early-stop criterion is met
    % if not: continue
    ite = 0 ; early_stop = false ; im=[];
    while ite < options.MaxIterations && early_stop == false
        tic;
        ite = ite + 1;
        if ite>(options.ErrorIterations+1) % Enough iterations have passed
            win = out.EvolutionBestCost((ite-(options.ErrorIterations+1)):(ite-1));
            if abs(max(win) - min(win)) < options.ErrorGradient
                early_stop = true ;
            end
        end
        
        %% Evaluate parents are create new generation
        [PerfA] = feval(evalFcn,DATA,outcome,parent, options);
        parent = new_generation(parent,PerfA,sort_str,options);
        
        %% FINAL VALIDATION
        % Removed redundant calculation in this section.
        % If tracking best genome statistics is desirable during run-time,
        % this section will have to recalculate the genome fitness, etc.
        FS = parent(1,:)==1;
        %FIXME: Why is the below hack necessary?
        if sum(FS)==0 % ensure parents with 0 features are disabled
            aT=min_or_max([0,9999]);
            aTR=min_or_max([0,9999]);
        end
        [aT,aTR] = evaluate(DATA,outcome,FS,options);
       
        out.EvolutionBestCost(ite,tries) = feval(min_or_max,aTR) ;
        out.EvolutionBestCostTest(ite,tries) = feval(min_or_max,aT) ;
        out.EvolutionMedianCost(ite,tries) = nanmedian(aT);
        
        %% Save and display results
        %%-------------------------+
        im = [im ; FS];
        if strcmpi(options.Display,'plot')
            %             saveas(h,['AG-current_' int2str(patient_type) '.jpg'])
            set(gcf,'CurrentAxes',options.PopulationEvolutionAxe) ; 
            %subplot(3, 2 , [1 2]);
            imagesc(~im');
            colormap('gray');
            title([int2str(sum(FS)) ' selected variables'],'FontSize',16);
            ylabel('Variables','FontSize',16);
            set(gcf,'CurrentAxes',options.FitFunctionEvolutionAxe);
            %subplot(3, 2 , [3 4] );
            plot(1:ite ,out.EvolutionBestCost(1:ite,tries) ,  1:ite ,out.EvolutionMedianCost(1:ite,tries) );
            xlabel('Generations','FontSize',16);
            ylabel('Mean AUC','FontSize',16);
            legend('Best','Median','Location','NorthWest'); %'RMSE train','AUC' ,
            set(gcf,'CurrentAxes',options.CurrentScoreAxe);
            % TODO Get the plot function hangle and plot
            %subplot(3, 2 , 5);
            %  plot_ROC(img,AUC) ;
            %subplot(3, 2 , 6);
            set(gcf,'CurrentAxes',options.CurrentPopulationAxe);
            imagesc(~parent);
            xlabel('Variables','FontSize',16);
            ylabel('Genomes','FontSize',16);
            title('Current Population','FontSize',16);
            pause(0.5);
        end
        %
        %         auc = mean(AUC) ;
        %         if auc>80
        %             eval(['save RAMB_MODELDIM_' num2str(floor(options.NumActiveFeatures),'%d') '_AUC_' num2str(floor(auc),'%d') '.mat FS AUC']);
        %         end
        totTime=totTime+toc;
        if verbose
            fprintf('Iteration %d of %d. Time: %2.2f. Total Time: %2.2f. \n',...
                ite,options.MaxIterations,toc, totTime);
        end 
    end
    out.GenomePlot{1,tries}=im;
    [~,~,out.BestGenomeStats{1,tries}] = feval(options.FitnessFcn,DATA(:,parent(1,:)==1),outcome,options.CostFcn);
    out.BestGenome{1,tries} = parent(1,:)==1;

    % COMMENT : Louis Mayaud July-1st-11 :  I think the next 4 lines should
    % be removed
        if strcmpi(options.Display,'plot')
%             figure(h);
%             subplot(3, 2 , 5);

%             plot(out.BestGenomeStats{1,tries}.;
        end
    % Save results
    if ~strcmpi(options.Display,'none')
        fid=fopen(options.FileName,'w');
        fprintf(fid,'%.2f\t',min(PerfA));
        fprintf(fid,'%.2f\t',nanmedian(aT(:,1)));
        fprintf(fid,'%d\t',ite);
        for v=1:length(FS)
            if FS(v)==1
                fprintf(fid,'%d\t', 1 );
            else fprintf(fid,'\t');
            end
        end
        fprintf(fid,'\n');
        fclose(fid);
    end
    toc
    
    
end
end

function [options] = ...
    parse_inputs(options)
% Parse input PV pairs.

%=== allowed parameters
okargs=fieldnames(options);

%=== defaults
def_options=struct( ...
        'Display', 'Plot', ...
        'MaxIterations', 100, ...
        'PopulationSize', 50, ...
        'NumActiveFeatures', [], ...
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
        'FileName','AlgoGenOutput.csv', ...
        'Parallelize', 0, ...
        'Elitism',10 , ...
        'PopulationEvolutionAxe', [],...
        'FitFunctionEvolutionAxe', [],...
        'CurrentPopulationAxe', [],...
        'CurrentScoreAxe', []...
        );
    
def_fn=fieldnames(def_options);

%=== parse inputs, replace empty fields with default values
for k = 1:length(def_fn)
    idx=strcmp(okargs,def_fn{k});
    if isempty(options.(okargs{idx}))
        options.(okargs{idx})=def_options.(okargs{idx});
    end
end


% Parse functions
opt_fn=fieldnames(options);
fcn_idx=strfind(opt_fn, 'Fcn'); % Find field names which store functions
fcn_idx=find(cellfun(@(x) ~isempty(x),fcn_idx)==1);
for k=1:length(fcn_idx)
    % Parse functions into cells containing function handles    
    [options.(opt_fn{fcn_idx(k)})] = ...
        parse_functions(opt_fn{fcn_idx(k)},options.(opt_fn{fcn_idx(k)}));
end

%TODO: Check xvalFcn and xvalParam are internally consistent
end

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
