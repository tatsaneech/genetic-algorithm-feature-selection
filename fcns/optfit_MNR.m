function [ opt ] = optfit_MNR
% Generates a default structure for the fitness function fit_MNR
%   [ opt  ] = optfit_MNR

opt=struct('model', 'nominal', ...
        'interactions', 'on', ...
        'link', 'logit',...
        'estdisp', 'off');

end
