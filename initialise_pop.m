function parents = initialise_pop(Nbre_tot_var,options)
% Note (Louis Mayaud July-1st-11: Nbre_tot_var could be negative integer indicating
% that the model should include Nbre_tot_var variables and exactly it, whereas a positive value
% would set Nbre_tot_var as the max number of variables to be included in the model. 
% Nbre_tot_var=0 would leave the choice of variables to the algortihm  )
%
%   Variable list
%       Nbre_tot_var - Number of dimensions of each genome
%           - positive integer sets the higher limit of number of
%                   variables to be included in the model
%           - 0 leaves the number of variables undefined and automatically
%                   setup by the algortihm
%           - negative integer set the exact number of variables and
%                   exactly it.
%       options.PopulationSize - Number of genomes to generate
%       numFeatures - Number of true values in each genome
%       options.ConfoundingFactors - Numeric indices of flags in genomes which must be true
%           (forcably included features)

if options.MaxFeatures == options.MinFeatures && options.MaxFeatures~=0 
    % forced number of features
    numFeatures=options.MaxFeatures;
else
    % default true values to square root of total dimension
    if options.InitialFeatureNum ~= 0
        numFeatures = options.InitialFeatureNum;
    else
        numFeatures = round(sqrt(Nbre_tot_var)); % certainly too arbitrary
    end
    % Check to ensure this is does not violate min/max
    if numFeatures>options.MaxFeatures && options.MaxFeatures~=0 
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

