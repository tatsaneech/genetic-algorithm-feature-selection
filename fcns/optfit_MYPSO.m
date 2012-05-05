function [ options  ] = optfit_MYPSO
% Generates a default structure for the fitness function fit_MYPSO
%   [ opt  ] = optfit_MYPSO

%PSO_OPT_SET Sets the options used in the particle swarm optimization.
%   pso_opt_set() displays the options available.
%
%   OPTIONS = pso_opt_set() creates a structure with default parameters
%
%   OPTIONS = pso_opt_set('PARAM1',VALUE1,'PARAM2',VALUE2,....) will create
%   a structure using default parameters. PARAMs specified in the input
%   will be assigned the corresponding VALUE.
%
%   OPTIONS = pso_opt_set(OLDOPTS,'PARAM',VALUE) will create a structure
%   using a prior options structure and reassigning fields corresponding to
%   the parameter value pairs.
%
%PSO_OPT_SET PARAMETERS

lbl = {'pafi','PRELOS2','gcs','age','female','white','black','latino','unable','elect','emerg','floor','oproom','ohosp','d1_hr','d1_map','d1_rr','d1_temp','d1_urine','d1_vent';};

% Initialize options
options=struct('Display',0,...% Iterations between updating display (0 = no display)
    'MaxIt',500,...% Maximum number of iterations
    'PopSize',24,...% Population Size/# of particles
    'LocalBest',2.05,...% local best acceleration constant
    'GlobalBest',2.05,...% global best acceleration constant
    'MinErrorGradient',5e-4,... % minimum improvement in error (gradient)
    'ErrorTermination',250,...  % Iterations before error gradient criterion termination
    'ErrorGoal',NaN,... % Error goal (NaN = unconstrained)
    'BoundaryMethod',1,...
    'Initialize',0,...
    'RangeType',0,...  % 0=initialize pop randomly, 1=seeded by user input
    'qf',1,...
    'mdl','cutoffs',...
    'PlotFcn','conv',...
    'PlotData','PSO',...
    'algcost','PSO_cstat',...
    'max_p',0,... % will be overwritten
    'max_v',0,... % will be overwritten
    'minmax',1,... % will be overwritten
    'D',2,... % will be overwritten
    'InitialInertiaWeight',0.9,...% Initial intertia weight
    'FinalInertiaWeight',0.4,... % final inertia weight
    'InertiaIterations',400,...  % Iteration when inertial weight at final value
    'InitialVelocityLimit',1,...
    'FinalVelocityLimit',0.2,...
    'VelocityLimitIterations',250);

options.lbl = lbl;
end