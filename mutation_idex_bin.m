function pop = mutation_idex(pop,mut)

% fonction qui effectue la mutation sur l'individu 'ind' et qui renvoie 'ind_mut', l'individu mut�

cpt=0;

s = size(pop,2) ;
nbre_to_mute = round(s* mut) ;

% For each individual
for i=1:size(pop,1)

    active = find(pop(i,:)==1);
    inactive = find(pop(i,:)==0);
    % Create mixed vector alterning active and inactive genes locations so
    % that we can mute an equivalent number of active/inactive genes.
    % Because of the nature of feature selection problem, it is likely
    % otherwise that more and more features are going to be selected with
    % mutation
    mix(1:2:(2*length(active)-1)) = active(randperm(length(active))) ;
    mix(2:2:2*length(inactive)) = inactive(randperm(length(inactive))) ;
    mix(mix==0)=[];
        
    pop(i,mix(1:nbre_to_mute)) = ~pop(i,mix(1:nbre_to_mute));        
    
    
    
end