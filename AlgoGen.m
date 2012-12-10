function [out,options] = AlgoGen(DATA, outcome, options)
% [out,options] = AlgoGen(DATA, outcome, options)
%       DATA - NxD double matrix containing N observations and D dimensions (N rows, D columns)
%       outcome - Nx1 double or logical array containing N observations.
%       options - Options specified by function ga_opt_set

addpath('./stats'); % ensure stats is in the path

%% Initialisation
%=== Initialize options
if nargin < 3
    options=ga_opt_set('GUIFlag',false,'NumFeatures',size(DATA,2));
else
    options=ga_opt_set(options,'GUIFlag',false,'NumFeatures',size(DATA,2));
end

verbose=true; % Set true to view time evaluations

% To add an option field, follow these steps:
%   Add to options in ga_opt_set (also add comment)
%   Add to subfunction ga_opt_set:validateParamType
%   If needed, add to subfunction ga_opt_set:validateParamIsSubset
% TODO: Also document changes needed in GUI

[DATA, outcome] = errChkInput(DATA, outcome, options);

%TODO: Create initialize_plot function which sets up GUI figures depending
%on which plot_* is used (this will allow the algorithm to only plot, for
%example, a ROC curve when that is all that is desired)

if strcmpi(options.Display,'plot')
    [h,options]=initialize_figure(options);
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

% Set up flags for output content
switch options.OutputContent
    case 'normal'
        ocDetailedFlag = false;
        ocDebugFlag = false;
    case 'detailed'
        ocDetailedFlag = true;
        ocDebugFlag = false;
    case 'debug'
        ocDetailedFlag = false;
        ocDebugFlag = true;
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
    
    parent = initialize_pop(options);
    [data,target, idxData] = initialize_data(DATA,outcome,options);
    
    % Reset repetition counters/sentinel flags
    ite = 0; early_stop = false; 
    iteTime=0; repTime=0;
    
    % Calculate indices for training repetitions for each genome
    [ train, test, KI ] = feval(options.CrossValidationFcn,target,options);
    
    tic;
    while ite < options.MaxIterations && ~early_stop
        ite = ite + 1;
        if ite>(options.ErrorIterations+1) % Enough iterations have passed
            win = out.Test.EvolutionBestCost((ite-(options.ErrorIterations+1)):(ite-1));
            if abs(max(win) - min(win)) < options.ErrorGradient
                early_stop = true ;
            end
        end
        
        %% Evaluate parents and create new generation
        [testCost, trainCost] = feval(evalFcn,data,target,parent,options , train, test, KI);
        % TODO:
        %   Change eval function to return:
        %       model, outputs with predictions+indices, statistics
        
        %=== Sort genome
        [testCost  idxTestSort] = sort(testCost,sort_str);
        trainCost = trainCost(idxTestSort,:);
        parent = parent(idxTestSort,:);
        
        %% FINAL VALIDATION
        % If tracking best genome statistics is desirable during run-time,
        % this section will have to recalculate the genome fitness, etc.
        
        FS = parent(1,:)==1;
        [out.Test.EvolutionBestCost(ite,tries),...
            out.Training.EvolutionBestCost(ite,tries),...
            miscOutputContent] ...
            = evaluate_final(data,target,FS,options,train,test,KI);
        
        out.Training.EvolutionMedianCost(ite,tries) = nanmedian(trainCost);
        out.Test.EvolutionMedianCost(ite,tries) = nanmedian(testCost);
        
        %% Save and display results
        %%-------------------------+
        out.BestGenomePlot{1,tries}(ite,:)=FS;
        
        if ocDetailedFlag
            %=== Detailed output            
            out.EvolutionGenomeStats{ite,tries} = miscOutputContent.TestStats;
            
        elseif ocDebugFlag
            %=== Debug output            
            out.Genome{1,tries}(:,:,ite) = parent; % Save current genome
        
            out.Training.EvolutionCost(ite,tries,:) = trainCost;
            out.Training.EvolutionBestStats{ite,tries} = miscOutputContent.TrainStats;
        
            out.Test.EvolutionCost(ite,tries,:) = testCost;
            out.Test.EvolutionBestStats{ite,tries} = miscOutputContent.TestStats;
            
        else
            %=== Normal output
        end
            
        %=== Plot results
        if strcmpi(options.Display,'plot')
            out.EvolutionGenomeStats{ite,tries} = miscOutputContent.TestStats;
            [ out ] = plot_All( out, parent, h, options );
        end
        
        %=== Calculate new genome
        parent = new_generation(parent,testCost,sort_str,options);
        
        %=== Update timing calculations + print info to command prompt
        iteTime=toc-iteTime;
        repTime=toc;
        
        if verbose % Time elapsed reports
            if tries>1
                expectedTime = mean(out.RepetitionTime(1:tries-1))/options.MaxIterations * (options.MaxIterations-ite) + ...
                    mean(out.RepetitionTime(1:tries-1))*(options.Repetitions-1);
            else
                expectedTime = repTime/ite * (options.MaxIterations-ite) + ... % time remaining this repetition
                    repTime/ite * (options.MaxIterations*(options.Repetitions-1)); % time in future repetitions
            end
            expectedTime = (expectedTime * options.Repetitions - repTime)/60/60;
            fprintf('Repetition %i of %i. Iteration %d of %d. Iter Time: %2.2fs. Time Elapsed: %2.2fs. Projected: %2.2fh.\n',...
                tries, options.Repetitions,...
                ite,options.MaxIterations, ...
                toc, ... % Time in iteration
                repTime, ... % Total time spent so far
                expectedTime);
        end
        out.CurrentIteration=out.CurrentIteration+1;
        
    end
    % TODO: Add error checks if target = -1,1 instead of target = 0,1
    out.BestGenome{1,tries} = parent(1,:)==1;
    out.IterationTime(1,tries)=iteTime/options.MaxIterations;
    out.RepetitionTime(1,tries)=repTime;
    out.BestGenomeStats{1,tries} = miscOutputContent.TestStats;
    
    % If the final iteration is less than the maximum, then we should
    % remove the extra pre-allocated genomes
    if size(out.BestGenomePlot{1,tries},1)>ite
        out.BestGenomePlot{1,tries}(ite+1:end,:)=[];
    end
        
    %=== Save results
    if ocDetailedFlag || ocDebugFlag
        %=== Outputs for both detailed and debug
        out.Model{1,tries} = miscOutputContent.model;
        
        %=== Indices
        idxTraining = idxData;
        idxTraining(idxData) = miscOutputContent.TrainIndex;
        idxTest = idxData;
        idxTest(idxData) = miscOutputContent.TestIndex;
        
        out.Training.Indices{1,tries} = idxTraining;
        out.Test.Indices{1,tries} = idxTest;
    end
    if ocDetailedFlag
        %=== Detailed output
        out.Training.BestGenomeStats{1,tries} = miscOutputContent.TrainStats;
        out.Test.BestGenomeStats{1,tries} = miscOutputContent.TestStats;
        
    elseif ocDebugFlag
        %=== Debug output
        % If the final iteration is less than the maximum, then we should
        % remove the extra pre-allocated genomes
        if size(out.Genome{1,tries},3)>ite
            out.Genome{1,tries}(:,:,ite+1:end) = []; % Delete empties
        end
    else
        %=== Normal output
    end
        
    if ~isempty(options.FileName) % If a file has been selected for saving
        export_results( options.FileName , out , handles.labels , options );
    end
    out.CurrentRepetition=out.CurrentRepetition+1;
    
end


end