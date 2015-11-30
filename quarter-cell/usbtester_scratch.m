function varargout = usbtester(varargin)
% USBTESTER MATLAB code for usbtester.fig
%      USBTESTER, by itself, creates a new USBTESTER or raises the existing
%      singleton*.
%
%      H = USBTESTER returns the handle to a new USBTESTER or the handle to
%      the existing singleton*.
%
%      USBTESTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USBTESTER.M with the given input arguments.
%
%      USBTESTER('Property','Value',...) creates a new USBTESTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before usbtester_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to usbtester_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE'handles.mpc200 Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help usbtester

% Last Modified by GUIDE v2.5 23-Jun-2015 14:45:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @usbtester_OpeningFcn, ...
                   'gui_OutputFcn',  @usbtester_OutputFcn, ...
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


% --- Executes just before usbtester is made visible.
function usbtester_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to usbtester (see VARARGIN)

% Choose default command line output for usbtester
global defpos
defpos=[];
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes usbtester wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = usbtester_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function comnum_Callback(hObject, eventdata, handles)
% hObject    handle to comnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comnum as text
%        str2double(get(hObject,'String')) returns contents of comnum as a double
handles.comnumber=get(hObject,'String');%Get COM port number
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function comnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect.
function connect_Callback(hObject, eventdata, handles)
% hObject    handle to connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles.mpc200
handles.mpc200 = serial(strcat('COM',handles.comnumber),'BaudRate',128000,'Terminator','CR');
fopen(handles.mpc200);
handles.mpc200.Parity = 'none';
set(handles.comconnect,'String',sprintf('\n Connected to COM %c',handles.comnumber));
qstring=sprintf('Connected to Sutter Instrument ROE. ROE must be calibrated to work properly.\n\nWould you like to calibrate now?');
Cali=questdlg(qstring,'Calibration Required','Yes','Not now','Yes');
switch Cali
    case 'Yes'
        fprintf(handles.mpc200,'%c','N');
end
guidata(hObject, handles);

% --- Executes on button press in savepos.
function savepos_Callback(hObject, eventdata, handles)
% hObject    handle to savepos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles.mpc200 defpos
[handles.x,handles.y,handles.z]=getpos();
[r,c]=size(defpos);
defpos(r+1,1)=handles.x;
defpos(r+1,2)=handles.y;
defpos(r+1,3)=handles.z;
set(handles.uitable1,'Data',defpos);
for i=1:(r+1)
    popupstr(i)={num2str(i)};        
end
set(handles.pospopup,'String',popupstr);
guidata(hObject, handles);

% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)
% hObject    handle to delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global defpos
index=get(handles.pospopup,'String');
if ~(strcmp(index,'none'))
    id=str2double(index);
    [r,c]=size(defpos);
    if r==1
        defpos=[];
        set(handles.pospopup,'String','none');     
    else
        for i=id+1:r
            defpos(i-1,1)=defpos(i,1);
            defpos(i-1,2)=defpos(i,2);
            defpos(i-1,3)=defpos(i,3);
        end
        defpos(r,:)=[];
        for i=1:(r-1)
            popupstr(i)={num2str(i)};     
        end
        set(handles.pospopup,'Value',1);
        set(handles.pospopup,'String',popupstr);  
    end
    set(handles.uitable1,'Data',defpos);
end
guidata(hObject, handles);

% --- Executes on button press in getpos.
function getpos_Callback(hObject, eventdata, handles)
% hObject    handle to getpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.x,handles.y,handles.z]=getpos();
set(handles.currentx,'String',num2str(handles.x));
set(handles.currenty,'String',num2str(handles.y));
set(handles.currentz,'String',num2str(handles.z));
guidata(hObject, handles);


function setx_Callback(hObject, eventdata, handles)
% hObject    handle to setx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setx as text
%        str2double(get(hObject,'String')) returns contents of setx as a double


% --- Executes during object creation, after setting all properties.
function setx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sety_Callback(hObject, eventdata, handles)
% hObject    handle to sety (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sety as text
%        str2double(get(hObject,'String')) returns contents of sety as a double


% --- Executes during object creation, after setting all properties.
function sety_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sety (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function setz_Callback(hObject, eventdata, handles)
% hObject    handle to setz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setz as text
%        str2double(get(hObject,'String')) returns contents of setz as a double


% --- Executes during object creation, after setting all properties.
function setz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gotopos.
function gotopos_Callback(hObject, eventdata, handles)
% hObject    handle to gotopos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.x=str2double(get(handles.setx,'String'));
handles.y=str2double(get(handles.sety,'String'));
handles.z=str2double(get(handles.setz,'String'));
gotopos(handles.x, handles.y, handles.z);
guidata(hObject, handles);


function currenty_Callback(hObject, eventdata, handles)
% hObject    handle to currenty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currenty as text
%        str2double(get(hObject,'String')) returns contents of currenty as a double


% --- Executes during object creation, after setting all properties.
function currenty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currenty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currentz_Callback(hObject, eventdata, handles)
% hObject    handle to currentz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentz as text
%        str2double(get(hObject,'String')) returns contents of currentz as a double


% --- Executes during object creation, after setting all properties.
function currentz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in home.
function home_Callback(hObject, eventdata, handles)
% hObject    handle to home (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles.mpc200
fprintf(handles.mpc200,'%c','H');

% --- Executes on button press in workpos.
function workpos_Callback(hObject, eventdata, handles)
% hObject    handle to workpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles.mpc200
fprintf(handles.mpc200,'%c','Y');

% --- Executes on button press in Calib.
function Calib_Callback(hObject, eventdata, handles)
% hObject    handle to Calib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles.mpc200
fprintf(handles.mpc200,'%c','N');

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles.mpc200
fwrite(handles.mpc200, uint8(3))

% --- Executes on selection change in pospopup.
function pospopup_Callback(hObject, eventdata, handles)
% hObject    handle to pospopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pospopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pospopup


% --- Executes during object creation, after setting all properties.
function pospopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pospopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global defpos
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
[r,c]=size(defpos);
if r==0
    popupstr='none';
end
for i=1:r
    popupstr(i)={num2str(i)};        
end
set(hObject,'String',popupstr);



% --- Executes on button press in godefposbtn.
function godefposbtn_Callback(hObject, eventdata, handles)
% hObject    handle to godefposbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global defpos
index=get(handles.pospopup,'String');
if ~(strcmp(index,'none'))
    id=str2double(index);
    handles.x=defpos(id,1);
    handles.y=defpos(id,2);
    handles.z=defpos(id,3);
    gotopos(handles.x,handles.y,handles.z);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function comconnect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global handles.mpc200
if isvalid(handles.mpc200)
    fclose(handles.mpc200);
    delete(handles.mpc200)
    clear handles.mpc200
end
delete(hObject);
