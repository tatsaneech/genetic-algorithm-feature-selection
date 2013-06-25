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
    fn = options.Hyperparameters(1:3:end);
    
    options.Hyperparameters = struct();
    %=== Add in hyperparameter genomes 1 by 1
    for m=1:numel(fn)
        curr_hyp = oldHyp{3*(m-1)+2};
        %=== generate our grid search space
        offset = min(curr_hyp); % offset of the grid
        curr_hyp = sort(curr_hyp-offset);
        bitsNeeded = ceil(log2(abs(diff(curr_hyp))));
        options.Hyperparameters.(fn{m}).bitsNeeded = bitsNeeded;
        options.Hyperparameters.(fn{m}).offset = offset;
        
        if ischar(oldHyp{3*m})
            options.Hyperparameters.(fn{m}).fcn = oldHyp{3*m};
        else
            options.Hyperparameters.(fn{m}).fcn = func2str(oldHyp{3*m});
        end
        
    end
end


end