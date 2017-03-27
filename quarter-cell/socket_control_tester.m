function varargout = socket_control_tester(varargin)
% SOCKET_CONTROL_TESTER MATLAB code for socket_control_tester.fig
%      SOCKET_CONTROL_TESTER, by itself, creates a new SOCKET_CONTROL_TESTER or raises the existing
%      singleton*.
%
%      H = SOCKET_CONTROL_TESTER returns the handle to a new SOCKET_CONTROL_TESTER or the handle to
%      the existing singleton*.
%
%      SOCKET_CONTROL_TESTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOCKET_CONTROL_TESTER.M with the given input arguments.
%
%      SOCKET_CONTROL_TESTER('Property','Value',...) creates a new SOCKET_CONTROL_TESTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before socket_control_tester_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to socket_control_tester_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help socket_control_tester

% Last Modified by GUIDE v2.5 14-Mar-2017 10:02:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @socket_control_tester_OpeningFcn, ...
                   'gui_OutputFcn',  @socket_control_tester_OutputFcn, ...
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


% --- Executes just before socket_control_tester is made visible.
function socket_control_tester_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to socket_control_tester (see VARARGIN)

% Choose default command line output for socket_control_tester
instruction = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes socket_control_tester wait for user response (see UIRESUME)
% uiwait(handles.socket_gui);


% --- Outputs from this function are returned to the command line.
function varargout = socket_control_tester_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = instruction;


% --- Executes on button press in move_obj.
function move_obj_Callback(hObject, eventdata, handles)
% hObject    handle to move_obj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('moving obj')
instruction.type = 10; %MOVE_OBJ
instruction.deltaX = str2double(get(handles.deltaX,'String'));
instruction.deltaY = str2double(get(handles.deltaY,'String'));
instruction.deltaZ = str2double(get(handles.deltaZ,'String'));

disp('sending instruction...')
[return_info,success,handles] = do_instruction(instruction,handles) ;
% assignin('base','return_info',return_info)
guidata(hObject,handles)

disp('operation done, setting fields...')
set(handles.currX,'String',num2str(return_info.currX));
set(handles.currY,'String',num2str(return_info.currY));
set(handles.currZ,'String',num2str(return_info.currZ));

disp('sending to acq gui')
acq_gui_data = get_acq_gui_data();
acq_gui_data.data.obj_position_socket = [return_info.currX return_info.currY return_info.currZ];
handles.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
% acq_gui_data.success = 1;
acq_gui = findobj('Tag','acq_gui');
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)


function deltaX_Callback(hObject, eventdata, handles)
% hObject    handle to deltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaX as text
%        str2double(get(hObject,'String')) returns contents of deltaX as a double


% --- Executes during object creation, after setting all properties.
function deltaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaY_Callback(hObject, eventdata, handles)
% hObject    handle to deltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaY as text
%        str2double(get(hObject,'String')) returns contents of deltaY as a double


% --- Executes during object creation, after setting all properties.
function deltaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaZ_Callback(hObject, eventdata, handles)
% hObject    handle to deltaZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaZ as text
%        str2double(get(hObject,'String')) returns contents of deltaZ as a double


% --- Executes during object creation, after setting all properties.
function deltaZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_obj_pos.
function update_obj_pos_Callback(hObject, eventdata, handles)
% hObject    handle to update_obj_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('hello')
instruction.type = 20; %GET_OBJ_POS
% instruction.reset = 1;
instruction.close_socket = handles.close_socket;
disp('reset workspace...')
[return_info,success,handles] = do_instruction(instruction,handles);

guidata(hObject,handles)
% if ~return_info.success
%     set(handles.currX,'String','x');
%     set(handles.currY,'String','y');
%     set(handles.currZ,'String','z');
%     return
% end
disp('operation done, setting fields...')
set(handles.currX,'String',num2str(return_info.currX));
set(handles.currY,'String',num2str(return_info.currY));
set(handles.currZ,'String',num2str(return_info.currZ));

disp('sending to acq gui')
acq_gui_data = get_acq_gui_data();
acq_gui_data.data.obj_position_socket = [return_info.currX return_info.currY return_info.currZ];
handles.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
% acq_gui_data.success = 1;
acq_gui = findobj('Tag','acq_gui');
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)



function [return_info, success, handles] = do_instruction(instruction, handles)


% if instruction.type == 21
%     handles.sock
% end
if ~isfield(handles,'sock')
    disp('opening socket...')
    srvsock = mslisten(3000);
%     handles.sock = -1;
    handles.sock = msaccept(srvsock);
    disp('socket open..')
    msclose(srvsock);
end
if isfield(handles,'close_socket')
    instruction.close_socket = handles.close_socket;
else
    instruction.close_socket = 1;
end
pause(.1)
disp('sending instruction...')
mssend(handles.sock,instruction);
disp('getting return info...')
pause(.1)
[return_info, success] = msrecv(handles.sock,15);
assignin('base','return_info',return_info)
% success = 1;

if instruction.close_socket
    disp('closing socket')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
end



% --- Executes on button press in build_seq.
function build_seq_Callback(hObject, eventdata, handles)
% hObject    handle to build_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% rng(1234)
num_stim = str2double(get(handles.num_stim,'String'));

sequence_base.start = 0;
sequence_base.duration = str2double(get(handles.duration,'String'))*1000
all_powers = strread(get(handles.target_intensity,'String'));
sequence_base.power = all_powers(1);
sequence_base.filter_configuration = 'Femto Phasor';
sequence_base.precomputed_target_index = 1;

sequence(num_stim) = sequence_base;
start_time = 1.0*1000; % hard set to 1 second for now
iti = str2double(get(handles.iti,'String'))*1000

target_power = str2double(get(handles.target_intensity,'String'));

count = 1;
ind_offset = str2double(get(handles.ind_offset,'String'));
for k = 1:length(all_powers)
    for i = 1:num_stim


        sequence(count) = sequence_base;
        sequence(count).power = all_powers(k);
        sequence(count).precomputed_target_index = i + ind_offset;
%             if get(handles.power,'Value')
%                 [~, c_i] = min(abs(x_positions(i) - conversion));
%                 [~, c_j] = min(abs(y_positions(j) - conversion));
%                 scaled_power = target_power * handles.ratio_map(c_i,c_j);
% %                 voltage = get_voltage([0:.01:2.0; reshape(handles.lut(i,j,:),1,201)],target_intensity);
%                 voltage = get_voltage(handles.lut,scaled_power);
%                 image_test(i,j) = voltage;
%                 sequence(count).power = voltage*100;
%             end
%                 sequence(count).start = start_time + (count-1)*(ititag + sequence_base.durtag);
%             sequence(count).power = powers(k)*100;

        count = count + 1;
    end
end
num_stim = length(sequence);

num_repeats = str2double(get(handles.num_repeats,'String'));

if num_stim > 1 && get(handles.rand_order,'Value')
    
    order = zeros(num_stim*num_repeats,1);
    for i = 1:num_repeats
        order((i-1)*num_stim+1:i*num_stim) = randperm(num_stim);
    end
    
else
    order = repmat(1:num_stim,1,num_repeats);
    
end

% precomputed_target = precomputed_target(order);
sequence = sequence(order);


for i = 1:length(sequence)
    sequence(i).start = start_time + (i-1)*(iti + sequence_base.duration);
end

time_padding = 0; % in seconds
total_duration = (sequence(end).start + iti)/1000 + time_padding;

instruction.sequence = sequence;
instruction.tf_flag = get(handles.tf_flag,'Value');
instruction.total_duration = total_duration;
if ~isfield(handles,'close_socket')
    handles.close_socket = 1;
end
guidata(hObject,handles)
instruction.close_socket = handles.close_socket;
if get(handles.power,'Value')
    instruction.target_power = target_power;
else
    instruction.target_power = NaN;
end

instruction.type = 30; %SEND SEQ
handles.sequence = sequence;
handles.total_duration = total_duration;

disp('sending instruction...')
[return_info,success,handles] = do_instruction(instruction,handles);
acq_gui_data = get_acq_gui_data();
acq_gui_data.data.spots_key =  return_info.spots_key;
acq_gui_data.data.sequence =  return_info.sequence;
acq_gui = findobj('Tag','acq_gui');
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)
% assignin('base','sequence_new',sequence)




function duration_Callback(hObject, eventdata, handles)
% hObject    handle to durtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durtag as text
%        str2double(get(hObject,'String')) returns contents of durtag as a double


% --- Executes during object creation, after setting all properties.
function durtag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iti_Callback(hObject, eventdata, handles)
% hObject    handle to ititag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ititag as text
%        str2double(get(hObject,'String')) returns contents of ititag as a double


% --- Executes during object creation, after setting all properties.
function ititag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ititag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_stim_Callback(hObject, eventdata, handles)
% hObject    handle to num_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_stim as text
%        str2double(get(hObject,'String')) returns contents of num_stim as a double


% --- Executes during object creation, after setting all properties.
function num_stim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_repeats_Callback(hObject, eventdata, handles)
% hObject    handle to num_repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_repeats as text
%        str2double(get(hObject,'String')) returns contents of num_repeats as a double


% --- Executes during object creation, after setting all properties.
function num_repeats_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to target_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_intensity as text
%        str2double(get(hObject,'String')) returns contents of target_intensity as a double


% --- Executes during object creation, after setting all properties.
function target_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pockels.
function pockels_Callback(hObject, eventdata, handles)
% hObject    handle to pockels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pockels


% --- Executes on button press in rand_order.
function rand_order_Callback(hObject, eventdata, handles)
% hObject    handle to rand_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rand_order


% --- Executes during object creation, after setting all properties.
function iti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sendvar.
function sendvar_Callback(hObject, eventdata, handles)
% hObject    handle to sendvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

instruction.type = 40;
varname = get(handles.varname,'String');
instruction.name = varname;
instruction.value = evalin('base',varname);

disp('sending instruction...')
[return_info,success,handles] = do_instruction(instruction,handles) 
guidata(hObject,handles)


function varname_Callback(hObject, eventdata, handles)
% hObject    handle to varname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of varname as text
%        str2double(get(hObject,'String')) returns contents of varname as a double


% --- Executes during object creation, after setting all properties.
function varname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tf_flag.
function tf_flag_Callback(hObject, eventdata, handles)
% hObject    handle to tf_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tf_flag



function ind_offset_Callback(hObject, eventdata, handles)
% hObject    handle to ind_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ind_offset as text
%        str2double(get(hObject,'String')) returns contents of ind_offset as a double


% --- Executes during object creation, after setting all properties.
function ind_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ind_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in get_obj_pos.
function get_obj_pos_Callback(hObject, eventdata, handles)
% hObject    handle to get_obj_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('getting new pos')
instruction.type = 21;
if isfield(handles,'close_socket')
    instruction.close_socket = handles.close_socket;
else
    instruction.close_socket = 1;
end
% 
% handles.sock
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)

disp('operation done, setting fields...')
set(handles.currX,'String',num2str(return_info.currX));
set(handles.currY,'String',num2str(return_info.currY));
set(handles.currZ,'String',num2str(return_info.currZ));

disp('sending to acq gui')
acq_gui_data = get_acq_gui_data();
acq_gui_data.data.obj_position_socket = [return_info.currX return_info.currY return_info.currZ];
handles.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
% acq_gui_data.success = 1;
acq_gui = findobj('Tag','acq_gui');
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)

function acq_gui_data = get_acq_gui_data()

acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);

% --- Executes on button press in precompute_grid.
function precompute_grid_Callback(hObject, eventdata, handles)
% hObject    handle to precompute_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

instruction.type = 50; 
fields_to_get = {'x_start','x_stop','y_start','y_stop',...
    'x_spacing','y_spacing','roi_radius'};
for i = 1:length(fields_to_get)
    instruction.(fields_to_get{i}) = str2double(get(handles.(fields_to_get{i}),'String'));
end
instruction.tf_flag = get(handles.tf_flag,'Value');


function y_start_Callback(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_start as text
%        str2double(get(hObject,'String')) returns contents of y_start as a double


% --- Executes during object creation, after setting all properties.
function y_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_stop_Callback(hObject, eventdata, handles)
% hObject    handle to y_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_stop as text
%        str2double(get(hObject,'String')) returns contents of y_stop as a double


% --- Executes during object creation, after setting all properties.
function y_stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_stop (see GCBO)
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



function x_start_Callback(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_start as text
%        str2double(get(hObject,'String')) returns contents of x_start as a double


% --- Executes during object creation, after setting all properties.
function x_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_stop_Callback(hObject, eventdata, handles)
% hObject    handle to x_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_stop as text
%        str2double(get(hObject,'String')) returns contents of x_stop as a double


% --- Executes during object creation, after setting all properties.
function x_stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_stop (see GCBO)
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



function roi_radius_Callback(hObject, eventdata, handles)
% hObject    handle to roi_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roi_radius as text
%        str2double(get(hObject,'String')) returns contents of roi_radius as a double


% --- Executes during object creation, after setting all properties.
function roi_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tf_test.
function tf_test_Callback(hObject, eventdata, handles)
% hObject    handle to tf_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% fields_to_get = {'z_start','z_stop','z_spacing'};
handles.close_socket = 0;
guidata(hObject,handles);
% z_start = str2double(get(handles.z_start,'String'));
% z_stop = str2double(get(handles.z_stop,'String'));
% z_spacing = str2double(get(handles.z_spacing,'String'));
% z_offsets = z_start:z_spacing:z_stop;
% z_offsets = [-70 -50 -30 -20 -10 0 10 20 30 50 70]';
% z_offsets = [-50 -10 0 10 50]';

z_offsets = [-20 0 20]';
obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];

update_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
% pause(.1)
% get_obj_pos_Callback(hObject, eventdata, handles)
% handles = guidata(hObject);
% handles.data.obj_pos

start_position = handles.data.obj_position;
% build obj_positions
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);
num_repeats = str2double(get(handles.tf_test_num_repeats,'String'));
obj_positions = repmat(obj_positions,num_repeats,1);
if get(handles.rand_order,'Value')
    obj_positions = obj_positions(randperm(size(obj_positions,1)),:);
end
% assignin('base','obj_positions',obj_positions)
guidata(hObject,handles);
% pause(.1)


num_trials = size(obj_positions,1);
for i = 1:num_trials
    % move obj
    set(handles.thenewx,'String',num2str(obj_positions(i,1)))
    set(handles.thenewy,'String',num2str(obj_positions(i,2)))
    set(handles.thenewz,'String',num2str(obj_positions(i,3)))
    obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
%     pause(.5)
    % store/confirm new position
%     get_obj_pos_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    
    % handles.close_socket = 1;
%     set(handles.ind_offset,'String','0')
    
%     if i ~= 1
%         instruction.type = 31; % RETRIGGER
%         instruction.close_socket = 0;
%         [return_info,success,handles] = do_instruction(instruction,handles);
%         guidata(hObject,handles)
%     end
    build_seq_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    acq_gui_data = get_acq_gui_data();
    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    acq_gui = findobj('Tag','acq_gui');
    guidata(acq_gui,acq_gui_data)
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
    set(acq_gui_data.trigger_seq,'Value',1)
    % set(acq_gui_data.conditions,'Value',0)
    set(acq_gui_data.loop_count,'String',num2str(1))
%     set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.run,'String','Prepping...')
%     waitfig = warndlg('Is SlideBook Ready?');
%     waitfor(waitfig)
    pause(3.0)
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
end

guidata(hObject,handles);
set(acq_gui_data.trigger_seq,'Value',0)
% move obj
handles.close_socket = 1;
set(handles.thenewx,'String',num2str(start_position(1)))
set(handles.thenewy,'String',num2str(start_position(2)))
set(handles.thenewz,'String',num2str(start_position(3)))
obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
pause(.1)

% get_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);





function tf_test_num_stim_Callback(hObject, eventdata, handles)
% hObject    handle to tf_test_num_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tf_test_num_stim as text
%        str2double(get(hObject,'String')) returns contents of tf_test_num_stim as a double


% --- Executes during object creation, after setting all properties.
function tf_test_num_stim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tf_test_num_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_start_Callback(hObject, eventdata, handles)
% hObject    handle to z_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_start as text
%        str2double(get(hObject,'String')) returns contents of z_start as a double


% --- Executes during object creation, after setting all properties.
function z_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_stop_Callback(hObject, eventdata, handles)
% hObject    handle to z_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_stop as text
%        str2double(get(hObject,'String')) returns contents of z_stop as a double


% --- Executes during object creation, after setting all properties.
function z_stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_stop (see GCBO)
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


% --- Executes on button press in obj_go_to.
function obj_go_to_Callback(hObject, eventdata, handles)
% hObject    handle to obj_go_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('moving obj')
instruction.type = 60; %MOVE_OBJ
instruction.theNewX = str2double(get(handles.thenewx,'String'));
instruction.theNewY = str2double(get(handles.thenewy,'String'));
instruction.theNewZ = str2double(get(handles.thenewz,'String'));
disp('sending instruction...')
[return_info,success,handles] = do_instruction(instruction,handles) ;
guidata(hObject,handles)

disp('operation done, setting fields...')
set(handles.currX,'String',num2str(return_info.currX));
set(handles.currY,'String',num2str(return_info.currY));
set(handles.currZ,'String',num2str(return_info.currZ));

disp('sending to acq gui')
acq_gui_data = get_acq_gui_data();
acq_gui_data.data.obj_position_socket = [return_info.currX return_info.currY return_info.currZ];
handles.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
% acq_gui_data.success = 1;
acq_gui = findobj('Tag','acq_gui');
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)

function thenewx_Callback(hObject, eventdata, handles)
% hObject    handle to thenewx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thenewx as text
%        str2double(get(hObject,'String')) returns contents of thenewx as a double


% --- Executes during object creation, after setting all properties.
function thenewx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thenewx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thenewy_Callback(hObject, eventdata, handles)
% hObject    handle to thenewy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thenewy as text
%        str2double(get(hObject,'String')) returns contents of thenewy as a double


% --- Executes during object creation, after setting all properties.
function thenewy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thenewy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thenewz_Callback(hObject, eventdata, handles)
% hObject    handle to thenewz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thenewz as text
%        str2double(get(hObject,'String')) returns contents of thenewz as a double


% --- Executes during object creation, after setting all properties.
function thenewz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thenewz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in close_sock.
function close_sock_Callback(hObject, eventdata, handles)
% hObject    handle to close_sock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'sock')
    disp('closing socket')
    msclose(handles.sock);
    handles = rmfield(handles,'sock');
    guidata(hObject,handles)
end



function tf_test_num_repeats_Callback(hObject, eventdata, handles)
% hObject    handle to tf_test_num_repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tf_test_num_repeats as text
%        str2double(get(hObject,'String')) returns contents of tf_test_num_repeats as a double


% --- Executes during object creation, after setting all properties.
function tf_test_num_repeats_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tf_test_num_repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_cell1_pos.
function set_cell1_pos_Callback(hObject, eventdata, handles)
% hObject    handle to set_cell1_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);

acq_gui_data.data.cell_pos = handles.data.obj_position;
set(acq_gui_data.cell_x,'String',num2str(handles.data.obj_position(1)));
set(acq_gui_data.cell_y,'String',num2str(handles.data.obj_position(2)));
set(acq_gui_data.cell_z,'String',num2str(handles.data.obj_position(3)));
guidata(acq_gui, acq_gui_data);
