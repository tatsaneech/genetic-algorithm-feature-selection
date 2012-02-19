function [ training, test, mu, sigma ] = normalizeData(training, test, normType, varType)
%NORMALIZEATA	Normalizes the training/test data to training data values
%	[ training, test, mu, sigma ] = normalizeData(training, test)
%	normalizes the training data column-wise to range between [0,1], and 
%   scales the test data using the values extracted from the training data
%   (thus, while the training data will range between [0,1], the test data
%   does not necessarily reside in this range.)
%
%   [ training, test, mu, sigma ] = normalizeData(training, test, normType)
%	normalizes the training data using the method specified in normType.
%	Methods include:
%       'scale'     Normalize to [0,1] range (default)
%       'zscore'    Normalize to have zero mean and unit standard deviation
%
%	[ training, test, mu, sigma ] = normalizeData(training, test, normType, varType)
%   allows for specification of the type of normalization to use for each
%   dimension. varType should be a 1xD vector with special flags for each
%   variable denoting what type of normalization. The flags follow:
%       'normal'    1   Normalize using default method
%       'onesided'  2   Normalize assuming a one-sided distribution 
%               (e.g. SpO2)
%       otherwise       Normal method
%
%	Inputs:
%		training - Training data. NxD - N observations, D dimensions
%       test     - Test data. NxD - N observations, D dimensions
%       normType - string indicating type of normalization
%       varType - 1xD cell array or double vector of normalization flags
%
%	Outputs:
%		training - Training data normalized using training data
%       test     - Test data normalized to training data values
%
%	Example
%		[ training, test, mu, sigma ] = normalizeData(training, test)
%	
%	See also EVALUATE EVALUATE_PAR

%	Copyright 2011 Alistair Johnson

%	$LastChangedBy$
%	$LastChangedDate$
%	$Revision$
%	Originally written on GLNXA64 by Alistair Johnson, 16-Dec-2011 15:57:18
%	Contact: alistairewj@gmail.com


%=== Extract indices from varType
if nargin<4
    % Default use scaling
    idxNormal=true(1,size(training,2));
else
    if iscell(varType)
        idxOneSided = strcmp(varType,'onesided');
        idxNormal = strcmp(varType,'normal') | ~(idxOneSided); % Set defaults to normal
    elseif isnumeric(varType)
        idxOneSided = varType==2;
        idxNormal = varType==1 | ~(idxOneSided);
    end
end

if nargin<3
    normType='scale';
end

%=== Normalize training+test data
%=== One-sided distribution normalization
%TODO: Complete this section, index training/test using idxOneSided

%=== Scale to [0,1] range (default normalization)
switch normType
    case 'scale'
        mu = min(training,[],1);
        sigma = max(training,[],1) - mu;
        
        training(:,idxNormal)=bsxfun(@minus, training(:,idxNormal), mu(:,idxNormal));
        training(:,idxNormal)=bsxfun(@rdivide, training(:,idxNormal), sigma(:,idxNormal));
        test(:,idxNormal)=bsxfun(@minus, test(:,idxNormal), mu(:,idxNormal));
        test(:,idxNormal)=bsxfun(@rdivide, test(:,idxNormal), sigma(:,idxNormal));
    case 'zscore'
        
        %=== Extract training data mean and stdev
        mu=mean(training,1);
        sigma=std(training,[],1);
        
        %=== Zero mean unit stdev (default normalization)
        training(:,idxNormal)=bsxfun(@minus, training(:,idxNormal), mu(:,idxNormal));
        training(:,idxNormal)=bsxfun(@rdivide, training(:,idxNormal), sigma(:,idxNormal));
        test(:,idxNormal)=bsxfun(@minus, test(:,idxNormal), mu(:,idxNormal));
        test(:,idxNormal)=bsxfun(@rdivide, test(:,idxNormal), sigma(:,idxNormal));
    otherwise
        error('Unrecognized normalization method.');
end

end