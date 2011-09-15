function pop = mutation_idex(pop,mut)

% fonction qui effectue la mutation sur l'individu 'ind' et qui renvoie 'ind_mut', l'individu mut�


cpt=0;

s = size(pop,2) ;
nbre_to_mute = round(s* mut) ;

% For each individual
for i=1:size(pop,1)
    var_to_mute = [ ones(1,nbre_to_mute) zeros(1 , s - nbre_to_mute) ] ;
    var_to_mute = var_to_mute( randperm(length(var_to_mute)) ) ;
    pop(i,var_to_mute==1) = ~pop(i,var_to_mute==1);        
end