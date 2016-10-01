function varargout = spatial_power_measure(varargin)
% SPATIAL_POWER_MEASURE MATLAB code for spatial_power_measure.fig
%      SPATIAL_POWER_MEASURE, by itself, creates a new SPATIAL_POWER_MEASURE or raises the existing
%      singleton*.
%
%      H = SPATIAL_POWER_MEASURE returns the handle to a new SPATIAL_POWER_MEASURE or the handle to
%      the existing singleton*.
%
%      SPATIAL_POWER_MEASURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPATIAL_POWER_MEASURE.M with the given input arguments.
%
%      SPATIAL_POWER_MEASURE('Property','Value',...) creates a new SPATIAL_POWER_MEASURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spatial_power_measure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spatial_power_measure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spatial_power_measure

% Last Modified by GUIDE v2.5 31-Aug-2016 10:31:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spatial_power_measure_OpeningFcn, ...
                   'gui_OutputFcn',  @spatial_power_measure_OutputFcn, ...
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


% --- Executes just before spatial_power_measure is made visible.
function spatial_power_measure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spatial_power_measure (see VARARGIN)

% Choose default command line output for spatial_power_measure
handles.output = struct();

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spatial_power_measure wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spatial_power_measure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function x_min_Callback(hObject, eventdata, handles)
% hObject    handle to x_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_min as text
%        str2double(get(hObject,'String')) returns contents of x_min as a double


% --- Executes during object creation, after setting all properties.
function x_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_min_Callback(hObject, eventdata, handles)
% hObject    handle to y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_min as text
%        str2double(get(hObject,'String')) returns contents of y_min as a double


% --- Executes during object creation, after setting all properties.
function y_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_min_Callback(hObject, eventdata, handles)
% hObject    handle to z_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_min as text
%        str2double(get(hObject,'String')) returns contents of z_min as a double


% --- Executes during object creation, after setting all properties.
function z_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_max_Callback(hObject, eventdata, handles)
% hObject    handle to x_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_max as text
%        str2double(get(hObject,'String')) returns contents of x_max as a double


% --- Executes during object creation, after setting all properties.
function x_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_max_Callback(hObject, eventdata, handles)
% hObject    handle to y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_max as text
%        str2double(get(hObject,'String')) returns contents of y_max as a double


% --- Executes during object creation, after setting all properties.
function y_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_max_Callback(hObject, eventdata, handles)
% hObject    handle to z_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_max as text
%        str2double(get(hObject,'String')) returns contents of z_max as a double


% --- Executes during object creation, after setting all properties.
function z_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disc_radius_Callback(hObject, eventdata, handles)
% hObject    handle to disc_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disc_radius as text
%        str2double(get(hObject,'String')) returns contents of disc_radius as a double


% --- Executes during object creation, after setting all properties.
function disc_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disc_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measure_duration_Callback(hObject, eventdata, handles)
% hObject    handle to measure_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measure_duration as text
%        str2double(get(hObject,'String')) returns contents of measure_duration as a double


% --- Executes during object creation, after setting all properties.
function measure_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measure_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_spacing_Callback(hObject, eventdata, handles)
% hObject    handle to x_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_spacing as text
%        str2double(get(hObject,'String')) returns contents of x_spacing as a double


% --- Executes during object creation, after setting all properties.
function x_spacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_spacing_Callback(hObject, eventdata, handles)
% hObject    handle to y_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_spacing as text
%        str2double(get(hObject,'String')) returns contents of y_spacing as a double


% --- Executes during object creation, after setting all properties.
function y_spacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_spacing_Callback(hObject, eventdata, handles)
% hObject    handle to z_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_spacing as text
%        str2double(get(hObject,'String')) returns contents of z_spacing as a double


% --- Executes during object creation, after setting all properties.
function z_spacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rand_order.
function rand_order_Callback(hObject, eventdata, handles)
% hObject    handle to rand_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rand_order



function pockels_voltage_Callback(hObject, eventdata, handles)
% hObject    handle to pockels_voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pockels_voltage as text
%        str2double(get(hObject,'String')) returns contents of pockels_voltage as a double


% --- Executes during object creation, after setting all properties.
function pockels_voltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pockels_voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intermeasure_interval_Callback(hObject, eventdata, handles)
% hObject    handle to intermeasure_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intermeasure_interval as text
%        str2double(get(hObject,'String')) returns contents of intermeasure_interval as a double


% --- Executes during object creation, after setting all properties.
function intermeasure_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intermeasure_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_time_Callback(hObject, eventdata, handles)
% hObject    handle to start_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_time as text
%        str2double(get(hObject,'String')) returns contents of start_time as a double


% --- Executes during object creation, after setting all properties.
function start_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in build.
function build_Callback(hObject, eventdata, handles)
% hObject    handle to build (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% build holograms
precomputed_target_base.mode = 'Disks';
precomputed_target_base.radius = str2double(get(handles.disc_radius,'String'));
precomputed_target_base.x = 0;
precomputed_target_base.y = 0;
precomputed_target_base.relative_power_density = 1;
precomputed_target_base.wavelength = 1040;

x_min = str2double(get(handles.x_min,'String'));
x_max = str2double(get(handles.x_max,'String'));
x_spacing = str2double(get(handles.x_spacing,'String'));

y_min = str2double(get(handles.y_min,'String'));
y_max = str2double(get(handles.y_max,'String'));
y_spacing = str2double(get(handles.y_spacing,'String'));

count = 1;
for i = x_min:x_spacing:x_max
    for j = y_min:y_spacing:y_max
        precomputed_target(count) = precomputed_target_base;
        precomputed_target(count).x = i;
        precomputed_target(count).y = j;
        count = count + 1;
    end
end

num_holograms = length(precomputed_target);
        
if get(handles.rand_order,'Value')
    order = 1:length(precomputed_target);
    precomputed_target = precomputed_target(order);
end

% build sequence
sequence_base.start = 0;
sequence_base.duration = str2double(get(handles.measure_duration,'String'))*1000;
sequence_base.power = str2double(get(handles.pockels_voltage,'String'))*100;
sequence_base.filter_configuration = 'Femto Phasor';

start_time = str2double(get(handles.start_time,'String'))*1000;
iti = str2double(get(handles.intermeasure_interval,'String'))*1000;

for i = 1:num_holograms

        sequence(i) = sequence_base;
        sequence(i).start = start_time + (i-1)*(iti + sequence_base.duration);

end

time_padding = 10.0; % in seconds
total_duration = (sequence(end).start + iti)/1000 + time_padding;

handles.output.precomputed_target = precomputed_target;
handles.output.sequence = sequence;
handles.output.total_duration = total_duration;

guidata(hObject,handles)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
else
% The GUI is no longer waiting, just close it
delete(hObject);
end
