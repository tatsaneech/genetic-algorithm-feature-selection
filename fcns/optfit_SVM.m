function [ opt  ] = optfit_SVM
% Generates a default structure for the fitness function fit_SVM
%   [ opt  ] = optfit_SVM

%TODO: allow more options, this only really works for RBF

opt=struct('Kernel_Function', 'rbf', ...
        'RBF_Sigma', 1, ...
        'Method', 'SMO',...
        'handle', str2func([matlabroot '/toolbox/bioinfo/biolearning/svmtrain'])); % function handle for the bioinformatics svmtrain
   
end