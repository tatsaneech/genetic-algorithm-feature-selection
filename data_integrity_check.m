function [data outcome labels] = data_integrity_check(data,outcome,labels)

    % Check if variables are defined
    if ~exist('labels','var')
        errmsg = sprintf('Variable -labels- are not defined in the data file');
        errordlg(errmsg);
        error('GA_GUI:LoadFile',errmsg);
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
    outcome = outcome + 0.;
    
