function [ opt ] = optfit_BinomialGLM
% Generates a default structure for the fitness function fit_BinomialGLM
%   [ opt  ] = optfit_BinomialGLM 

opt=struct('distribution', 'binomial', ...
        'link', 'logit', ...
        'constant', 'off',...
        'estdisp', 'off');

end