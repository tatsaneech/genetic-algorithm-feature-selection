function [ children ] = mut_SP( children, mut_opts )
%mut_SP Performs a single point mutation on the given number of genomes
%using the given mutation rate

mutation_prop=mut_opts(1); mutation_rate=mut_opts(2);
POP_xover=size(children,1)/2;
% randomly select children to undergo mutation
toMutate = [ones(1,floor(mutation_prop*2*POP_xover)) zeros(1,floor(1-mutation_prop)*POP_xover)];
toMutate = toMutate(randperm(length(toMutate))) == 1 ;
children(toMutate,:) = mutation_idex_bin( children(toMutate,:) , mutation_rate );


end