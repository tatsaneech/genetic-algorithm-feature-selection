function [ children ] = mut_SP( children, mut_opts )
%mut_SP Performs a single point mutation on the given number of genomes
%using the given mutation rate

% Declare parameters
mutation_prop=mut_opts(1); mutation_rate=mut_opts(2);
POP_xover = size(children,1);

% randomly select children to undergo mutation
toMutate = [ones(1,floor(mutation_prop*POP_xover)) zeros(1,floor((1-mutation_prop)*POP_xover))];
toMutate = toMutate(randperm(length(toMutate))) == 1 ;
children(toMutate,:) = mutation_idex_bin( children(toMutate,:) , mutation_rate );


function pop = mutation_idex_bin(pop,mut)

% For each individual
for i=1:size(pop,1)

    active = find(pop(i,:)==1);
    inactive = find(pop(i,:)==0);
    % Create mixed vector that alternates active and inactive genes locations.
    % Then we can mute an equivalent number of active/inactive genes.
    % Because of the nature of feature selection problem, it is likely
    % otherwise that more and more features are going to be selected with
    % mutations
    mix(1:2:(2*length(active)-1)) = active(randperm(length(active))) ;
    mix(2:2:2*length(inactive)) = inactive(randperm(length(inactive))) ;
    mix(mix==0)=[];
        
    nbre_to_mute =  round(length(active)* mut) ; % the mutation rate is applied to the number of positive
    pop(i,mix(1:nbre_to_mute)) = ~pop(i,mix(1:nbre_to_mute));        
    
    
    
end

