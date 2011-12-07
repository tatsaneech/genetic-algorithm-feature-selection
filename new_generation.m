function parent = new_generation(parent,PerfA,sort_str,options)
% This function generate the next generation of individuals

MaxVar=options.MaxFeatures;
MinVar=options.MinFeatures;
ConfFact=options.ConfoundingFactors;
crsovFcn=options.CrossoverFcn;
mutFcn=options.MutationFcn;
mutation_rate=options.MutationRate;

POP_SIZE = size(parent,1) ;
VAR_NUM = size(parent,2) ;

POP_xover = POP_SIZE/2 ;
POP_elite = floor( (options.Elitism/100)*POP_SIZE ) ;

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

% Children currently contains the population without the elitist genomes

%% Make sure that confounding factors are still included + Max/Min vars

if ~isempty(ConfFact) && (length(ConfFact)>1 || ConfFact~=0)
    % Force confounding factors
    children(:,ConfFact)=true(size(children,1),length(ConfFact));
end
    
% TODO: Possible to save on processing time when MinFeat=MaxFeat ?

varSum=sum(children,2);
if MaxVar>0 % Ensure number of features < MaxVar
    % Find locations which have too many variables
    maxVarIdx=find((varSum>MaxVar) == 1);
    
    % Randomly select true bits to flip
    for k=1:length(maxVarIdx) % TODO: Good luck vectorizing this.
        kthChild=find(children(maxVarIdx(k),:)==1); % Indices of true bits
        [~,maxRandPerm] = sort(rand(1,varSum(maxVarIdx(k)))); % Random indices of true bits
        
        % The number of parameters we must flip ..
        nFlip=length(maxRandPerm)-MaxVar;
        
        % Do not flip confounding factors
        maxRandPerm=setdiff(maxRandPerm,ConfFact);
        
        
        if nFlip>=length(maxRandPerm) % Still have enough factors to flip
            children(maxVarIdx(k),kthChild(maxRandPerm(1:nFlip)))=0;
        else
            % Oh well, flip what we can and complain
            children(maxVarIdx(k),kthChild(maxRandPerm(1:end)))=0;
            warning('GA:AlgoGen:new_generation:Confounded', ...
                ['More confounding factors entered than maximally\n' ...
                'allowed features. The MaxFeatures parameter should\n' ...
                'be lowered.']);
        end
    end
    %         [trueBitsI,trueBitsJ]=ind2sub(size(children(maxVarIdx,:)),find(children(maxVarIdx,:)==1)); % Linear index
end

if MinVar>0 % Ensure number of features > MinVar
    % Find locations which have too few variables
    minVarIdx=find((varSum<MinVar) == 1);
    
    % Randomly select false bits to flip
    for k=1:length(minVarIdx) % TODO: Good luck vectorizing this.
        kthChild=find(children(minVarIdx(k),:)==0); % Indices of false bits
        [~,minRandPerm] = sort(rand(1,varSum(minVarIdx(k)))); % Random indices of false bits
        children(minVarIdx(k),kthChild(minRandPerm(1:MinVar-varSum(k))))=1;
    end
end

%% Replace twins by aliens
diff = ones(2*POP_xover,2*POP_xover);
% nonTwinIdx=true(2*POP_xover,1);
% twinCmpFcn=@(children,i) any(sqrt(sum((children(i,:)-children(1:i-1,:)).^2))==0);
for i = 1:2*POP_xover
    for j=(i+1):2*POP_xover
        diff(i,j) = sum((children(i,:)-children(j,:)).^2);
    end
end
[r,c] = find(diff==0);
twins = unique([r ; c]);
 
if length(twins)>0
    options.PopulationSize=length(twins); % Temporary change.
    children(twins,:) = initialise_pop(VAR_NUM,options);
end 

parent = [elderly ; children] ;
parent = parent(1:POP_SIZE,:);

end
