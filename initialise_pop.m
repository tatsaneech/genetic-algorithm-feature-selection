function parents = initialise_pop(POPULATION,options,Nbre_tot_var)
% Note (Louis Mayaud July-1st-11: Var model could be negative indicating
% that the model should be VarModel and exactly it where a positive value
% would set the higher value of the model size  )
% Note (Alistair Sept-14-11: I have no idea what the above means.)
%
%   Variable list
%       POPULATION - Number of genomes to generate
%       Nbre_tot_var - Number of dimensions of each genome
%       options.NumActiveFeatures - Number of true values in each genome
%       options.ConfoundingFactors - Numeric indices of flags in genomes which must be true
%           (forcably included features)

if isempty(options.NumActiveFeatures) || options.NumActiveFeatures == 0
     % default true values to square root of total dimension
    options.NumActiveFeatures = round(sqrt(Nbre_tot_var));
elseif options.NumActiveFeatures < 0
    % flip the negative
    options.NumActiveFeatures = - options.NumActiveFeatures ;
end

% Initialize population
parents = zeros(POPULATION,Nbre_tot_var-length(options.ConfoundingFactors));

% Generate vector with "options.NumActiveFeatures" true values
tmp = [ones(1,options.NumActiveFeatures-length(options.ConfoundingFactors)) zeros(1,Nbre_tot_var-options.NumActiveFeatures)];
for i=1:POPULATION
    % Randomly assign "options.NumActiveFeatures" true values in the population
    parents(i,:) = tmp(randperm(Nbre_tot_var-length(options.ConfoundingFactors)));
end        


if ~isempty(options.ConfoundingFactors)
%     % Generate an index array which excludes confounding factors
%     CF=1:Nbre_tot_var;
%     CF(options.ConfoundingFactors)=[];
    
%     final_parents(:,CF) = parents ; 
    parents(:,options.ConfoundingFactors) = ones(POPULATION,length(options.ConfoundingFactors));
else
    % do nothing    
end

