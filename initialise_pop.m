function parents = initialise_pop(Nbre_tot_var,options)
% Note (Louis Mayaud July-1st-11: Var model could be negative indicating
% that the model should be VarModel and exactly it where a positive value
% would set the higher value of the model size  )
% Note (Alistair Sept-14-11: I have no idea what the above means.)
%
%   Variable list
%       Nbre_tot_var - Number of dimensions of each genome
%       options.PopulationSize - Number of genomes to generate
%       numFeatures - Number of true values in each genome
%       options.ConfoundingFactors - Numeric indices of flags in genomes which must be true
%           (forcably included features)

if options.MaxFeatures == options.MinFeatures
    % forced number of features
    numFeatures=options.MaxFeatures;
else
    % default true values to square root of total dimension
    numFeatures = round(sqrt(Nbre_tot_var));
    
    % Check to ensure this is does not violate min/max
    if numFeatures>options.MaxFeatures
        numFeatures=options.MaxFeatures;
    elseif numFeatures<options.MinFeatures
        numFeatures=options.MinFeatures;
    end
end

% Initialize population
parents = zeros(options.PopulationSize,Nbre_tot_var);

% Generate vector with "numFeatures" true values
tmp = [ones(1,numFeatures) zeros(1,Nbre_tot_var-numFeatures)];
for i=1:options.PopulationSize
    % Randomly assign "numFeatures" true values in the population
    % TODO: Vectorize this.
    parents(i,:) = tmp(randperm(Nbre_tot_var));
end        


if ~isempty(options.ConfoundingFactors) && (length(options.ConfoundingFactors)>1 || options.ConfoundingFactors==0)
    % Force confounding factors
    parents(:,options.ConfoundingFactors) = ones(options.PopulationSize,length(options.ConfoundingFactors));
else
    % do nothing    
end

