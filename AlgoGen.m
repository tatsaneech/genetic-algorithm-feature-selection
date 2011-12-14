function [out,options] = AlgoGen(DATA, outcome, options)
% [out,options] = AlgoGen(DATA, outcome, options)
%       DATA - NxD double matrix containing N observations and D dimensions (N rows, D columns)
%       outcome - Nx1 double or logical array containing N observations.
%       options - Options specified by function ga_opt_set

addpath('./stats'); % ensure stats is in the path

%% Initialisation
%=== Initialize options
if nargin < 3
    options=ga_opt_set('GUIFlag',false);
else
    options=ga_opt_set(options,'GUIFlag',false);
end

verbose=true; % Set true to view time evaluations

% To add an option field, follow these steps:
%   Add to options in ga_opt_set (also add comment)
%   Add to subfunction ga_opt_set:validateParamType
%   If needed, add to subfunction ga_opt_set:validateParamIsSubset
% TODO: Also document changes needed in GUI


[Nbre_obs,Nbre_var]=size(DATA);

[DATA, outcome] = errChkInput(DATA, outcome, options);

%TODO: Remove this and directly reference out.BestGenomeStats
% Initialise visualization variable
im = zeros(options.MaxIterations,Nbre_var,options.Repetitions);

%TODO: Create initialize_plot function which sets up GUI figures depending
%on which plot_* is used (this will allow the algorithm to only plot, for
%example, a ROC curve when that is all that is desired)

if strcmpi(options.Display,'plot')
    if isempty(options.PopulationEvolutionAxe)
        % If axes are empty, then the GUI is not used, must set up figure
        h=figure;
        subplot(3, 2 , [1 2]);
        colormap('gray');
        title(['Selected variables'],'FontSize',16);
        ylabel('Variables','FontSize',16);
        options.PopulationEvolutionAxe = gca;
        
        subplot(3, 2 , [3 4] );
        xlabel('Generations','FontSize',16);
        ylabel('Mean cost','FontSize',16);
        options.FitFunctionEvolutionAxe = gca;
        
        
        subplot(3, 2 , 5); % ROC
        xlabel('Sensitivity'); ylabel('1-Specificity');
        options.CurrentScoreAxe = gca;
        
        subplot(3, 2 , 6);
        xlabel('Variables','FontSize',16);
        ylabel('Genomes','FontSize',16);
        title('Current Population','FontSize',16);
        options.CurrentPopulationAxe = gca;
    else
        h=gcf;
    end
end

% min or maximize cost
if options.OptDir==1
    sort_str='descend';
else
    sort_str='ascend';
end

% parallelize?
if options.Parallelize==1
    evalFcn=@evaluate_par;
else
    evalFcn=@evaluate;
end

% Initialize outputs
out = initialize_output(options);

repTime=0;
for tries = 1:options.Repetitions
    %% Initialise GA
    % Create a random population of genomes with :
    % - options.PopulationSize genomes
    % - Nbre_var genes per genome
    % - options.NumActiveFeatures activated genes per genomes
    % - options.ConfoundingFactors genes (variables) having these indexes being
    % activated by default
    
    parent = initialise_pop(Nbre_var,options);
    
    % Reset repetition counters/sentinel flags
    ite = 0; early_stop = false; iteTime=0;
    
    % Calculate indices for training repetitions for each genome
    [ train, test, KI ] = feval(options.CrossValidationFcn,outcome,options);
    
    while ite < options.MaxIterations && ~early_stop
        tic;
        ite = ite + 1;
        if ite>(options.ErrorIterations+1) % Enough iterations have passed
            win = out.EvolutionBestCostTest((ite-(options.ErrorIterations+1)):(ite-1));
            if abs(max(win) - min(win)) < options.ErrorGradient
                early_stop = true ;
            end
        end
        
        %% Evaluate parents are create new generation
        [PerfA] = feval(evalFcn,DATA,outcome,parent,options , train, test, KI);
        % TODO:
        %   Change eval function to return:
        %       model, outputs with predictions+indices, statistics
        
        parent = new_generation(parent,PerfA,sort_str,options);
        
        %% FINAL VALIDATION
        % If tracking best genome statistics is desirable during run-time,
        % this section will have to recalculate the genome fitness, etc.
        FS = parent(1,:)==1;
        [aT,aTR] = evaluate(DATA,outcome,FS,options,train,test,KI); % 1 individual - do not need to parallelize
        
        out.EvolutionBestCost(ite,tries) = aTR;
        out.EvolutionBestCostTest(ite,tries) = aT ;
        out.EvolutionMedianCost(ite,tries) = nanmedian(PerfA);
        
        %% Save and display results
        %%-------------------------+
        im(ite,:,tries)=FS;
        if strcmpi(options.Display,'plot')
            
            [~,~,out.EvolutionGenomeStats{ite,tries}] = ...
                evaluate(DATA, outcome, parent(1,:), options , train, test, KI);
            [ out ] = plot_All( out, im, parent, h, options );
            
        end
        
        iteTime=iteTime+toc;
        repTime=repTime+toc;
        if verbose % Time elapsed reports
            fprintf('Iteration %d of %d. Time: %2.2fs. Total Time: %2.2fs. Projected: %2.2fh. \n',...
                ite,options.MaxIterations, toc, iteTime,...
                (((iteTime/ite * (options.MaxIterations) * (options.Repetitions)))-repTime)/3600);
        end
        
        out.CurrentIteration=out.CurrentIteration+1;
    end
    out.GenomePlot{1,tries}=im(:,:,tries);
    % TODO: Add error checks if outcome = -1,1 instead of outcome = 0,1
    [~,~,out.BestGenomeStats{1,tries}] = evaluate(DATA, outcome, parent(1,:), options , train, test, KI);
    out.BestGenome{1,tries} = parent(1,:)==1;
    out.IterationTime(1,tries)=iteTime/options.MaxIterations;
    out.RepetitionTime(1,tries)=repTime/tries;
    % Save results
    if ~isempty(options.FileName) % If a file has been selected for saving
        export_results( options.FileName , out , handles.labels , options );
    end
    out.CurrentRepetition=out.CurrentRepetition+1;
    
end


end