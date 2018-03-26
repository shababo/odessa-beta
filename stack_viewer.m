function varargout = stack_viewer(varargin)
% STACK_VIEWER MATLAB code for stack_viewer.fig
%      STACK_VIEWER, by itself, creates a new STACK_VIEWER or raises the existing
%      singleton*.
%
%      H = STACK_VIEWER returns the handle to a new STACK_VIEWER or the handle to
%      the existing singleton*.
%
%      STACK_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STACK_VIEWER.M with the given input arguments.
%
%      STACK_VIEWER('Property','Value',...) creates a new STACK_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stack_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stack_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stack_viewer

% Last Modified by GUIDE v2.5 26-Mar-2018 15:32:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stack_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @stack_viewer_OutputFcn, ...
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


% --- Executes just before stack_viewer is made visible.
function stack_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stack_viewer (see VARARGIN)

% Choose default command line output for stack_viewer
handles.output = hObject;

handles.data.image = varargin{1};
if length(varargin) > 2 && ~isempty(varargin{3})
    handles.data.parent_handles = varargin{3};
end
if length(varargin) > 1 && ~isempty(varargin{2})
    handles.data.slice_ind = varargin{2};
else
    handles.data.slice_ind = 1;
end 

handles.data.proj_top = 1;
handles.data.slice_max = size(handles.data.image,3);
handles.data.proj_bottom = handles.data.slice_max;
set(handles.proj_bottom,'String',num2str(handles.data.proj_bottom));

% Update handles structure
guidata(hObject, handles);

draw_all(handles)




% UIWAIT makes stack_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stack_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function draw_all(handles)
draw_slice(handles)
draw_proj(handles)

function draw_slice(handles)
axes(handles.slice_axes)
imagesc(handles.data.image(:,:,handles.data.slice_ind));

function draw_proj(handles)

handles.data.proj_top = str2double(get(handles.proj_top,'String'));

handles.data.proj_bottom = str2double(get(handles.proj_bottom,'String'));
if handles.data.proj_bottom < 1
    handles.data.proj_bottom = 1;
end
handles.data.proj_top = str2double(get(handles.proj_top,'String'));
if handles.data.proj_top > handles.data.slice_max
    handles.data.proj_bottom = handles.data.slice_max;
end
axes(handles.maxproj_axes)
imagesc(max(...
    handles.data.image(:,:,handles.data.proj_top:handles.data.proj_bottom),[],3));

% --- Executes on button press in stack_down.
function stack_down_Callback(hObject, eventdata, handles)
% hObject    handle to stack_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.slice_ind = handles.data.slice_ind + 1;
if handles.data.slice_ind > handles.data.slice_max
    handles.data.slice_ind = 1;
end
guidata(hObject,handles)
draw_slice(handles)

% --- Executes on button press in stack_up.
function stack_up_Callback(hObject, eventdata, handles)
% hObject    handle to stack_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.slice_ind = handles.data.slice_ind - 1;
if handles.data.slice_ind < 1
    handles.data.slice_ind = handles.data.slice_max;
end
guidata(hObject,handles)
draw_slice(handles)


function proj_top_Callback(hObject, eventdata, handles)
% hObject    handle to proj_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of proj_top as text
%        str2double(get(hObject,'String')) returns contents of proj_top as a double
draw_proj(handles)

% --- Executes during object creation, after setting all properties.
function proj_top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proj_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function proj_bottom_Callback(hObject, eventdata, handles)
% hObject    handle to proj_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of proj_bottom as text
%        str2double(get(hObject,'String')) returns contents of proj_bottom as a double
draw_proj(handles)

% --- Executes during object creation, after setting all properties.
function proj_bottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proj_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_cell_slice.
function select_cell_slice_Callback(hObject, eventdata, handles)
% hObject    handle to select_cell_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in select_cell_proj.
function select_cell_proj_Callback(hObject, eventdata, handles)
% hObject    handle to select_cell_proj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.maxproj_axes)

[y x] = ginput(1);
