function [ training, test, mu, sigma ] = normalizeData(training, test, normType)
%NORMALIZEATA	Normalizes the training/test data to training data values
%	[ training, test, mu, sigma ] = normalizeData(training, test)
%	normalizes the training data column-wise to have zero mean and unit 
%	stdev, and the test data using the mean and standard deviation of 
%	the training data (it will not necessarily have zero mean and unit 
%   stdev).
%
%   [ training, test, mu, sigma ] = normalizeData(training, test, normType)
%   allows for specification of the type of normalization to use for each
%   dimension. normType should be a 1xD vector with special flags for each
%   variable denoting what type of normalization. The flags follow:
%       'normal'    1   Normalize to have zero mean and unit stdev
%       'onesided'  2   Normalize a one-sided distribution (e.g. SpO2)
%       otherwise       Default zero mean, unit stdev
%
%	Inputs:
%		training - Training data. NxD - N observations, D dimensions
%       test     - Test data. NxD - N observations, D dimensions
%       normType - 1xD cell array or double vector of normalization flags
%
%	Outputs:
%		training - Training data normalized to zero mean/unit standard dev.
%       test     - Test data normalized to training data values
%
%	Example
%		[ training, test, mu, sigma ] = normalizeData(training, test, normType)
%	
%	See also EVALUATE EVALUATE_PAR

%	Copyright 2011 Alistair Johnson

%	$LastChangedBy$
%	$LastChangedDate$
%	$Revision$
%	Originally written on GLNXA64 by Alistair Johnson, 16-Dec-2011 15:57:18
%	Contact: alistairewj@gmail.com

%=== Extract indices from normType
if nargin<3
    % Default use zero mean/unit stdev
    idxNormal=true(1,size(training,2));
else
    if iscell(normType)
        idxOneSided = strcmp(normType,'onesided');
        idxNormal = strcmp(normType,'normal') | ~(idxOneSided); % Set defaults to normal
    elseif isnumeric(normType)
        idxOneSided = normType==2;
        idxNormal = normType==1 | ~(idxOneSided);
    end
end
%=== Extract training data mean and stdev
mu=mean(training,1);
sigma=std(training,[],1);

%=== Normalize training+test data
%=== One-sided distribution normalization
%TODO: Complete this section, index training/test using idxOneSided

%=== Zero mean unit stdev (default normalization)
training(:,idxNormal)=bsxfun(@minus, training(:,idxNormal), mu(:,idxNormal));
training(:,idxNormal)=bsxfun(@rdivide, training(:,idxNormal), sigma(:,idxNormal));
test(:,idxNormal)=bsxfun(@minus, test(:,idxNormal), mu(:,idxNormal));
test(:,idxNormal)=bsxfun(@rdivide, test(:,idxNormal), sigma(:,idxNormal));


end