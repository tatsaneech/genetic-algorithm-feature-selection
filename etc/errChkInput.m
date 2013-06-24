
% --------------------------------------------------- %
% --------------------------------------------------- %
function [data, outcome] = ...
    errChkInput(data, outcome, options)

[Nbre_obs,Nbre_var]=size(data);

%=== Error check data
if Nbre_var > Nbre_obs
    if options.MaxFeatures==0
    warning('GAFS:AlgoGen:HighDimensionality', ...
        ['The data input has more features than observations. This may\n' ...
        'result in selection of more features than observations. \n' ...
        'You should use caution, and perhaps set the MaxFeatures field.']);
    elseif options.MaxFeatures > Nbre_var
        warning('GAFS:AlgoGen:HighMaxFeatures', ...
            ['The data input has more features than observations, and the\n' ...
            'MaxFeatures field is set higher than the number of observations.\n' ...
            'This may result in selection of more features than observations, \n' ...
            'causing an error. You should set the MaxFeatures field to a lower value.']);
    end
end

%=== Error check outcome
oSz = size(outcome);
if oSz(1) == 1
    outcome = outcome'; % column vector preferred
elseif oSz(2) == 1
    % Column vector is a good input, do nothing
else
    error('GAFS:AlgoGen:TooManyTargetVectors',...
        ['The target input has more than one vector of targets. \n' ...
        'Multinomial classification is currently unsupported.']);
end

uniqOut = unique(outcome);

if size(uniqOut,1) > 2
    % Not a binary classification problem
    warning('GAFS:AlgoGen:NotBinaryClassification', ...
        ['The target vector contains more than 2 possible values.\n' ...
        'Regression is not fully supported yet, and errors may occur.\n' ...
        'Buyer beware.']);
else
    if iscell(outcome)
        % Pick a random outcome as the positive outcome
        warning('GAFS:AlgoGen:UnspecifiedPositiveTarget', ...
            ['The target input does not have a clear positive target.\n' ...
            'You should perhaps set the outcome to a double vector of \n' ...
            'and negative targets (i.e., 0 and 1).']);
        
        fprintf('Positive target is assumed to be %s \n',uniqOut{1});
        
        outcome = double(strcmp(outcome,uniqOut{1}));
    elseif ischar(outcome)
        % Pick a random outcome as the positive outcome
        warning('GAFS:AlgoGen:UnspecifiedPositiveTarget', ...
            ['The target input does not have a clear positive target.\n' ...
            'You should perhaps set the outcome to a double vector of \n' ...
            'and negative targets (i.e., 0 and 1).']);
        
        fprintf('Positive target is assumed to be %s \n',uniqOut(1,:));
        
        outcome = double(arrayfun(@(x) strcmp(x,uniqOut(1,:)),outcome));
    elseif islogical(outcome)
        outcome = double(outcome);
        
    elseif isnumeric(outcome) % isdouble() just crashes here so replaced with isnumeric()
        % Assume higher outcome is positive class
        outcome = double(outcome > min(uniqOut));
    else
        error('GAFS:AlgoGen:UnknownTargetType', ...
            'The target input should be of type cell, char, logical, or double.');
    end
end

end