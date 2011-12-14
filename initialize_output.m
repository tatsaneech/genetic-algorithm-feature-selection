function out = initialize_output(options)

out.EvolutionGenomeStats= cell(options.MaxIterations,options.Repetitions);
out.EvolutionBestCost= zeros(options.MaxIterations,options.Repetitions);
out.EvolutionBestCostTest= zeros(options.MaxIterations,options.Repetitions) ;
out.EvolutionMedianCost= zeros(options.MaxIterations,options.Repetitions);
out.BestGenomeStats= cell(1,options.Repetitions);
out.BestGenome= cell(1,options.Repetitions) ;
out.GenomePlot= cellfun(@(x) zeros(options.MaxIterations,options.NumFeatures),cell(1,options.Repetitions),'UniformOutput',false);
out.IterationTime= zeros(1,options.Repetitions);
out.CurrentIteration = 1;
out.CurrentRepetition = 1;