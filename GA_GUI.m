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

% Last Modified by GUIDE v2.5 04-Oct-2011 16:54:34

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

%%Scan files and find specific functions
files = dir;
Fplot = {}; Ffit = {}; Fxval = {} ; Fmating = {}; Fcost = {};
for f=1:length(files)
    if regexp(files(f).name,'plot_.*.\S?') % there is a plot function
        Fplot = [Fplot ; files(f).name(1:(end-2)) ];
    end
    if regexp(files(f).name,'fit_.*.m$') % there is a Fit function
        Ffit = [Ffit ; files(f).name(1:(end-2)) ];
    end
    if regexp(files(f).name,'xval_.*\.m$') % there is a Cross-validation function
        Fxval = [Fxval ; files(f).name(1:(end-2)) ];
    end
    if regexp(files(f).name,'crsov.*\.m$') % there is a Mating function
        Fmating = [Fmating ; files(f).name(1:(end-2)) ];
    end
    if regexp(files(f).name,'cost_.*\.m$') % there is a Mating function
        Fcost = [Fcost ; files(f).name(1:(end-2)) ];
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
[handles.DataFile , handles.DataFilePath] = uigetfile({'*.mat','Matlab file';'*.xls','Excel File';'*.csv','CSV file'}, 'Please select your pre-formated database');

if handles.DataFile~=0
    %% Get and process input data
    if strcmp(handles.DataFile((end-2):end),'mat')
        % this is a MAT file
        eval(['load ' handles.DataFilePath  handles.DataFile ';']);

    elseif strcmp(handles.DataFile((end-2):end),'csv')
        % This is a CSV file
        % TODO fill import function
        warndlg('CSV file not supported yet, please use MAT file');
        error('GA_GUI:Start','CSV file not supported yet, please use MAT file');
    elseif strcmp(handles.DataFile((end-2):end),'xls')
        % This is a XLS file    
        % TODO fill import function
        warndlg('XLS file not supported yet, please use MAT file');
        error('GA_GUI:Start','XLS file not supported yet, please use MAT file');
    else
        errmsg = sprintf('Input file has undefined extension: %s. Should be .mat, .xls or .csv',handles.DataFile((end-3):end));
        error('GA_GUI:Start',errmsg);
    end
    set(handles.text1,'String',handles.DataFile);

    % TODO look at outcome and check what kind of outcome this is:
    % - linear
    % - binary
    % - multiclass
    % handles.outcomeType = 

    % Data integrity check
         [data outcome labels] = data_integrity_check(data,outcome,labels);

    % Save data
        handles.data = data ;
        handles.outcome = outcome ;
        handles.labels = labels ;
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
set(handles.text2,'String',handles.ExportFile);
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

opts = ga_opt_set('Display','plot',...
    'MinFeatures', str2double( get(handles.MinFeatures,'String') ), ...
    'MaxFeatures', str2double( get(handles.MaxFeatures,'String') ), ...
    'MaxIterations',str2double( get(handles.edit2,'String') ),...
    'ConfoundingFactors', get(handles.edit4,'String'), ...
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
    'OptDir', get(handles.checkbox3,'Value')...
    );

if isfield(handles,'ExportFile')
    %TODO: (WARNING) This scenario doesn't seem to actually update the the
    %opts but to replace them only.
%   opts = ga_opt_set(opts , 'FileName', [handles.ExportFilePath handles.ExportFile])
end

% Check input data
if  ~isfield(handles, {'data','labels','outcome'})
    errordlg('The datafile is not loaded, please select a database and try again');
    error('GA_GUI:Start','No data to process')
end
    
% Load matlabpool
% If you want to use parallel threats
if ~isempty(opts.Parallelize) && opts.Parallelize==1 && matlabpool('size')<=0
    matlabpool 8;
end
tic;
% ALGO GEN
%try
    display('RUNNING!!!')
    [ga_out, ga_options] =  AlgoGen(handles.data,handles.outcome,opts);
%catch me
%     if ~isempty(opts.Parallelize) && opts.Parallelize==1 && matlabpool('size')>0
%         matlabpool close;
%     end
%     rethrow(me)
%     
% end


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
