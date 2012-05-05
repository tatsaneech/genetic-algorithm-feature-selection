function [ opt  ] = optfit_TEMPLATE
% Generates a default structure for the given fitness function
%   [ opt  ] = optfit_TEMPLATE outputs a structure which contains fields
%   used by the fitness function of the same name (without the 'opt'
%   prefix).
%
%   ENSURE you input sensible default values for each parameter, this
%   allows for better error checking in the GA function.

opt=struct('FieldName1', 0, ...
        'FieldName2', 'Value2', ...
        'FieldName3', false);
    
end