function export_results( FileName , out , labels , options )

Ntries = length(out.BestGenome);
Nlabels = length(labels);


TrainingCost = mean(out.EvolutionBestCost);
TestCost = mean(out.EvolutionBestCostTest);
Genomes =  reshape(cell2mat(out.BestGenome),Nlabels,Ntries)' ;

% Define Spread sheet and header
sheet = cell( length(labels)+3 , size(Genomes)+2 );

sheet{3,1} = 'Variable Name';

% we want to plot the genomes and show:
%   - the variables (lables) by decreasing percentage of selection over
%   all best genomes
%   - the genomes sorted according to their score on test set
[~,IdxLabels] = sort(sum(Genomes),'descend');
[~,IdxTries] = sort(TestCost,'descend');


sheet{1,2} = 'Test Score';     sheet(1,2+(1:Ntries)) = num2cell(TestCost(IdxTries));  
sheet{2,2} = 'Training Score'; sheet(2,2+(1:Ntries)) = num2cell(TrainingCost(IdxTries));  
sheet{3,2} = 'Number of selections'; 
    ModelDim=sum(Genomes,2);
    sheet(3,2+(1:Ntries)) = num2cell(ModelDim(IdxTries)');
    SelectPer = 100*sum(Genomes)/size(Genomes,1) ;
    sheet(3+(1:Nlabels),2) =  num2cell( SelectPer( IdxLabels ) );

sheet{3,1} = 'Variables Names';     
sheet(3+(1:Nlabels),1) = labels( IdxLabels );

% Write genomes in it
sheet(3+(1:Nlabels),2+(1:Ntries)) = num2cell(Genomes(IdxTries,IdxLabels)');

if ~isempty(regexp(FileName,'xls')) % then save as XLS
    if ispc % Is it a PC 
        % Write the excel file
        xlswrite(FileName,sheet,'Results');
        % Write the options in a different sheet
        xlswrite(FileName,struct2cell(options),'Options');    
    else % If not Pc 
        warning(ExportResults:XLSnoWindows,'Can not export to XLS in UNIX, converting to CSV');
        FileName = [ FileName(1:(end-4)) '.csv'];
    end
elseif ~isempty(regexp(FileName,'csv')) % then save as CSV
    fidCSV = fopen(fileName,'w');
    for r=1:(Nlabels+3)
        for c=1:(Ntries+2)
            if c==1 | (c==2 & r<4) % then print a string
                fprintf(fidCSV,'%s;',sheet{r,c});
            else % print a number
                fprintf(fidCSV,'%f;',sheet{r,c});
            end
        end
        fprintf(fidCSV,'\n');
    end
    fclose(fidCSV);
            
            
else % Other data type
    display('Does not currently support this kind of output file');
end


