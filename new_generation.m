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
% Pass down the X% best performers to the next generation 
elderly = parent( BestPerfAIdx(1:POP_elite) , : ) ; 
% Select the 1st half of the population to undergo cross-over
repro = parent( BestPerfAIdx(1:POP_xover) , : ) ;


%% Cross-over
[ children ] = feval(crsovFcn, repro );

%% Mutation
[ children ] = feval(mutFcn, children, [mutation_prop, mutation_rate]);

%% Make sure that we keep below MaxVar and that confounding factors are
% still included
if MaxVar~=0 % Ensure number of features < MaxVar
    for p=1:2*POP_xover % TODO: Vectorize
        tbr = 1;
        while tbr~=0
            children(p,ConfFact) = 1; % Force confounding factors        
            tbr = sum(children(p,:)) - MaxVar; % tbr = # of excess features
            if tbr>0 % Reduce # features
                idx = find(children(p,:)==1);
                idx_tbr = idx(1+floor(length(idx)*rand(1,1)));
                children(p,idx_tbr) = 0 ;            
            elseif tbr<0 % Increase # features
                idx = find(children(p,:)==0);
                idx_tbr = idx(1+floor(length(idx)*rand(1,1)));
                children(p,idx_tbr) = 1 ;
            end

        end
    end
else % No maximum set for number of features
    % Force confounding factors     
    children(:,ConfFact)=true(size(children,1),length(ConfFact));
end

%% Replace twins by aliens
twins = zeros(POP_xover,1);
nonTwinIdx=true(2*POP_xover,1);
% twinCmpFcn=@(children,i) any(sqrt(sum((children(i,:)-children(1:i-1,:)).^2))==0);
for i = 1:2*POP_xover
    tmpValue=bsxfun(@minus,children(1:i-1,:),children(i,:));
    twins(i)=any(sqrt(sum(tmpValue.^2))==0);
end
if sum(twins)>0
    options.PopulationSize=sum(twins); % Temporary change.
    children(twins==1,:) = initialise_pop(VAR_NUM,options);
end

parent = [elderly ; children] ;
parent = parent(1:POP_SIZE,:);



        