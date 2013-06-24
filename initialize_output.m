function out = initialize_output(options)

%=== For clarity, declare a few variables here
maxIter = options.MaxIterations; % Number of iterations per genome run
rep = options.Repetitions; % Number of genome runs
numFeat = options.NumFeatures; % Number of features available
popSize = options.PopulationSize;

%=== Initialize options which are always output
out.Test.EvolutionBestCost = zeros(maxIter,rep); % out.EvolutionBestCostTest
out.Test.EvolutionMedianCost = zeros(maxIter,rep); % out.EvolutionMedianCost

out.Training.EvolutionBestCost = zeros(maxIter,rep);
out.Training.EvolutionMedianCost = zeros(maxIter,rep);
        
out.BestGenomeStats = cell(1,rep);
out.BestGenome = cell(1,rep) ;
out.BestGenomePlot = cellfun(@(x) zeros(maxIter,numFeat),cell(1,rep),'UniformOutput',false);
out.IterationTime = zeros(1,rep);
out.CurrentIteration = 1;
out.CurrentRepetition = 1;

%=== Plotting requires certain fields to be present
if strcmpi(options.Display,'plot')
    out.EvolutionGenomeStats = cell(maxIter,rep);
end

switch options.OutputContent
    case 'detailed'
        %=== Initialize additional out fields
        out.Training.BestGenomeStats = cell(1,rep);
        out.Test.BestGenomeStats = cell(1,rep);
        out.Model = cell(1,rep) ;
        
        out.EvolutionGenomeStats = cell(maxIter,rep);
    case 'debug'
        out.Model = cell(1,rep) ;
        %=== Initialize many additional out fields for debug purposes
        out.Genome = cellfun(@(x) false(popSize,numFeat,maxIter),...
            cell(1,rep),'UniformOutput',false);
        
        if ~isempty(options.Hyperparameters)
        nHyp = sum(structfun(@(x) x.bitsNeeded, options.Hyperparameters));
        out.Hyperparameters = cellfun(@(x) false(popSize,nHyp,maxIter),...
            cell(1,rep),'UniformOutput',false);
        end
        
        out.Training.EvolutionCost = zeros(maxIter,rep,popSize);
        out.Training.EvolutionBestStats = cell(maxIter,rep);
        
        out.Test.EvolutionCost = zeros(maxIter,rep,popSize);
        out.Test.EvolutionBestStats = cell(maxIter,rep);
        
    case 'normal'
        %=== No additional out fields required
end