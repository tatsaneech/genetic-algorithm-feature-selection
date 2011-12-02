function out = initialize_output(options)

out.EvolutionGenomeStats= cell(options.MaxIterations,options.Repetitions);
out.EvolutionBestCost = zeros(options.MaxIterations,options.Repetitions);
out.EvolutionBestCostTest = zeros(options.MaxIterations,options.Repetitions) ;
out.EvolutionMedianCost = zeros(options.MaxIterations,options.Repetitions);
out.BestGenomeStats = cell(1,options.Repetitions);
out.BestGenome = cell(1,options.Repetitions) ;
out.GenomePlot=cell(1,options.Repetitions);
out.IterationTime=zeros(1,options.Repetitions);