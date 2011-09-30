function [ out, roc ] = ga_stats( pred, target, statsDesired )
%ga_stats Given predictions and targets, calculates the statistics
%specified in cell array of strings "statsDesired".
%   [ out ] = ga_stats(pred,target,stats) calculates the statistics listed
%   in the cell array "statsDesired". 
%
%	Inputs:
%		pred            - Nx1 vector of predicted classes
%		target          - Nx1 vector of true classes
%       statsDesired    - Cell array of strings containing names of the
%           statistics to be calculated.
%
%	Outputs:
%		out     - A structure with fields containing the desired statistics
%       roc     - Structure with the Receiver Operator Characteristic curve
%       roc.x   - X values for the ROC curve
%       roc.y   - Y values for the ROC curve
%
%   The following statistical tests are possible:
%
%       all       - Returns all statistics available
%       AUROC     - Area under the receiver operator (characteristic) curve
%       HL        - Hosmer-Lemeshow Statistic
%       Accuracy  - Mean prediction accuracy using a threshold of 0.5
%       ShapiroR  - Shapiro's R, the geometric mean of positive outcomes
%       Brier     - Brier's score, the mean square error
%       SMR       - Standardized mortality ratio. Mean observed outcomes
%                   divided by mean predicted outcomes.
%       cox       - Calculates cox.A and cox.B
%                   Cox calibration involves a linear regression of the
%                   predictions onto the targets. coxA is the constant
%                   offset, while coxB is the slope.
%           cox.A    - Alpha coefficient in cox calibration.
%           cox.B    - Beta coefficient in cox calibration.
%       
%       TP        - True positives.
%       FP        - False positives.
%       TN        - True negatives.
%       FN        - False negatives.
%       sens      - Sensitivity. Calculated as: TP/(TP+FN)
%       spec      - Specificity. Calculated as: TN/(TN+FP)
%       ppv       - Positive predictive value. Calculated as: TP/(TP+FP)
%       npv       - Negative predictive value. Calculated as: TN/(TN+FN)
% 
%   [ out,roc ] = stat_calc_struct(pred,target,stats) additionally 
%   calculates the values pairs which form the ROC curve.
%           roc.x - Stores 1-specificity, plotted on the x-axis
%           roc.y - Stores Sensitivity, plotted on the y-axis
%
%
%	Example using fisheriris data set (requires Statistics Toolbox)
%		load fisheriris % load data;
%		X=meas; % input data 
%       % Try to predict whether species is 'setosa'
%		target=double(strcmp('setosa',species)); 
%
%		stats=regstats(target,X,'linear','yhat'); % Create model
%
%		pred=double(stats.yhat>0.5); % Extract predictions
%       
%       
%		[ out, roc ] = ga_stats(pred,target,{'AUROC','Accuracy'})
%           % Calculates the AUROC and accuracy, and stores them in 
%           %   out.AUROC and out.Accuracy
%           % Also calculates the ROC curve points

% Scan private folder for available functions
statsFcns = arrayfun(@(x) x.name,dir('./stats/private/*.m'),'UniformOutput',false);

% Ensure that functions scanned are correct
[startIndex,endIndex]=regexp(statsFcns,'stats_');
remFcnIndex=[];
if any(cell2mat(startIndex)~=1) || any(cell2mat(endIndex)~=6)
    % Incorrect function present
    
    % Index these for removal
    remFcnIndex=unique([find(cell2mat(startIndex)~=1);find(cell2mat(endIndex)~=6)]);

    % Throw warning
    
    for k=1:length(remFcnIndex)
    warning('GA:ga_stats:IncorrectFunction', ...
        ['Function ' statsFcns{remFcnIndex(k)} ' does not follow\n' ...
        'the standard format, stats_FCNNAME.m . This file should\n' ...
        'be removed from the directory.']);
    end
end

% Remove erroneously scanned functions
statsFcns(remFcnIndex)=[];

% Remove .m extension
statsFcns=regexprep(statsFcns,'.m','');

% Remove stats_ prefix for field names
statsFieldNames=regexprep(statsFcns,'stats_','');

% Check if 'all' exists
allFlag=any(strcmp(statsDesired,'all'));

if allFlag
    % Return all possible statistics
    statsDesired=statsFieldNames;
end

% Loop across input stats to calculate desired statistics
for k=1:length(statsDesired)
    % Ensure that requested stats have corresponding functions
    valid=strcmp(statsFieldNames,statsDesired{k});
    
    if any(valid)
        out.(statsDesired{k})=feval(statsFcns{k},pred,target);
    else
        warning('GA:ga_stats:UnknownStatistic', ...
            ['Specified statistic ' statsDesired{k} ' does not have a\n' ...
            'corresponding function and was not calculated. An empty\n' ...
            'matrix was output instead.']);
        out.(statsDesired{k})=[];
    end
end

if nargout>1 % Calculate roc curves
    [roc.x,roc.y]=perfcurve(target,pred,1);
end

end