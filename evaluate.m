function [ SCORE_test SCORE_train  ] = evaluate( OriginalData , data_target , parents, options )

fitFcn=options.FitnessFcn; 
costFcn=options.CostFcn;
xvalFcn=options.CrossValidationFcn;

P=size(parents,1);
SCORE_test=zeros(P,1);
SCORE_train=zeros(P,1);

% For each individual
for individual=1:P
    % If you want to remove multiples warnings
    warning off all
    
    % Convert Gene into selected variables
    FS = parents(individual,:)==1;
    % If enough variables selected to regress               
    if sum(FS)>0        
        % RUN PCA if needed to avoid linear correlation between input
        % variables
        DATA = OriginalData(:,FS);
%         model = pca(DATA',0.01); % 1% variance is discarded only
                                 % enough to avoid direct linear relation                       
%         DATA = linproj(DATA',model);
        
        % 
        [ Stest, Strain ]  = feval(fitFcn,DATA,data_target,costFcn);
        
        % ...and get the results on TEST and TRAIN set 
        SCORE_test(individual) =  nanmean(Stest );
        SCORE_train(individual) =  nanmedian(Strain );
        
    else
        SCORE_test(individual) = 0 ;
        SCORE_train(individual) = 0 ;
    end
end



