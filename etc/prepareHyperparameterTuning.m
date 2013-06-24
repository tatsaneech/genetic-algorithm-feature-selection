function [ options ] = prepareHyperparameterTuning(options)
%PREPAREHYPERPARAMETERTUNING	Prepare hyperparameter tuning for GA
%	[ options ] = prepareHyperparameterTuning(options) transforms the
%	hyperparameter field into a structure for easier use with GA later.
%	
%
%	Inputs:
%		options     - Structure of options for the GA.
%
%	Outputs:
%		options     - Structure of options for the GA.


%	$Author: Alistair Johnson$
%	$Revision: 1.0.0.0$
%	$Date: 21-Jun-2013 15:02:41$
%	Contact: alistairewj@gmail.com
%	Originally written on: GLNXA64

%	Copyright 2013 Alistair Johnson


%=== Add in hyperparameters if needed
if ~isempty(options.Hyperparameters)
    oldHyp = options.Hyperparameters;
    fn = options.Hyperparameters(1:2:end);
    
    options.Hyperparameters = struct();
    %=== Add in hyperparameter genomes 1 by 1
    for m=1:numel(fn)
        curr_hyp = oldHyp{2*m};
        %=== generate our grid search space
        isNeg = sign(curr_hyp);
        offset = min(curr_hyp); % offset of the grid
        if all(isNeg==-1) % both are negative values, abs before diff
            curr_hyp = abs(curr_hyp);
        end
        
        bitsNeeded = ceil(log2(abs(diff(curr_hyp))));
        options.Hyperparameters.(fn{m}).bitsNeeded = bitsNeeded;
        options.Hyperparameters.(fn{m}).offset = offset;
    end
end


end