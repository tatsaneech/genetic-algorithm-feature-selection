function out = initialize_output(options)

%=== For clarity, declare a few variables here
maxIter = options.MaxIterations; % Number of iterations per genome run
rep = options.Repetitions; % Number of genome runs
numFeat = options.NumFeatures; % Number of features available
popSize = options.PopulationSize;

%=== Initialize options which are always output
out.EvolutionGenomeStats= cell(maxIter,rep); %TODO: Should be in 'detailed'
out.EvolutionBestCost= zeros(maxIter,rep);
out.EvolutionBestCostTest= zeros(maxIter,rep) ;
out.EvolutionMedianCost= zeros(maxIter,rep);
out.BestGenomeStats= cell(1,rep);
out.BestGenome= cell(1,rep) ;
out.BestGenomePlot= cellfun(@(x) zeros(maxIter,numFeat),cell(1,rep),'UniformOutput',false);
out.IterationTime= zeros(1,rep);
out.CurrentIteration = 1;
out.CurrentRepetition = 1;

switch options.OutputContent
    case 'detailed'
        %=== Initialize additional out fields
        out.Training.EvolutionBestCost = zeros(maxIter,rep);
        out.Training.EvolutionMedianCost = zeros(maxIter,rep);
        out.Training.BestGenomeStats = cell(1,rep);
        
    case 'debug'
        %=== Initialize many additional out fields for debug purposes
        out.Genome = cellfun(@(x) false(popSize,numFeat,maxIter),...
            cell(1,rep),'UniformOutput',false);
        
        out.Training.EvolutionCost = zeros(maxIter,rep,popSize);
        out.Training.EvolutionBestStats = cell(maxIter,rep);
        
        out.Test.EvolutionCost = zeros(maxIter,rep,popSize);
        out.Test.EvolutionBestStats = cell(maxIter,rep);
        
    case 'normal'
        %=== No additional out fields required
end