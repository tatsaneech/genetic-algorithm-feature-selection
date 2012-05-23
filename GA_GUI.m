function varargout = GA_GUI(varargin)
% GA_GUI M-file for GA_GUI.fig
%      GA_GUI, by itself, creates a new GA_GUI or raises the existing
%      singleton*.
%
%      H = GA_GUI returns the handle to a new GA_GUI or the handle to
%      the existing singleton*.
%
%      GA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GA_GUI.M with the given input arguments.
%
%      GA_GUI('Property','Value',...) creates a new GA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GA_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GA_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GA_GUI

% Last Modified by GUIDE v2.5 02-Dec-2011 14:56:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GA_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before GA_GUI is made visible.
function GA_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GA_GUI (see VARARGIN)

% Choose default command line output for GA_GUI
handles.output = hObject;
set(handles.pushbutton4,'UserData',false); % Initialize this paramter for user stop request


% Update toolboxes path
addpath('./stats'); % ensure stats is in the path

%%Scan files and find specific functions
files = dir;
statFiles = dir('./stats/private/');
Fplot = {}; Ffit = {}; Fxval = {} ; Fmating = {}; Fcost = {};
for f=1:length(files) %=== Loop through various functions
    if regexp(files(f).name,'plot_.*.\S?') % there is a plot function
        Fplot = [Fplot ; files(f).name(1:(end-2)) ];
    end
    if regexp(files(f).name,'fit_.*.m$') % there is a Fit function
        Ffit = [Ffit ; files(f).name(1:(end-2)) ];
    end
    if regexp(files(f).name,'xval_.*\.m$') % there is a Cross-validation function
        Fxval = [Fxval ; files(f).name(1:(end-2)) ];
    end
    if regexp(files(f).name,'crsov_.*\.m$') % there is a Mating function
        Fmating = [Fmating ; files(f).name(1:(end-2)) ];
    end
end
for f=1:length(statFiles) %=== Loop through stat functions
    if regexp(statFiles(f).name,'stats_.*\.m$') % there is a Cost function
        Fcost = [Fcost ; statFiles(f).name(1:(end-2)) ];
    end
end
set(handles.popupmenu1,'String' , Fmating)
set(handles.popupmenu3,'String' , Fxval)
set(handles.popupmenu4,'String' , Ffit)
set(handles.popupmenu5,'String' , Fplot)
set(handles.popupmenu6,'String' , Fcost)

% Initialize GA parameters
handles.GA_options = ga_opt_set();
handles.GA_options.GUIflag = true;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GA_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GA_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.DataFile=[];
[handles.DataFile , handles.DataFilePath] = uigetfile({'*.mat','Matlab file';'*.xls','Excel File';'*.csv','CSV file'}, 'Please select your pre-formated database(s)','MultiSelect','on');


if iscell(handles.DataFile)~=1
    handles.DataFile = { handles.DataFile} ;
end
if handles.DataFile{1}==0
    handles.DataFile=[];
end

for f=1:length(handles.DataFile)
    %% Get and process input data
    if strcmp(handles.DataFile{f}((end-2):end),'mat')
        % this is a MAT file
        eval(['load ''' handles.DataFilePath  handles.DataFile{f} ''';']);
        
    elseif strcmp(handles.DataFile{f}((end-2):end),'csv')
        % This is a CSV file
        % TODO fill import function
        warndlg('CSV file not supported yet, please use MAT file');
        error('GA_GUI:Start','CSV file not supported yet, please use MAT file');
    elseif strcmp(handles.DataFile{f}((end-2):end),'xls')
        % This is a XLS file
        % TODO fill import function
        warndlg('XLS file not supported yet, please use MAT file');
        error('GA_GUI:Start','XLS file not supported yet, please use MAT file');
    else
        errmsg = sprintf('Input file has undefined extension: %s. Should be .mat, .xls or .csv',handles.DataFile{f}((end-3):end));
        error('GA_GUI:Start',errmsg);
    end
    
    % TODO look at outcome and check what kind of outcome this is:
    % - linear
    % - binary
    % - multiclass
    % handles.outcomeType =
    
    % TODO: Add parsing to the input data to allow for variable field names
    %   Possible request input from user that data has been scanned
    %   properly
    if exist('data','var') && exist('labels','var') && exist('outcome','var')
        % Data integrity check
        [data outcome labels] = data_integrity_check(data,outcome,labels);
    elseif exist('X','var') && exist('labels','var') && exist('y','var')
        [data outcome labels] = data_integrity_check(X,y,labels);
    end
    
    % Save data
    handles.data{f} = data ;
    handles.outcome{f} = outcome ;
    handles.labels{f} = labels ;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.ExportFile , handles.ExportFilePath] = uigetfile({'*.xls','Excel File';'*.csv','CSV file'}, 'Please select your export File');
% TODO check file format integrity
set(handles.text2,'String',  handles.ExportFile);
% Update handles structure
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to MaxFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxFeatures as text
%        str2double(get(hObject,'String')) returns contents of MaxFeatures as a double


% --- Executes during object creation, after setting all properties.
function MaxFeatures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% GET input parameters
fitFs = get(handles.popupmenu4,'String')
fitFIdx = get(handles.popupmenu4,'Value')
matingFs = get(handles.popupmenu1,'String')
matingFIdx = get(handles.popupmenu1,'Value')
xvalFs = get(handles.popupmenu3,'String')
xvalFIdx = get(handles.popupmenu3,'Value')
plotFs = get(handles.popupmenu5,'String')
plotFIdx = get(handles.popupmenu5,'Value')
costFs = get(handles.popupmenu6,'String')
costFIdx = get(handles.popupmenu6,'Value')

options = ga_opt_set('Display','plot',...
    'MinFeatures', str2double( get(handles.MinFeatures,'String') ), ...
    'MaxFeatures', str2double( get(handles.MaxFeatures,'String') ), ...
    'MaxIterations',str2double( get(handles.edit2,'String') ),...
    'ConfoundingFactors', str2double(regexp(get(handles.edit4,'String'),',','split')), ...
    'Repetitions' , str2double( get(handles.edit1,'String') ), ...
    'FitnessFcn', fitFs{fitFIdx}, ...
    'CrossoverFcn',matingFs{matingFIdx}, ...
    'CostFcn',costFs{costFIdx}, ...
    'MutationRate',str2double( get(handles.edit6,'String') ), ...
    'PlotFcn',plotFs{plotFIdx}, ...
    'Parallelize',get(handles.checkbox2,'Value'),...
    'Elitism', get(handles.slider1,'Value'),...
    'CrossValidationFcn',xvalFs{xvalFIdx},...
    'PopulationEvolutionAxe',handles.axes1,...
    'FitFunctionEvolutionAxe',handles.axes2,...
    'CurrentPopulationAxe',handles.axes4,...
    'CurrentScoreAxe',handles.axes3,...
    'PopulationSize',str2double( get(handles.edit5,'String') ),...
    'GUIFlag',true,...
    'OptDir', get(handles.checkbox3,'Value'),...
    'ErrorGradient',0.00001,... % If zero, then ignore
    'MinimizeFeatures',false,...
    'FileName','SimulationOutput.csv',...
    'InitialFeatureNum',0, ...
    'NumFeatures',0 ... % Default to 0 - will be updated later
    );

if isfield(handles,'ExportFile')
    %TODO: (WARNING) This scenario doesn't seem to actually update the the
    %options but to replace them only.
    %   options = ga_opt_set(options , 'FileName', [handles.ExportFilePath handles.ExportFile])
end

% Check input data
if  ~isfield(handles, {'data','labels','outcome'})
    errordlg('The datafile is not loaded, please select a database and try again');
    error('GA_GUI:Start','No data to process')
end

% Load matlabpool
% If you want to use parallel threats
if ~isempty(options.Parallelize) && options.Parallelize==1 && matlabpool('size')<=0
    matlabpool 6;
end
tic;

%%% START ALGO GEN
display('RUNNING!!!')
h=gcf;

% min or maximize cost
if options.OptDir==1
    sort_str='descend';
else
    sort_str='ascend';
end

% Set up flags for output content
switch options.OutputContent
    case 'normal'
        ocDetailedFlag = false;
        ocDebugFlag = false;
    case 'detailed'
        ocDetailedFlag = true;
        ocDebugFlag = false;
    case 'debug'
        ocDetailedFlag = false;
        ocDebugFlag = true;
end

% parallelize?
if options.Parallelize==1
    evalFcn=@evaluate_par;
else
    evalFcn=@evaluate;
end

% for each data file
for f=1:length(handles.data)
    % display file name
    set(handles.text1,'String',handles.DataFile{f});
    
    % Rename variables
    DATA= handles.data{f} ;
    
    %=== Reset options field
    options = ga_opt_set(options,'NumFeatures',size(DATA,2));
    %% Initialisation
    verbose=true; % Set true to view time evaluations
    
    [DATA, outcome] = errChkInput(DATA, handles.outcome{f} , options);
    options.InitialFeatureNum = round(sum(outcome)/20);
    
    % Initialize outputs
    out = initialize_output(options) ;
    
    repTime=0;
    tries = 0;
    while tries <= options.Repetitions && ~get(handles.pushbutton4,'UserData')
        tries = tries + 1;
        
        %% Initialise GA
        parent = initialise_pop(options);
        % Check if early-stop criterion is met
        % if not: continue
        ite = 0 ; early_stop = false ;
        iteTime=0;
        
        
        % Calculate indices from crossvalidation
        % Determine cross validation indices
        xvalFcn=options.CrossValidationFcn;
        [ train, test, KI ] = feval(xvalFcn,outcome,options);
        
        while ite < options.MaxIterations && ~early_stop && ~get(handles.pushbutton4,'UserData')
            tic;
            ite = ite + 1;
            out.CurrentIteration=ite;
            if ite>(options.ErrorIterations+1) % Enough iterations have passed to estimate early stop
                win = out.Test.EvolutionBestCost((ite-(options.ErrorIterations+1)):(ite-1));
                if abs(max(win) - min(win)) < options.ErrorGradient && options.ErrorGradient ~=0
                    early_stop = true ;
                end
            end
            
            %% Evaluate parents are create new generation
            [testCost,trainCost] = feval(evalFcn,DATA,outcome,parent,options, train, test, KI);
            % TODO:
            %   Change eval function to return:
            %       model, outputs with predictions+indices, statistics
            
            %=== Sort genome
            [testCost  idxTestSort] = sort(testCost,sort_str);
            trainCost = trainCost(idxTestSort,:);
            parent = parent(idxTestSort,:);
        
            %% FINAL VALIDATION
            % If tracking best genome statistics is desirable during run-time,
            % this section will have to recalculate the genome fitness, etc.
            
            % Since FS is one individual, no need to parallelize (i.e. use
            % evaluate function)
            FS = parent(1,:)==1;
            [out.Test.EvolutionBestCost(ite,tries),...
                out.Training.EvolutionBestCost(ite,tries),...
                miscOutputContent ] ...
                = evaluate_final(DATA,outcome,FS,options,train, test, KI );
            % Note: FS is 1 individual - do not need to parallelize
            
            out.Training.EvolutionMedianCost(ite,tries) = nanmedian(trainCost);
            out.Test.EvolutionMedianCost(ite,tries) = nanmedian(testCost);
            
            %% Save and display results
            %%-------------------------+
            out.BestGenomePlot{1,tries}(ite,:)=FS;
            
            
            if ocDetailedFlag
                %=== Detailed output            
                out.EvolutionGenomeStats{ite,tries} = miscOutputContent.TestStats;

            elseif ocDebugFlag
                %=== Debug output
                out.EvolutionGenomeStats{ite,tries} = miscOutputContent.TestStats;
                
                out.Genome{1,tries}(:,:,ite) = parent; % Save current genome
                
                out.Training.EvolutionCost(ite,tries,:) = trainCost;
                out.Training.EvolutionBestStats{ite,tries} = miscOutputContent.TrainStats;
                
                out.Test.EvolutionCost(ite,tries,:) = testCost;
                out.Test.EvolutionBestStats{ite,tries} = miscOutputContent.TestStats;

            else
                %=== Normal output
            end
            
            %=== Plot results
            if strcmpi(options.Display,'plot')
                out.EvolutionGenomeStats{ite,tries} = miscOutputContent.TestStats;
                [ out ] = plot_All( out, parent, h, options );
            end
            
            %=== Calculate new genome
            parent = new_generation(parent,testCost,sort_str,options);
        
            iteTime=iteTime+toc;
            repTime=repTime+toc;
            if verbose % Time elapsed reports
                if tries>1
                    expectedTime = mean(out.RepetitionTime(1:tries-1)) / (tries-1);
                else
                    expectedTime = iteTime * options.MaxIterations / ite;
                end
                expectedTime = (expectedTime * options.Repetitions - repTime)/60/60;
                fprintf('Iteration %d of %d. Iteration Time: %2.2fs. Time Elapsed: %2.2fs. Projected: %2.2fh. \n',...
                    ite,options.MaxIterations, ...
                    toc, ... % Time in iteration
                    repTime, ... % Total time spent so far
                    expectedTime);
            end
            out.CurrentIteration=out.CurrentIteration+1;
            
        end
        % TODO: Add error checks if outcome = -1,1 instead of outcome = 0,1
        out.BestGenome{tries} = parent(1,:)==1;
        out.IterationTime(1,tries)=iteTime/options.MaxIterations;
        out.RepetitionTime(1,tries)=repTime/tries;
            out.BestGenomeStats{1,tries} = miscOutputContent.TestStats;
        
        % If the final iteration is less than the maximum, then we should
        % remove the extra pre-allocated genomes
        if size(out.BestGenomePlot{1,tries},1)>ite
            out.BestGenomePlot{1,tries}(ite+1:end,:)=[];
        end
        
        %=== Save results
        if ocDetailedFlag
            %=== Detailed output
            out.Model{1,tries} = miscOutputContent.model;
            out.Training.Indices{1,tries} = miscOutputContent.TrainIndex;
            out.Test.Indices{1,tries} = miscOutputContent.TestIndex;
        elseif ocDebugFlag
            %=== Debug output
            out.Model{1,tries} = miscOutputContent.model;
            out.Training.Indices{1,tries} = miscOutputContent.TrainIndex;
            out.Test.Indices{1,tries} = miscOutputContent.TestIndex;
            
            % If the final iteration is less than the maximum, then we should
            % remove the extra pre-allocated genomes
            if size(out.Genome{1,tries},3)>ite
                out.Genome{1,tries}(:,:,ite+1:end) = []; % Delete empties
            end
        else
            %=== Normal output so perform no additional calculations
        end
        
        out.CurrentRepetition=out.CurrentRepetition+1;
    end
    
    FileName = [handles.DataFile{f}(1:(end-4)) '_GA_results_'  datestr(now, 'mmddyy-HHMM') '.csv'];
    if get(handles.pushbutton4,'UserData') % then this was stopped on user's demand
        display('Algorithm STOPPED!');
        set(handles.pushbutton4,'UserData',false); % reset
        FileName = [   '.earlystopped_' FileName ];
        out.BestGenome((tries+1):end) = [];
    else % The algorithm ended normally
        % then we keep the same file format
    end
    set(handles.text2,'String',FileName);
    FileName = [ handles.DataFilePath FileName];
    
    % Save results
    export_results( FileName , out , handles.labels{f} , options );
    
end

guidata(hObject, handles);


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to MinFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinFeatures as text
%        str2double(get(hObject,'String')) returns contents of MinFeatures as a double


% --- Executes during object creation, after setting all properties.
function MinFeatures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Manual algortihm break recorded !');
set(handles.pushbutton4,'UserData',true);
guidata(hObject, handles);
