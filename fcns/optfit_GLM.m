function [ opt ] = optfit_GLM
% Generates a default structure for the fitness function fit_GLM
%   [ opt  ] = optfit_GLM 

opt=struct('Distribution', 'normal', ...
        'link', 'identity', ...
        'constant', 'off',...
        'estdisp', 'off');

end
