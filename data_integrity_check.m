function [data outcome labels] = data_integrity_check(data,outcome,labels)

    % Check if variables are defined
    if ~exist('labels','var')
        errmsg = sprintf('Variable -labels- are not defined in the data file,!!! Creating standard labels...');
        warndlg(errmsg);
        warning('GA_GUI:LoadFile',errmsg);
        labels = generate_labels(varNum);
    elseif ~exist('data','var')
        errmsg =  sprintf('Variable -data- is not defined in the data file');
        errordlg(errmsg);
        error('GA_GUI:LoadFile',errmsg);
    elseif ~exist('outcome','var')
        errmsg = sprintf('Variable -outcome- is not defined in the data file');
        errordlg(errmsg);
        error('GA_GUI:LoadFile',errmsg);
    end
    % check is database is consistant
    varNum = length(labels);
    if size(data,2)~=varNum
        if size(data,1)==varNum 
            % Transpose data
            data = data';
            warndlg('The variable -data- has been transposed to match the right dimension');
        else
        errmsg = sprintf('Variables -data- and -outcome- do not have the same length');
        errordlg(errmsg);
        error('GA_GUI:Database',errmsg);
        end            
    elseif length(outcome)~=size(data,1)
        errmsg = sprintf('Variables -data- and -outcome- do not have the same length');
        errordlg(errmsg);
        error('GA_GUI:Database',errmsg);
    end 
    
    % Make sure data and outcomes are in the right format
    if size(outcome,1)<size(outcome,2)
        outcome = outcome';
    end
    if size(outcome,1)==size(data,2)
        data = data';
    end
    
    % check labels are in the right format (cell array)
    if ~iscell(labels)
        if isstr(labels) % then it is a string array instead
            if size(labels,1)~=varNum % just transpose if not right
                labels = labels';
            end
            for v=1:varNum % convert strings to cell array
                lab_tmp{v} = labels(v,:);
            end
            labels = lab_tmp;
        else
            warning('CheckData:wrongLabels','Labels are inconsistants: creating new labels');
            labels = generate_labels(varNum);
        end
    end
            
    outcome = outcome + 0.;
    
function labels = generate_labels(Nvar)
% generate label names for Nvar variables

labels = cell{Nvar,1};
for v=1:Nvar
    labels(Nvar) = ['var' int2str(Nvar)];
end

end

end
