function parent = new_generation(parent,PerfA,sort_str,options)
% This function generate the next generation of individuals

MaxVar=options.NumActiveFeatures;
ConfFact=options.ConfoundingFactors;
crsovFcn=options.CrossoverFcn;
mutFcn=options.MutationFcn;
mutation_rate=options.MutationRate;

POP_SIZE = size(parent,1) ;
VAR_NUM = size(parent,2) ;
POP_elite = round( 0.1*POP_SIZE ) ;
POP_xover = round( 0.9*POP_SIZE/2 ) ;
children = zeros(2*POP_xover,VAR_NUM) ;
mutation_prop = .2 ; % TODO: Make this a parameter in options


%% Selection

% sort parent generation by increasing or decreasing performance
[BestPerfA  BestPerfAIdx] = sort(PerfA,sort_str);
% Pass down the 10% best performers to the next generation 
elderly = parent( BestPerfAIdx(1:POP_elite) , : ) ; 
% Select the 1st half of the population to undergo cross-over
repro = parent( BestPerfAIdx(1:POP_xover) , : ) ;


%% Cross-over
[ children ] = feval(crsovFcn, repro );

%% Mutation
[ children ] = feval(mutFcn, children, [mutation_prop, mutation_rate]);
%[ children ] = feval(@mut_SP, children, [.2, mutation_rate]); % Modified by Louis 1st-Jul-11

%% Make sure that we keep below MaxVar and that confounding factors are
% still included
if MaxVar~=0
    for p=1:2*POP_xover
        tbr = 1;
        while tbr~=0
            children(p,ConfFact) = 1; % Force confounding factors        
            tbr = sum(children(p,:)) - MaxVar;
            if tbr>0
                idx = find(children(p,:)==1);
                idx_tbr = idx(1+floor(length(idx)*rand(1,1)));
                children(p,idx_tbr) = 0 ;            
            elseif tbr<0
                idx = find(children(p,:)==0);
                idx_tbr = idx(1+floor(length(idx)*rand(1,1)));
                children(p,idx_tbr) = 1 ;
            end

        end
    end
else
    % Force confounding factors     
    children(:,ConfFact)=true(size(children,1),length(ConfFact));
end

%% Replace twins by aliens
twins = zeros(POP_xover,1);
for i = 1:2*POP_xover
    for j = 1:(i-1)
        if sqrt( sum( (children(i,:) - children(j,:)).^2 ) ) == 0
            twins(i) = 1 ;
        end
    end
end
if sum(twins)>0
    options.PopulationSize=sum(twins); % Temporary change.
    children(twins==1,:) = initialise_pop(VAR_NUM,options);
end

parent = [elderly ; children] ;
parent = parent(1:POP_SIZE,:);



        