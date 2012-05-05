function [ opt  ] = optfit_LR
% Generates a default structure for the fitness function fit_LR
%   [ opt  ] = optfit_LR

opt=struct('constant', 'off', ...
    'wfun', 'bisquare', ... % weighting function
    'tune', []); % tuning parameter


%=== Use defaults from statrobustfit if tune is not set above
if isempty(opt.tune)
    switch(opt.wfun)
        case 'andrews'
            t = 1.339;
        case 'bisquare'
            t = 4.685;
        case 'cauchy'
            t= 2.385;
        case 'fair'
            t = 1.400;
        case 'huber'
            t = 1.345;
        case 'logistic'
            t = 1.205;
        case 'ols'
            t = 1;
        case 'talwar'
            t = 2.795;
        case 'welsch'
            t = 2.985;
    end
    opt.tune=t;
end
end