function [ opt ] = optfit_LR_Evidence
% Generates a default structure for the fitness function fit_LR_Evidence
%   [ opt  ] = fit_LR_Evidence 

opt=struct('Distribution', 'binomial', ...
        'link', 'logit', ...
        'constant', 'off',...
        'estdisp', 'off');

end
