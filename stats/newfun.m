function newfun(filename, desc)
%   NEWFUN Creates a new function using a hard coded template
%   
%       newfun(filename, desc) - Creates function "filename" with short
%       description "desc".
%   
%
%   Example:
%       newfun('test','This is a test function generated')
%
%   What you should modify:
%       Line 64 - Use your name, group, or company for copyright
%       Line 68/69 - Your name and e-mail address (ideally not .ox.ac.uk)

if nargin<2 || ~ischar(desc)
    % No description provided
    desc=[];
end
if nargin<1
    fprintf('This function requires a file name as input. \n');
    return;
end

% Check if .m extension is added, add if needed
if ~strcmpi(filename((end-1):end), '.m')
    filename = [filename '.m'];
end

% Don't overwriting existing files (safer option)
if exist(filename, 'file')
    fprintf([filename ' already exists. No new function created. \n']);
    return;
end

f = fopen(filename, 'w');
if f==-1
    % Something went wrong with file opening
    fprintf([filename ' could not be opened for writing. \n']);
    return;
end

fprintf(f, ['function [ stat ] = ' filename(1:(end-2)) '(pred,target)\n']);
fprintf(f, ['%%' upper(filename(1:(end-2))) '\t' desc '\n']);
fprintf(f, ['%%\t[ stat ] = ' filename(1:(end-2)) '(pred,target) \n']);
fprintf(f, '%%\t\n');
fprintf(f, '%%\n');
fprintf(f, '%%\tInputs:\n');
fprintf(f, '%%\t\tpred - Nx1 vector of predicted classes\n');
fprintf(f, '%%\t\ttarget - Nx1 vector of true classes\n');
fprintf(f, '%%\n');
fprintf(f, '%%\tOutputs:\n');
fprintf(f, '%%\t\tstat - The desired test statistic.\n');
fprintf(f, '%%\n');
fprintf(f, '%%\tExample using fisheriris data set (requires Statistics Toolbox)\n');
fprintf(f, ['%%\t\tload fisheriris %% load data;\n']);
fprintf(f, ['%%\t\tX=meas; %% input data \n']);
fprintf(f, ['%%\t\ttarget=strcmp(''setosa'',species); %% Try to predict whether species is ''setosa''\n']);
fprintf(f, ['%%\t\tstats=regstats(target,X,''linear'',''yhat'');\n']);
fprintf(f, ['%%\t\tpred=stats.yhat; %% Extract predictions\n']);
fprintf(f, ['%%\t\t[ stat ] = ' filename(1:(end-2)) '(pred,target) \n']);
fprintf(f, '%%\t\n');
fprintf(f, '%%\tSee also GA_STATS\n');
fprintf(f, '\n');
fprintf(f, '%%\tReferences:\n');
fprintf(f, '%%\t\n');
fprintf(f, '%%\t\n');

fprintf(f, '%%\t$Author: Alistair Johnson$\n');
fprintf(f, '%%\t$Revision: 1.0.0.0$\n');
fprintf(f, ['%%\t$Date: ' datestr(now) '$\n']);
fprintf(f, '%%\tContact: alistairewj@gmail.com\n');
fprintf(f, ['%%\tOriginally written on: ' computer '\n']);
fprintf(f, '\n');
fprintf(f, ['%%\tCopyright ' datestr(now,10) ' Alistair Johnson\n']);
fprintf(f, '\n');
fprintf(f, '\n');
fprintf(f, 'end');

fclose(f);

end