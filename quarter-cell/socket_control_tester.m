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


% Last Modified by GUIDE v2.5 11-Sep-2017 12:53:26


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
% instruction.close_socket = get(handles.close_socket_check,'Value');
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
function [handles, acq_gui,acq_gui_data] = update_obj_pos_Callback(hObject, eventdata, handles)
% hObject    handle to update_obj_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Getting current obj pos...')
instruction.type = 20; %GET_OBJ_POS
% instruction.reset = 1;
instruction.close_socket = get(handles.close_socket_check,'Value');
[return_info,success,handles] = do_instruction(instruction,handles);

guidata(hObject,handles)

disp('operation done, display result...')
set(handles.currX,'String',num2str(return_info.currX));
set(handles.currY,'String',num2str(return_info.currY));
set(handles.currZ,'String',num2str(return_info.currZ));

disp('sending to acq gui...')
[acq_gui, acq_gui_data] = get_acq_gui_data();
acq_gui_data.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
handles.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
% acq_gui_data.success = 1;
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)



function [return_info, success, handles] = do_instruction(instruction, handles)

instruction.close_socket = get(handles.close_socket_check,'Value');
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
% if isfield(handles,'close_socket')

%     instruction.close_socket = get(handles.close_socket_check,'Value');

% else
%     instruction.close_socket = 1;
% end
pause(.1)
disp('sending instruction...')
mssend(handles.sock,instruction);
disp('getting return info...')
pause(.1)
return_info = [];
if isfield(instruction,'get_return')
    get_return = instruction.get_return;
else
    get_return = 1;
end
if get_return
    while isempty(return_info)
        [return_info, success] = msrecv(handles.sock,5);
    end
    assignin('base','return_info',return_info)
end
% success = 1;

if instruction.close_socket
    disp('closing socket')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
end



% --- Executes on button press in build_seq.
function [handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles)
% hObject    handle to build_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% rng(1234)
num_stim = str2double(get(handles.num_stim,'String'));

sequence_base.start = 0;
sequence_base.duration = str2double(get(handles.duration,'String'))*1000;
all_powers = strread(get(handles.target_intensity,'String'));
sequence_base.power = all_powers(1);
sequence_base.filter_configuration = 'Femto Phasor';
sequence_base.precomputed_target_index = 1;

sequence(num_stim) = sequence_base;
start_time = 1.0*1000; % hard set to 1 second for now
iti = str2double(get(handles.iti,'String'))*1000;

target_power = str2double(get(handles.target_intensity,'String'));
ind_mult = str2double(get(handles.ind_mult,'String'));
count = 1;
ind_offset = str2double(get(handles.ind_offset,'String'));
repeat_start_ind = str2double(get(handles.repeat_start_ind,'String'));
num_repeats = str2double(get(handles.num_repeats,'String'));
for k = 1:length(all_powers)
    for i = 1:num_stim

        if i >= repeat_start_ind
            this_repeat = num_repeats;
        else
            this_repeat = 1;
        end
        for j = 1:this_repeat
            sequence(count) = sequence_base;
            sequence(count).power = all_powers(k);
            sequence(count).precomputed_target_index = (i + ind_offset)*ind_mult;

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
end
num_stim = length(sequence);

if num_stim > 1 && get(handles.rand_order,'Value')
    
%     order = zeros((num_stim*num_repeats,1);
%     for i = 1:num_repeats
%         order((i-1)*num_stim+1:i*num_stim) = randperm(num_stim);
%     end
    order = randperm(num_stim);
    
else
    order = 1:num_stim;%repmat(1:num_stim,1,num_repeats);
    
end

% precomputed_target = precomputed_target(order);
sequence = sequence(order);


for i = 1:length(sequence)
    sequence(i).start = start_time + (i-1)*(iti + sequence_base.duration);
end

time_padding = 5; % in seconds
total_duration = (sequence(end).start + iti)/1000 + time_padding;


instruction.sequence = sequence;
instruction.tf_flag = get(handles.tf_flag,'Value');
instruction.total_duration = total_duration;
% if ~isfield(handles,'close_socket')
%     handles.close_socket = get(handles.close_socket_check,'Value');
% end
guidata(hObject,handles)
instruction.close_socket = get(handles.close_socket_check,'Value');
if get(handles.power,'Value')
    instruction.target_power = target_power;
else
    instruction.target_power = NaN;
end

instruction.type = 30; %SEND SEQ
handles.sequence = sequence;
handles.total_duration = total_duration;
instruction.waittime = total_duration + 120;
instruction.set_trigger = get(handles.set_seq_trigger,'Value');
disp('sending instruction...')
[return_info,success,handles] = do_instruction(instruction,handles);
[acq_gui,acq_gui_data] = get_acq_gui_data();
acq_gui_data.data.stim_key =  return_info.stim_key;
acq_gui_data.data.sequence =  return_info.sequence;
acq_gui = findobj('Tag','acq_gui');
guidata(acq_gui,acq_gui_data)

if get(handles.set_trial_length,'Value')
    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
end
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
% if isfield(handles,'close_socket')

% else
%     instruction.close_socket = 1;
% end
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

function [acq_gui, acq_gui_data] = get_acq_gui_data()

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
set(handles.close_socket_check,'Value',0)
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
hset(handles.close_socket_check,'Value',1)
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
function [handles,acq_gui,acq_gui_data] = obj_go_to_Callback(hObject, eventdata, handles)
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
acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);
acq_gui_data.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
handles.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
% acq_gui_data.success = 1;

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


wdlg = warndlg('Are you sure?');
waitfor(wdlg)


if isfield(handles,'sock')
    disp('closing socket')
    msclose(handles.sock);
    handles = rmfield(handles,'sock');
    guidata(hObject,handles)
else
    disp('no socket')
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

handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);

acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);

handles.data.cell1_pos = handles.data.obj_position;
guidata(hObject,handles)
acq_gui_data.data.cell_pos = handles.data.obj_position;
set(acq_gui_data.cell_x,'String',num2str(handles.data.obj_position(1)));
set(acq_gui_data.cell_y,'String',num2str(handles.data.obj_position(2)));
set(acq_gui_data.cell_z,'String',num2str(handles.data.obj_position(3)));
guidata(acq_gui, acq_gui_data);


% --- Executes on button press in neural_resp_prot.
function neural_resp_prot_Callback(hObject, eventdata, handles)
% hObject    handle to neural_resp_prot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.close_socket_check,'Value',0)
guidata(hObject,handles);

z_offsets = -70:10:70;
z_offsets = z_offsets';
grid_edge_size = [3 3 3 3 3 3 5 9 5 3 3 3 3 3 3]';

obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];

% update_obj_pos_Callback(hObject, eventdata, handles)
set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
handles = guidata(hObject);

start_position = handles.data.obj_position;
num_repeats = 5;
set(handles.num_repeats,'String',num2str(num_repeats));

% build obj_positions and rep for num_repeats
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);
obj_positions = repmat(obj_positions,num_repeats,1);
all_grid_sizes = repmat(grid_edge_size,num_repeats,1).^2;
if get(handles.rand_order,'Value')
    order = randperm(size(obj_positions,1));
    obj_positions = obj_positions(order,:);
    all_grid_sizes = all_grid_sizes(order);
end
% assignin('base','obj_positions',obj_positions)
guidata(hObject,handles);


% get Acq handles
acq_gui = findobj('Tag','acq_gui');
acq_gui_data = get_acq_gui_data();
% shift focus
figure(acq_gui)

% confirm everything ready
user_confirm = msgbox('Cell-attached? Test pulse off? V_m set to 0? I_h set to 0?');
waitfor(user_confirm)

power_curve = '10 25 50 100 150';
power_curve_num = strread(power_curve);
% set(acq_gui.use_lut,'Value',1);
% set(acq_gui.use_LED,'Value',0);
% set(acq_gui.use_2P,'Value',1);

% run power curve in cell-attached
% set sequence paraqms
set(handles.num_stim,'String',num2str(1));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(1.0));
% set(handles.num_repeats,'String',num2str(5));
set(handles.target_intensity,'String',power_curve)
% build sequence
build_seq_Callback(hObject, eventdata, handles)
pause(2.0)
handles = guidata(hObject);
acq_gui_data = guidata(acq_gui);
% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.Cell1_type_popup,'Value',3)
set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
guidata(acq_gui,acq_gui_data)
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
set(acq_gui_data.Highpass_cell1_check, 'Value',0)
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)
% cleanup

% show data
cur_trial = acq_gui_data.data.sweep_counter;
this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
[trace_stack] = ...
    get_stim_stack(acq_gui_data.data,cur_trial,...
    length(this_seq));
trace_grid = cell(length(power_curve_num),1);
for i = 1:length(power_curve_num)
    trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
end
cell_attached_spikes_fig = figure;
plot_trace_stack_grid(trace_grid,Inf,1,0);

% tell user to break in and be in VC
user_confirm = msgbox('Break in! Test pulse off?');
waitfor(user_confirm)

% do single testpulse trial to get Rs
% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.Cell1_type_popup,'Value',1)
set(acq_gui_data.trial_length,'String',1.0)
acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
set(acq_gui_data.trigger_seq,'Value',0)
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)

% tell user to switch to I=0
user_confirm = msgbox('Please switch Multiclamp to CC with I = 0');
waitfor(user_confirm)

% run intrinsic ephys
% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.Cell1_type_popup,'Value',2)
acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
guidata(acq_gui,acq_gui_data);
set(acq_gui_data.test_pulse,'Value',0)
set(acq_gui_data.trigger_seq,'Value',0)
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)

% get baseline Vm
prompt = {'Enter intrinsic Vm:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'-60'};
Vm = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

% run power curve on cell in CC
% set sequence paraqms
set(handles.num_stim,'String',num2str(1));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(1.0));
set(handles.num_repeats,'String',num2str(5));
set(handles.target_intensity,'String','10 25 50 100 150')
% build seq
build_seq_Callback(hObject, eventdata, handles)
pause(2.0)
handles = guidata(hObject);
acq_gui_data = guidata(acq_gui);
% set acq params
set(acq_gui_data.run,'String','Prepping...')
% set(acq_gui_data.Cell1_type_popup,'Value',2)
set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
guidata(acq_gui,acq_gui_data)
set(acq_gui_data.test_pulse,'Value',0)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)

% show data
cur_trial = acq_gui_data.data.sweep_counter;
this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
[trace_stack] = ...
    get_stim_stack(acq_gui_data.data,cur_trial,...
    length(this_seq));
trace_grid = cell(length(power_curve_num),1);
for i = 1:length(power_curve_num)
    trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
end
cc_power_curve_fig = figure;
plot_trace_stack_grid(trace_grid,Inf,1,0);

% get this_cell_power
prompt = {'Enter Target Power For Cell:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'50'};
this_cell_power = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

% run power curve on cell in VC
% tell user to switch to VC with Vm offset to ealier Vm
user_confirm = msgbox(['In VC with Vm set to ' num2str(Vm)]);
waitfor(user_confirm)

% set sequence paraqms
% set(handles.num_stim,'String',num2str(1));
% set(handles.duration,'String',num2str(.003));
% set(handles.iti,'String',num2str(1.0));
set(handles.num_repeats,'String',num2str(3));
% build seq
build_seq_Callback(hObject, eventdata, handles)
pause(2.0)
acq_gui_data = guidata(acq_gui);
handles = guidata(hObject);
% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.test_pulse,'Value',0)
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)


% GO SPATIAL
user_confirm = msgbox(['In CC with Ih sucht that Vm is set to ' num2str(Vm)]);
waitfor(user_confirm)

% CHECK VM

num_trials = size(obj_positions,1);

% set params one time
set(handles.rand_order,'Value',1);
set(handles.target_intensity,'String',this_cell_power)
set(acq_gui_data.test_pulse,'Value',0)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.test_pulse,'Value',0)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
set(handles.num_repeats,'String',num2str(1));
for i = 1:num_trials
    % move obj
    set(handles.thenewx,'String',num2str(obj_positions(i,1)))
    set(handles.thenewy,'String',num2str(obj_positions(i,2)))
    set(handles.thenewz,'String',num2str(obj_positions(i,3)))
    obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
    handles = guidata(hObject);
    
    % set grid size
    set(handles.num_stim,'String',num2str(all_grid_sizes(i)));
    build_seq_Callback(hObject, eventdata, handles)
    pause(2.0)
    handles = guidata(hObject);
    acq_gui_data = guidata(acq_gui);
    set(acq_gui_data.trial_length,'String',num2str(ceil(handles.total_duration) + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    guidata(acq_gui,acq_gui_data)
    
    set(acq_gui_data.run,'String','Prepping...')
%     pause(3.0)
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
    
end

guidata(hObject,handles);
set(acq_gui_data.trigger_seq,'Value',0)
% move obj
set(handles.close_socket_check,'Value',1)
set(handles.thenewx,'String',num2str(start_position(1)))
set(handles.thenewy,'String',num2str(start_position(2)))
set(handles.thenewz,'String',num2str(start_position(3)))
obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
pause(.1)

% get_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);


% --- Executes on button press in neural_resp_prot_2.
function neural_resp_prot_2_Callback(hObject, eventdata, handles)
% hObject    handle to neural_resp_prot_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% fields_to_get = {'z_start','z_stop','z_spacing'};
set(handles.close_socket_check,'Value',0)
set(handles.rand_order,'Value',1)
guidata(hObject,handles);
% z_start = str2double(get(handles.z_start,'String'));
% z_stop = str2double(get(handles.z_stop,'String'));
% z_spacing = str2double(get(handles.z_spacing,'String'));
% z_offsets = z_start:z_spacing:z_stop;
% z_offsets = [-70 -50 -30 -20 -10 0 10 20 30 50 70]';
% z_offsets = [-50 -10 0 10 50]';

z_offsets = [-40 -20 0 20 40]';
grid_edge_size = [1 3 5 3 1]';
obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];

set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
handles = guidata(hObject);
% pause(.1)
% get_obj_pos_Callback(hObject, eventdata, handles)
% handles = guidata(hObject);
% handles.data.obj_pos
num_repeats = 5;
set(handles.num_repeats,'String',num2str(num_repeats));
start_position = handles.data.obj_position;
% build obj_positions
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);
% num_repeats = str2double(get(handles.tf_test_num_repeats,'String'));
obj_positions = repmat(obj_positions,num_repeats,1);
all_grid_sizes = repmat(grid_edge_size,num_repeats,1).^2;
if get(handles.rand_order,'Value')
    order = randperm(size(obj_positions,1));
    obj_positions = obj_positions(order,:);
    all_grid_sizes = all_grid_sizes(order);
end
% assignin('base','obj_positions',obj_positions)
guidata(hObject,handles);
% pause(.1)


% get Acq handles
acq_gui = findobj('Tag','acq_gui');
acq_gui_data = get_acq_gui_data();
% shift focus
figure(acq_gui)

% confirm everything ready
user_confirm = msgbox('Cell-attached? Test pulse off? V_m set to 0? I_h set to 0?');
waitfor(user_confirm)

power_curve = '10 25 50 100 150';
power_curve_num = strread(power_curve);
% set(acq_gui.use_lut,'Value',1);
% set(acq_gui.use_LED,'Value',0);
% set(acq_gui.use_2P,'Value',1);

% run power curve in cell-attached
% set sequence paraqms
set(handles.num_stim,'String',num2str(1));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.5));
% set(handles.num_repeats,'String',num2str(5));
set(handles.target_intensity,'String',power_curve)
% build sequence
build_seq_Callback(hObject, eventdata, handles)
pause(2.0)
handles = guidata(hObject);
acq_gui_data = guidata(acq_gui);
% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.Cell1_type_popup,'Value',3)
set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
guidata(acq_gui,acq_gui_data)
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
set(acq_gui_data.Highpass_cell1_check, 'Value',0)
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)
% cleanup

% show data
try
    cur_trial = acq_gui_data.data.sweep_counter;
    this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
    [trace_stack] = ...
        get_stim_stack(acq_gui_data.data,cur_trial,...
        length(this_seq));
    trace_grid = cell(length(power_curve_num),1);
    for i = 1:length(power_curve_num)
        trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
    end
    cell_attached_spikes_fig = figure;
    plot_trace_stack_grid(trace_grid,Inf,1,0);
catch e
    disp('failed to plot data')
end

% whole cell or cell-attached?
% Construct a questdlg with three options
choice = questdlg('Go whole cell?', ...
	'Exp type?', ...
	'Current Clamp','Cell Attached','Cell Attached');
% Handle response
switch choice
    case 'Current Clamp'
        currentclamp = 1;
    case 'Cell Attached'
        currentclamp = 0;

end

if currentclamp
    % tell user to break in and be in VC
    user_confirm = msgbox('Break in! Test pulse off?');
    waitfor(user_confirm)
    
    
    % do single testpulse trial to get Rs
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    set(acq_gui_data.trial_length,'String',1.0)
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)

    % tell user to switch to I=0
    user_confirm = msgbox('Please switch Multiclamp to CC with I = 0');
    waitfor(user_confirm)

    % run intrinsic ephys
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',2)
    acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
    guidata(acq_gui,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',0)
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)

    % get baseline Vm
    prompt = {'Enter intrinsic Vm:'};
    dlg_title = 'Input';
    num_lines = 1;
    defaultans = {'-60'};
    Vm = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

    % run power curve on cell in CC
    % set sequence paraqms
    set(handles.num_stim,'String',num2str(1));
    set(handles.duration,'String',num2str(.003));
    set(handles.iti,'String',num2str(0.5));
    set(handles.num_repeats,'String',num2str(5));
    set(handles.target_intensity,'String','10 25 50 100 150')
    % build seq
    build_seq_Callback(hObject, eventdata, handles)
    pause(2.0)
    handles = guidata(hObject);
    acq_gui_data = guidata(acq_gui);
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    % set(acq_gui_data.Cell1_type_popup,'Value',2)
    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    guidata(acq_gui,acq_gui_data)
    set(acq_gui_data.test_pulse,'Value',0)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
    set(acq_gui_data.trigger_seq,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)

    % show data
    try
        cur_trial = acq_gui_data.data.sweep_counter;
        this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
        [trace_stack] = ...
            get_stim_stack(acq_gui_data.data,cur_trial,...
            length(this_seq));
        trace_grid = cell(length(power_curve_num),1);
        for i = 1:length(power_curve_num)
            trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
        end
        cc_power_curve_fig = figure;
        plot_trace_stack_grid(trace_grid,Inf,1,0);
    catch e
        disp('failed to show data')
    end

    % get this_cell_power
    prompt = {'Enter Target Power For Cell:'};
    dlg_title = 'Input';
    num_lines = 1;
    defaultans = {'50'};
    this_cell_power = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

    % run power curve on cell in VC
    % tell user to switch to VC with Vm offset to ealier Vm
    user_confirm = msgbox(['In VC with Vm set to ' num2str(Vm)]);
    waitfor(user_confirm)

    % set sequence paraqms
    % set(handles.num_stim,'String',num2str(1));
    % set(handles.duration,'String',num2str(.003));
    % set(handles.iti,'String',num2str(1.0));
    set(handles.num_repeats,'String',num2str(3));
    % build seq
    build_seq_Callback(hObject, eventdata, handles)
    pause(2.0)
    acq_gui_data = guidata(acq_gui);
    handles = guidata(hObject);
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.test_pulse,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)


    % GO SPATIAL
    user_confirm = msgbox(['In CC with Ih sucht that Vm is set to ' num2str(Vm)]);
    waitfor(user_confirm)
end

% get this_cell_power
prompt = {'Enter 3 Powers For Cell:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'50 100 150'};
this_cell_power = inputdlg(prompt,dlg_title,num_lines,defaultans)
set(handles.target_intensity,'String',this_cell_power{1});

num_trials = size(obj_positions,1);
set(acq_gui_data.test_pulse,'Value',0)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
% set(acq_gui_data.conditions,'Value',0)
set(acq_gui_data.loop_count,'String',num2str(1))
set(handles.num_repeats,'String',num2str(1));
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
    set(handles.num_stim,'String',num2str(all_grid_sizes(i)));
    build_seq_Callback(hObject, eventdata, handles)
    
    handles = guidata(hObject);
    acq_gui_data = get_acq_gui_data();
    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
%     acq_gui = findobj('Tag','acq_gui');
    guidata(acq_gui,acq_gui_data)

%     set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.run,'String','Prepping...')
%     waitfig = warndlg('Is SlideBook Ready?');
%     waitfor(waitfig)
%     pause(3.0)
    pause(2.5)
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
end

guidata(hObject,handles);
set(acq_gui_data.trigger_seq,'Value',0)
% move obj
set(handles.close_socket_check,'Value',1)
set(handles.thenewx,'String',num2str(start_position(1)))
set(handles.thenewy,'String',num2str(start_position(2)))
set(handles.thenewz,'String',num2str(start_position(3)))
obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
pause(.1)

% get_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);


% --- Executes on button press in set_slice_top.
function set_slice_top_Callback(hObject, eventdata, handles)
% hObject    handle to set_slice_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);

acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);
handles.data.slice_z_top = handles.data.obj_position;
acq_gui_data.data.slice_z_top = handles.data.obj_position;
guidata(acq_gui, acq_gui_data);
guidata(hObject, handles);


% --- Executes on button press in set_pia.
function set_pia_Callback(hObject, eventdata, handles)
% hObject    handle to set_pia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);

acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);
handles.data.pia_pos = handles.data.obj_position;
acq_gui_data.data.pia_pos = handles.data.obj_position;
guidata(acq_gui, acq_gui_data);
guidata(hObject, handles);


% --- Executes on button press in set_white_matter.
function set_white_matter_Callback(hObject, eventdata, handles)
% hObject    handle to set_white_matter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[acq_gui, acq_gui_data] = get_acq_gui_data;
assignin('base','handles',handles)
assignin('base','acq_gui_data',acq_gui_data);
% handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);
% 
% acq_gui = findobj('Tag','acq_gui');
% acq_gui_data = guidata(acq_gui);
% 
% handles.data.white_matter_pos = handles.data.obj_position;
% acq_gui_data.data.white_matter_pos = handles.data.obj_position;
% guidata(acq_gui, acq_gui_data);
% guidata(hObject, handles);


% --- Executes on button press in close_socket_check.
function close_socket_check_Callback(hObject, eventdata, handles)
% hObject    handle to close_socket_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of close_socket_check


% --- Executes on button press in neural_resp_prot3.
function neural_resp_prot3_Callback(hObject, eventdata, handles)
% hObject    handle to neural_resp_prot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% fields_to_get = {'z_start','z_stop','z_spacing'};
set(handles.close_socket_check,'Value',0)
set(handles.rand_order,'Value',1)
guidata(hObject,handles);
% z_start = str2double(get(handles.z_start,'String'));
% z_stop = str2double(get(handles.z_stop,'String'));
% z_spacing = str2double(get(handles.z_spacing,'String'));
% z_offsets = z_start:z_spacing:z_stop;
% z_offsets = [-70 -50 -30 -20 -10 0 10 20 30 50 70]';
% z_offsets = [-50 -10 0 10 50]';


z_offsets = [-90 -50 -20 0 20 50 90]';
grid_edge_size = [7 7 9 9 9 7 7]';

obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];

set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
handles = guidata(hObject);
% pause(.1)
% get_obj_pos_Callback(hObject, eventdata, handles)
% handles = guidata(hObject);
% handles.data.obj_pos
num_repeats = 1;
set(handles.num_repeats,'String',num2str(1));
start_position = handles.data.obj_position;
% build obj_positions
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);

% num_repeats = str2double(get(handles.tf_test_num_repeats,'String'));
obj_positions = repmat(obj_positions,num_repeats,1);
all_grid_sizes = repmat(grid_edge_size,num_repeats,1).^2;
if get(handles.rand_order,'Value')
    order = randperm(size(obj_positions,1));
    obj_positions = obj_positions(order,:);
    all_grid_sizes = all_grid_sizes(order);
end
% assignin('base','obj_positions',obj_positions)
guidata(hObject,handles);
% pause(.1)


% get Acq handles
acq_gui = findobj('Tag','acq_gui');
acq_gui_data = get_acq_gui_data();
% shift focus
figure(acq_gui)

% confirm everything ready
user_confirm = msgbox('Cell-attached? Test pulse off? V_m set to 0? I_h set to 0?');
waitfor(user_confirm)


power_curve = '10 25 50 75 100 150';

power_curve_num = strread(power_curve);
% set(acq_gui.use_lut,'Value',1);
% set(acq_gui.use_LED,'Value',0);
% set(acq_gui.use_2P,'Value',1);

% run power curve in cell-attached
% set sequence paraqms
set(handles.num_stim,'String',num2str(1));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.5));
set(handles.num_repeats,'String',num2str(5));
set(handles.target_intensity,'String',power_curve)

set(handles.ind_mult,'String',num2str(1))
offsets_powcurve = [-20 0 20]';
grid_sizes_powcurve = ([3 5 3].^2)';
num_locs = 9;
power_curve_inds = randsample(length(offsets_powcurve),num_locs,1);
offsets_powcurve = offsets_powcurve(power_curve_inds);
grid_sizes_powcurve = grid_sizes_powcurve(power_curve_inds);
power_curve_obj_positions = [zeros(length(offsets_powcurve),1) zeros(length(offsets_powcurve),1) offsets_powcurve];
power_curve_obj_positions = bsxfun(@plus,power_curve_obj_positions,handles.data.obj_position);
power_curve_obj_positions = [handles.data.obj_position; power_curve_obj_positions];

% run on cell power curve cell-attached

% build sequence
build_seq_Callback(hObject, eventdata, handles)
pause(2.0)
handles = guidata(hObject);
acq_gui_data = guidata(acq_gui);
% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.Cell1_type_popup,'Value',3)
set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
guidata(acq_gui,acq_gui_data)
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
set(acq_gui_data.Highpass_cell1_check, 'Value',0)
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)
% cleanup

% show data
try
    cur_trial = acq_gui_data.data.sweep_counter;
    this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
    [trace_stack] = ...
        get_stim_stack(acq_gui_data.data,cur_trial,...
        length(this_seq),[this_seq.start]);

    trace_grid = cell(length(power_curve_num),1);
    for i = 1:length(power_curve_num)
        trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
    end
    cell_attached_spikes_fig = figure;
    plot_trace_stack_grid(trace_grid,Inf,1,0);
catch e
    disp('failed to plot data')
end


do_cell_attach_locs = 0;
choice = questdlg('Do more cell-attached locs?', ...
	'Do more cell-attached locs?', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        do_cell_attach_locs = 1;
    case 'No'
        do_cell_attach_locs = 0;
end


% run power curve at more locations
power_curve_grid_inds = zeros(size(grid_sizes_powcurve));

if do_cell_attach_locs
    for i = 1:num_locs
        % move obj
        if power_curve_obj_positions(i,3) ~= handles.data.obj_position(3)
            set(handles.thenewx,'String',num2str(power_curve_obj_positions(i,1)))
            set(handles.thenewy,'String',num2str(power_curve_obj_positions(i,2)))
            set(handles.thenewz,'String',num2str(power_curve_obj_positions(i,3)))
            obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

            handles = guidata(hObject);
        else
            disp('obj staying put')
        end

        set(handles.num_stim,'String',num2str(1));
        power_curve_grid_inds(i) = randsample(grid_sizes_powcurve(i),1);
        set(handles.ind_mult,'String',num2str(power_curve_grid_inds(i)));
        build_seq_Callback(hObject, eventdata, handles)

        handles = guidata(hObject);
        acq_gui_data = get_acq_gui_data();
        set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        guidata(acq_gui,acq_gui_data)

        set(acq_gui_data.run,'String','Prepping...')

        pause(2.5)
        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)
    end
    set(handles.ind_mult,'String',num2str(1));
    guidata(hObject,handles);
    set(acq_gui_data.trigger_seq,'Value',0)
    % move obj
    set(handles.thenewx,'String',num2str(start_position(1)))
    set(handles.thenewy,'String',num2str(start_position(2)))
    set(handles.thenewz,'String',num2str(start_position(3)))
    obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
    pause(.1)
end

% get_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);

do_whole_cell = 0;
choice = questdlg('Go Whole Cell?', ...
	'Go Whole Cell?', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        do_whole_cell = 1;
    case 'No'
        do_whole_cell = 0;
end

if do_whole_cell
    % tell user to break in and be in VC
    user_confirm = msgbox('Break in! Test pulse off?');
    waitfor(user_confirm)


    % do single testpulse trial to get Rs
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    set(acq_gui_data.trial_length,'String',1.0)
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)

    % tell user to switch to I=0
    user_confirm = msgbox('Please switch Multiclamp to CC with I = 0');
    waitfor(user_confirm)

    % run intrinsic ephys
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',2)
    acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
    guidata(acq_gui,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',0)
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)

    % get baseline Vm
    prompt = {'Enter intrinsic Vm:'};
    dlg_title = 'Input';
    num_lines = 1;
    defaultans = {'-65'};
    Vm = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

    run_cc = 0;
    choice = questdlg('Run CC power curves?', ...
        'Current Clamp Curves?', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            run_cc = 1;
        case 'No'
            run_cc = 0;
    end

    if run_cc
        % run power curve on cell in CC
        % set sequence paraqms
        set(handles.num_stim,'String',num2str(1));
        set(handles.duration,'String',num2str(.003));
        set(handles.iti,'String',num2str(0.5));
        set(handles.num_repeats,'String',num2str(5));
        set(handles.target_intensity,'String',power_curve)
        % build seq
        build_seq_Callback(hObject, eventdata, handles)
        pause(2.0)
        handles = guidata(hObject);
        acq_gui_data = guidata(acq_gui);
        % set acq params
        set(acq_gui_data.run,'String','Prepping...')
        % set(acq_gui_data.Cell1_type_popup,'Value',2)
        set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        guidata(acq_gui,acq_gui_data)
        set(acq_gui_data.test_pulse,'Value',0)
        set(acq_gui_data.loop,'Value',1)
        set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
        set(acq_gui_data.trigger_seq,'Value',1)
        set(acq_gui_data.loop_count,'String',num2str(1))
        % run trial
        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)

        % show data
        try
            cur_trial = acq_gui_data.data.sweep_counter;
            this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
            [trace_stack] = ...
                get_stim_stack(acq_gui_data.data,cur_trial,...
                length(this_seq),[this_seq.start]);
            trace_grid = cell(length(power_curve_num),1);
            for i = 1:length(power_curve_num)
                trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
            end
            cc_power_curve_fig = figure;
            plot_trace_stack_grid(trace_grid,Inf,1,0);
        catch e
            disp('failed to plot data')
        end

        for i = 1:num_locs
            % move obj
            if power_curve_obj_positions(i,3) ~= handles.data.obj_position(3)
                set(handles.thenewx,'String',num2str(power_curve_obj_positions(i,1)))
                set(handles.thenewy,'String',num2str(power_curve_obj_positions(i,2)))
                set(handles.thenewz,'String',num2str(power_curve_obj_positions(i,3)))
                obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

                handles = guidata(hObject);
            else
                disp('obj staying put')
            end


            set(handles.num_stim,'String',num2str(1));
            if ~do_cell_attach_locs
                power_curve_grid_inds(i) = randsample(grid_sizes_powcurve(i),1);
            end
            set(handles.ind_mult,'String',num2str(power_curve_grid_inds(i)));
            build_seq_Callback(hObject, eventdata, handles)

            handles = guidata(hObject);
            acq_gui_data = get_acq_gui_data();
            set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
            acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
            guidata(acq_gui,acq_gui_data)

            set(acq_gui_data.run,'String','Prepping...')

            pause(2.5)
            acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
            waitfor(acq_gui_data.run,'String','Start')
            guidata(acq_gui,acq_gui_data)
        end
        set(handles.ind_mult,'String',num2str(1));

        guidata(hObject,handles);
        set(acq_gui_data.trigger_seq,'Value',0)
        % move obj
        set(handles.thenewx,'String',num2str(start_position(1)))
        set(handles.thenewy,'String',num2str(start_position(2)))
        set(handles.thenewz,'String',num2str(start_position(3)))
        obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
        pause(.1)

        % get_obj_pos_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        guidata(hObject,handles);
    end



    % run power curve on cell in VC
    % tell user to switch to VC with Vm offset to ealier Vm
    user_confirm = msgbox(['In VC with Vm set to ' num2str(Vm)]);
    waitfor(user_confirm)
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    % vc on cell power curve
    % set sequence params
    set(handles.num_stim,'String',num2str(1));
    set(handles.duration,'String',num2str(.003));
    % set(handles.iti,'String',num2str(1.0));

    % build seq
    build_seq_Callback(hObject, eventdata, handles)
    pause(2.0)
    acq_gui_data = guidata(acq_gui);
    handles = guidata(hObject);
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.test_pulse,'Value',1)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
    
    do_vc = 0;
    choice = questdlg('Go VC Spatial?', ...
        'Go VC Spatial?', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            do_vc = 1;
        case 'No'
            do_vc = 0;
    end
    
    if do_vc
        % get this_cell_power
        prompt = {'Enter Target Power For Cell:'};
        dlg_title = 'Input';
        num_lines = 1;
        defaultans = {'50'};
        this_cell_power = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));


        % GO SPATIAL

        set(handles.num_repeats,'String',num2str(1));
        num_trials = size(obj_positions,1);
        set(acq_gui_data.test_pulse,'Value',0)
        set(acq_gui_data.loop,'Value',1)
        set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
        set(acq_gui_data.trigger_seq,'Value',1)
        % set(handles.iti,'String',num2str(0.5));
        % set(acq_gui_data.conditions,'Value',0)
        set(acq_gui_data.loop_count,'String',num2str(1))
        set(handles.target_intensity,'String',this_cell_power)
        set(handles.num_repeats,'String',num2str(1));
        set(acq_gui_data.test_pulse,'Value',1)
        for i = 1:num_trials
            % move obj
            if obj_positions(i,3) ~= handles.data.obj_position(3)
                set(handles.thenewx,'String',num2str(obj_positions(i,1)))
                set(handles.thenewy,'String',num2str(obj_positions(i,2)))
                set(handles.thenewz,'String',num2str(obj_positions(i,3)))
                obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

                handles = guidata(hObject);
            else
                disp('obj staying put')
            end
            % handles.close_socket = 1;
        %     set(handles.ind_offset,'String','0')

        %     if i ~= 1
        %         instruction.type = 31; % RETRIGGER
        %         instruction.close_socket = 0;
        %         [return_info,success,handles] = do_instruction(instruction,handles);
        %         guidata(hObject,handles)
        %     end
            set(handles.num_stim,'String',num2str(all_grid_sizes(i)));
            build_seq_Callback(hObject, eventdata, handles)

            handles = guidata(hObject);
            acq_gui_data = get_acq_gui_data();
            set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
            acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        %     acq_gui = findobj('Tag','acq_gui');
            guidata(acq_gui,acq_gui_data)

        %     set(acq_gui_data.loop_count,'String',num2str(1))
            set(acq_gui_data.run,'String','Prepping...')
        %     waitfig = warndlg('Is SlideBook Ready?');
        %     waitfor(waitfig)
        %     pause(3.0)
            pause(2.5)
            acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
            waitfor(acq_gui_data.run,'String','Start')
            guidata(acq_gui,acq_gui_data)
        end
    end
end
guidata(hObject,handles);
set(acq_gui_data.trigger_seq,'Value',0)
% move obj
set(handles.close_socket_check,'Value',1)

set(handles.thenewx,'String',num2str(start_position(1)))
set(handles.thenewy,'String',num2str(start_position(2)))
set(handles.thenewz,'String',num2str(start_position(3)))
obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
pause(.1)

% get_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);

% end
% 

function ind_mult_Callback(hObject, eventdata, handles)
% hObject    handle to ind_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ind_mult as text
%        str2double(get(hObject,'String')) returns contents of ind_mult as a double


% --- Executes during object creation, after setting all properties.
function ind_mult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ind_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_trial_length.
function set_trial_length_Callback(hObject, eventdata, handles)
% hObject    handle to set_trial_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of set_trial_length


% --- Executes on button press in map.
function map_Callback(hObject, eventdata, handles)
% hObject    handle to map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% fields_to_get = {'z_start','z_stop','z_spacing'};
set(handles.close_socket_check,'Value',0)
set(handles.rand_order,'Value',1)
guidata(hObject,handles);

% set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
% handles = guidata(hObject);
% pause(.1)
% get_obj_pos_Callback(hObject, eventdata, handles)
% handles = guidata(hObject);
% drawnow
% start_position = handles.data.obj_position;


% get Acq handles
acq_gui = findobj('Tag','acq_gui');
acq_gui_data = get_acq_gui_data();
% shift focus
figure(acq_gui)

% confirm everything ready
% user_confirm = msgbox('Ready To Go?');
% waitfor(user_confirm)

% power_curve = '10 25 50 100 150';
% power_curve_num = strread(power_curve);
% set(acq_gui.use_lut,'Value',1);
% set(acq_gui.use_LED,'Value',0);
% set(acq_gui.use_2P,'Value',1);

% run power curve in cell-attached
% set sequence paraqms
% set(handles.num_stim,'String',num2str(1));
% set(handles.duration,'String',num2str(.003));
% set(handles.iti,'String',num2str(0.5));
% set(handles.num_repeats,'String',num2str(5));
% set(handles.target_intensity,'String',power_curve)
set(handles.ind_mult,'String',num2str(1))
% offsets_powcurve = [-20 -10 0 10 20]';
% grid_sizes_powcurve = ([3 5 5 5 3].^2)';
% num_locs = 9;
% power_curve_inds = randsample(length(offsets_powcurve),num_locs,1);
% offsets_powcurve = offsets_powcurve(power_curve_inds);
% grid_sizes_powcurve = grid_sizes_powcurve(power_curve_inds);
% power_curve_obj_positions = [zeros(length(offsets_powcurve),1) zeros(length(offsets_powcurve),1) offsets_powcurve];
% power_curve_obj_positions = bsxfun(@plus,power_curve_obj_positions,handles.data.obj_position);
% power_curve_obj_positions = [handles.data.obj_position; power_curve_obj_positions];

% run on cell power curve cell-attached
% build sequence

keep_going = 1;

% while keep_going
    
%     build_seq_Callback(hObject, eventdata, handles)
%     pause(10.0)
    handles = guidata(hObject);
    acq_gui_data = guidata(acq_gui);
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',3)
    % set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    % acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    guidata(acq_gui,acq_gui_data)
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
    set(acq_gui_data.trigger_seq,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    % set(acq_gui_data.Highpass_cell1_check, 'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
    % cleanup

    % show data
%     try
        cur_trial = acq_gui_data.data.sweep_counter;
        this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
        stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
        [trace1_stack,trace2_stack] = ...
            get_stim_stack(acq_gui_data.data,cur_trial,...
            length(this_seq));
        assignin('base','trace1_stack',trace1_stack)
        assignin('base','trace2_stack',trace2_stack)
        trace_grid1 = cell(17,17);
        trace_grid2 = cell(17,17);
        for i = 1:289
            inds = stim_key(i,[1 2])/20 + 9;
            trace_grid1{inds(1),inds(2)} = trace1_stack([this_seq.precomputed_target_index] == i,:);
            trace_grid2{inds(1),inds(2)} = trace2_stack([this_seq.precomputed_target_index] == i,:);
        end
        figure;
        compare_trace_stack_grid({trace_grid1,trace_grid2},Inf,5,[],0);
%     catch e
%         disp('failed to plot data')
%     end
    
%     answer = inputdlg('Enter new power, or put 0 to end');
%     answer = answer{1}
%     if strcmp(answer,'0')
%         keep_going = 0;
%     else
%         set(handles.target_intensity,'String','answer')
%     end
    
% end

set(handles.close_socket_check,'Value',1)
guidata(hObject,handles);

% set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
% handles = guidata(hObject);
% pause(.1)
% get_obj_pos_Callback(hObject, eventdata, handles)


% --- Executes on button press in map_plus_intrinsics.
function map_plus_intrinsics_Callback(hObject, eventdata, handles)
% hObject    handle to map_plus_intrinsics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.close_socket_check,'Value',0)
guidata(hObject,handles);

set_cell_pos = 0;
choice = questdlg('Set Cell Pos?', ...
	'Set Cell Pos?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        set_cell_pos = 1;
    case 'No'
        set_cell_pos = 0;
end

if set_cell_pos
    % confirm everything ready
    user_confirm = msgbox('SLM Zero-order over patched cell in 2P image?');
    waitfor(user_confirm)

    set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    handles = guidata(hObject);
end

user_confirm = msgbox('SLM Zero-order over desired mapping start location?');
waitfor(user_confirm)

handles = update_obj_pos_Callback(hObject, eventdata, handles);


% tell user to break in and be in VC
user_confirm = msgbox('Break in! Test pulse off?');
waitfor(user_confirm)


acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);


% do single testpulse trial to get Rs
% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.Cell1_type_popup,'Value',1)
set(acq_gui_data.trial_length,'String',1.0)
acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
set(acq_gui_data.trigger_seq,'Value',0)
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)


do_intrinsics = 0;
choice = questdlg('Do intrinsics?', ...
	'Do intrinsics?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        do_intrinsics = 1;
    case 'No'
        do_intrinsics = 0;
end

if do_intrinsics
    % tell user to switch to I=0
    user_confirm = msgbox('Please switch Multiclamp to CC with I = 0');
    waitfor(user_confirm)

    % run intrinsic ephys
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',2)
    acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
    guidata(acq_gui,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',0)
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial

    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
end


user_confirm = msgbox('Please switch Multiclamp to VC with desired holding current. Rs is good?');
waitfor(user_confirm)

% MAP IT
z_offsets = [0]';
obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];
start_position = handles.data.obj_position;
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);

guidata(hObject,handles);

% shift focus
figure(acq_gui)


power_curve = '200';
power_curve_num = strread(power_curve);

% run power curve in cell-attached
% set sequence params
set(acq_gui_data.Cell1_type_popup,'Value',1)
set(handles.rand_order,'Value',1);
set(handles.num_repeats,'String',num2str(5));
set(handles.num_stim,'String',num2str(289));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.075));
set(handles.target_intensity,'String',power_curve)
num_map_locations = size(obj_positions,1);
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))

for i = 1:num_map_locations
    

    % move obj
    set(handles.thenewx,'String',num2str(obj_positions(i,1)))
    set(handles.thenewy,'String',num2str(obj_positions(i,2)))
    set(handles.thenewz,'String',num2str(obj_positions(i,3)))
    obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

    handles = guidata(hObject);
    
    build_seq_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    
    acq_gui_data = get_acq_gui_data();
    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    guidata(acq_gui,acq_gui_data)

    set(acq_gui_data.run,'String','Prepping...')
    pause(20.0)
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
    
    % SHOW THE MAP
    cur_trial = acq_gui_data.data.sweep_counter;
    this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
    this_stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
%     [traces_ch1,traces_ch2] = ...
%         get_stim_stack(acq_gui_data.data,cur_trial,...
%         length(this_seq));
%     for j = 1:length(power_curve_num)
%         this_pow_trials = [this_seq.target_power] == power_curve_num(j);
%         traces_pow{1} = traces_ch1(this_pow_trials,:);
%         traces_pow{2} = traces_ch2(this_pow_trials,:);
%         this_seq_power = this_seq(this_pow_trials);
% %         this_stim_key_pow = this_stim_key(this_pow_trials,:,:);
%         see_grid_multi(traces_pow,this_seq_power,this_stim_key,10,1);
%         title(['Power = ' num2str(power_curve_num(i)) ' mW'])
%     end
%     
    [traces_ch1,traces_ch2] = ...
        get_stim_stack(acq_gui_data.data,cur_trial,...
        length(this_seq));
    for j = 1:length(power_curve_num)
        this_pow_trials = [this_seq.target_power] == power_curve_num(j);
        traces_pow{1} = traces_ch1(this_pow_trials,:);
        traces_pow{2} = traces_ch2(this_pow_trials,:);
        this_seq_power = this_seq(this_pow_trials);
    %         this_stim_key_pow = this_stim_key(this_pow_trials,:,:);
        see_grid_multi(traces_pow,this_seq_power,this_stim_key,20,1);
        title(['Power = ' num2str(power_curve_num(j)) ' mW'])
    end
    

end

guidata(hObject,handles);
set(acq_gui_data.trigger_seq,'Value',0)

% move obj
set(handles.close_socket_check,'Value',1)
set(handles.thenewx,'String',num2str(start_position(1)))
set(handles.thenewy,'String',num2str(start_position(2)))
set(handles.thenewz,'String',num2str(start_position(3)))
obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
pause(.1)

% get_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);



% --- Executes on button press in nuclear_detect_map.
function nuclear_detect_map_Callback(hObject, eventdata, handles)
% hObject    handle to nuclear_detect_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('take stack...')

set(handles.close_socket_check,'Value',0);
clock_array = clock;
stackname = [num2str(clock_array(2)) '_' num2str(clock_array(3)) ...
    '_' num2str(clock_array(4)) ...
    '_' num2str(clock_array(5))];

instruction.type = 00;
instruction.string = stackname;
disp('sending instruction...')
[return_info,success,handles] = do_instruction(instruction,handles);

user_confirm = msgbox(sprintf('Stack Taken with 2um spacing?\nUse name: %s',...
    stackname));
waitfor(user_confirm)

acq_gui = findobj('Tag','acq_gui');
acq_gui_data = get_acq_gui_data();
acq_gui_data.data.stackname = stackname;
guidata(acq_gui,acq_gui_data)

disp('detecting nuclei...')
instruction.type = 72;
instruction.stackname = stackname;
[return_info,success,handles] = do_instruction(instruction,handles);
acq_gui_data.data.nuclear_locs = return_info.nuclear_locs;
guidata(acq_gui,acq_gui_data)

instruction.type = 81;
instruction.nuclear_locs = acq_gui_data.data.nuclear_locs;
instruction.do_target = 1;
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)

set(handles.rand_order,'Value',1);
set(handles.num_repeats,'String',num2str(15));
set(handles.num_stim,'String',num2str(size(acq_gui_data.data.nuclear_locs,1)));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.075));
% set(handles.target_intensity,'String','150 200 250')

set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))

% user_confirm = msgbox('Targets loaded?');
% waitfor(user_confirm)

build_seq_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
acq_gui_data = get_acq_gui_data();
set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
%     acq_gui = findobj('Tag','acq_gui');


% whole cell or cell-attached?
% Construct a questdlg with three options
choice = questdlg('Patch Type?', ...
	'Patch type?', ...
	'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
% Handle response
switch choice
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
        set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
        set(acq_gui_data.Cell2_type_popup,'Value',2)
        whole_cell = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
        set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell = 0;
end

if whole_cell
    user_confirm = msgbox('Break in! Rs okay? Test pulse off?');
    waitfor(user_confirm)
end


guidata(acq_gui,acq_gui_data)

%     set(acq_gui_data.loop_count,'String',num2str(1))
% set(acq_gui_data.run,'String','Prepping...')
%     waitfig = warndlg('Is SlideBook Ready?');
%     waitfor(waitfig)
%     pause(3.0)
% pause(10.0)
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)

% plot map
cur_trial = acq_gui_data.data.sweep_counter;
this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
this_stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
power_curve_num = unique([this_seq.target_power]);

for i = 1:length(power_curve_num)
    [traces_ch1,traces_ch2] = ...
    get_stim_stack(acq_gui_data.data,cur_trial,...
        length(this_seq),[this_seq.start]);
    
    traces_pow{1} = traces_ch1([this_seq.target_power] == power_curve_num(i),:);
    traces_pow{2} = traces_ch2([this_seq.target_power] == power_curve_num(i),:);
    this_seq_power = this_seq([this_seq.target_power] == power_curve_num(i));
    see_grid_multi(traces_pow,this_seq_power,this_stim_key,5,1);
    title(['Power = ' num2str(power_curve_num(i)) ' mW'])
end

set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)


    
    

    



% --- Executes on button press in detect_map_3D.
function detect_map_3D_Callback(hObject, eventdata, handles)
% hObject    handle to detect_map_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.close_socket_check,'Value',0)
guidata(hObject,handles);

user_confirm = msgbox('SET REF POS: SLM Zero-order over desired mapping start location at top of slice?');
waitfor(user_confirm)
handles = update_obj_pos_Callback(hObject, eventdata, handles);
[acq_gui, acq_gui_data] = get_acq_gui_data;
acq_gui_data.data.ref_obj_position = handles.data.obj_position;
handles.data.ref_obj_position = handles.data.obj_position;
guidata(acq_gui, acq_gui_data);
guidata(hObject,handles)

set_cell_pos = 0;
choice = questdlg('Set Patched Cell 1 Pos?', ...
	'Set Cell Pos?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        set_cell_pos = 1;
    case 'No'
        set_cell_pos = 0;
end

if set_cell_pos
    % confirm everything ready
    user_confirm = msgbox('Z-plane aligned with patched cell 1?');
    waitfor(user_confirm)
% 
%     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    disp('click targets...')
    instruction.type = 73;
    instruction.num_targs = 1;
    [return_info,success,handles] = do_instruction(instruction,handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    handles.data.click_targ = return_info.nuclear_locs(1:2);
    acq_gui_data.data.snap_image = return_info.snap_image;
    guidata(acq_gui,acq_gui_data)
    
    handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    
    handles.data.cell1_pos = [handles.data.click_targ handles.data.obj_position(3)] - ...
        [0 0 handles.data.ref_obj_position(3)];
    acq_gui_data.data.cell_pos = handles.data.obj_position + [handles.data.click_targ 0];
    acq_gui_data.data.ref_obj_pos = handles.data.ref_obj_position;
    
    set(acq_gui_data.cell_x,'String',num2str(acq_gui_data.data.cell_pos(1)));
    set(acq_gui_data.cell_y,'String',num2str(acq_gui_data.data.cell_pos(2)));
    set(acq_gui_data.cell_z,'String',num2str(acq_gui_data.data.cell_pos(3)));
    
    guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)

end

set_cell2_pos = 0;
% choice = questdlg('Set Patched Cell 2 Pos?', ...
% 	'Set Cell Pos?', ...
% 	'Yes','No','Yes');
% % Handle response
% switch choice
%     case 'Yes'
%         set_cell2_pos = 1;
%     case 'No'
%         set_cell2_pos = 0;
% end

if set_cell2_pos
    % confirm everything ready
    user_confirm = msgbox('Z-plane aligned with patched cell 2?');
    waitfor(user_confirm)
% 
%     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    disp('click targets...')
    instruction.type = 73;
    instruction.num_targs = 1;
    [return_info,success,handles] = do_instruction(instruction,handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    handles.data.click_targ = return_info.nuclear_locs(1:2);
    acq_gui_data.data.snap_image2 = return_info.snap_image;
    guidata(acq_gui,acq_gui_data)
    
    handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);
    
    handles.data.cell2_pos = [handles.data.click_targ handles.data.obj_position(3)] - ...
        [0 0 handles.data.ref_obj_position(3)];
    
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    acq_gui_data.data.cell2_pos = handles.data.obj_position + [handles.data.click_targ 0];
    set(acq_gui_data.cell2_x,'String',num2str(acq_gui_data.data.cell2_pos(1)));
    set(acq_gui_data.cell2_y,'String',num2str(acq_gui_data.data.cell2_pos(2)));
    set(acq_gui_data.cell2_z,'String',num2str(acq_gui_data.data.cell2_pos(3)));
    
    guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)
    
    set(acq_gui_data.record_cell2_check,'Value',1);

end



% move obj to ref position (top of slice, centered on map fov)
set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
set(handles.thenewz,'String',num2str(handles.data.ref_obj_position(3)))

[handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

% make obj locations
% z_offsets = [30]';
% z_offsets = handles.data.cell2_pos(3) handles.data.cell1_pos(3)];\
if ~set_cell2_pos
    z_offsets = inputdlg('Z Locations?',...
             'Z Locations?',1,{[num2str(handles.data.cell1_pos(3))]});
else
    z_offsets = inputdlg('Z Locations?',...
                 'Z Locations?',1,{[num2str(handles.data.cell1_pos(3)) ' ' num2str(handles.data.cell2_pos(3))]});
end
z_offsets = strread(z_offsets{1})';
obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);

guidata(hObject,handles);

disp('take stack...')

set(handles.close_socket_check,'Value',0);
clock_array = clock;
stackname = [num2str(clock_array(2)) '_' num2str(clock_array(3)) ...
    '_' num2str(clock_array(4)) ...
    '_' num2str(clock_array(5))];

instruction.type = 00;
instruction.string = stackname;
disp('sending instruction...')
[return_info,success,handles] = do_instruction(instruction,handles);

user_confirm = msgbox(sprintf('Stack Taken with 2um spacing?\nUse name: %s',...
    stackname));
waitfor(user_confirm)

% acq_gui = findobj('Tag','acq_gui');
% acq_gui_data = get_acq_gui_data();
acq_gui_data.data.stackname = stackname;
guidata(acq_gui,acq_gui_data)


disp('detecting nuclei...')
instruction.type = 72;
instruction.stackname = stackname;
[return_info,success,handles] = do_instruction(instruction,handles);
acq_gui_data.data.nuclear_locs = return_info.nuclear_locs(:,1:3);
handles.data.nuclear_locs = return_info.nuclear_locs(:,1:3);

% handles.data.nuclear_locs = evalin('base','data.trial_metadata(end).nuclear_locs');
% acq_gui_data.data.nuclear_locs = handles.data.nuclear_locs;


if set_cell_pos
    handles.data.nuclear_locs = [handles.data.nuclear_locs; ...
                                 handles.data.cell1_pos];
end
if set_cell2_pos
    handles.data.nuclear_locs = [handles.data.nuclear_locs; ...
                                 handles.data.cell2_pos];
end
acq_gui_data.data.nuclear_locs = handles.data.nuclear_locs;
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)
assignin('base','nuclear_locs_w_cells',handles.data.nuclear_locs)

%expand stim set
nearby_locations = [];%return_info.nuclear_locs;
% nearby_targets = 2;
offsets = [-5 5];
% for i = 1:nearby_targets
nearby_stim = handles.data.nuclear_locs + ...
    [randsample(offsets,size(handles.data.nuclear_locs,1),1)' ...
     randsample(offsets,size(handles.data.nuclear_locs,1),1)' ...
     zeros(size(handles.data.nuclear_locs,1),1)];
nearby_locations = [nearby_locations; nearby_stim];
% nearby_stim = return_info.nuclear_locs + ...
%     [randsample(offsets,size(return_info.nuclear_locs,1),1)' ...
%      zeros(size(return_info.nuclear_locs,1),1) ...
%      zeros(size(return_info.nuclear_locs,1),1)];
% nearby_locations = [nearby_locations; nearby_stim];
% end
nearby_locations(nearby_locations(:,1) < - 150 | nearby_locations(:,1) > 150,:) = [];
nearby_locations(nearby_locations(:,2) < - 150 | nearby_locations(:,2) > 150,:) = [];
num_nuc = size(handles.data.nuclear_locs,1);
additional_locs = ceil(.25*num_nuc);
xmax = round(max(handles.data.nuclear_locs(:,1)) - min(handles.data.nuclear_locs(:,1)));
ymax = round(max(handles.data.nuclear_locs(:,2)) - min(handles.data.nuclear_locs(:,2)));
zmax = round(max(handles.data.nuclear_locs(:,3)) - min(handles.data.nuclear_locs(:,3)));
rand_locs(additional_locs,:) = [0 0 0];
for i = 1:additional_locs
    rand_locs(i,:) = [randi(xmax) randi(ymax) randi(zmax)] +...
                                    round([min(handles.data.nuclear_locs(:,1)) min(handles.data.nuclear_locs(:,2)) min(handles.data.nuclear_locs(:,3))]);
end
handles.data.nearby_locations = nearby_locations;
handles.data.rand_locs = rand_locs;
% acq_gui = findobj('Tag','acq_gui');
% acq_gui_data = get_acq_gui_data();
acq_gui_data.data.nearby_locations = nearby_locations;
acq_gui_data.data.rand_locs = rand_locs;
guidata(acq_gui,acq_gui_data);


% whole cell or cell-attached?
% Construct a questdlg with three options
clamp_choice1 = questdlg('Cell 1 Patch Type?', ...
	'Patch type?', ...
	'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
% Handle response
switch clamp_choice1
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell1 = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
        whole_cell1 = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell1 = 0;
end

if set_cell2_pos
    clamp_choice2 = questdlg('Cell 2 Patch Type?', ...
        'Patch type?', ...
        'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
    % Handle response
    switch clamp_choice2
        case 'Voltage Clamp'
            set(acq_gui_data.Cell2_type_popup,'Value',1)
            set(acq_gui_data.test_pulse,'Value',1)
            whole_cell2 = 1;
        case 'Current Clamp'
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            whole_cell2 = 1;
        case 'Cell Attached'
            set(acq_gui_data.Cell2_type_popup,'Value',3)
            set(acq_gui_data.test_pulse,'Value',1)
            whole_cell2 = 0;
    end
else
    clamp_choice2 = 'Cell Attached';
    set(acq_gui_data.Cell2_type_popup,'Value',3)
    set(acq_gui_data.test_pulse,'Value',0)
    whole_cell2 = 0;
end

if whole_cell1 || whole_cell2
    
    user_confirm = msgbox('Break in! Rs okay? Test pulse off? In v-clamp?');
    waitfor(user_confirm)


%     acq_gui = findobj('Tag','acq_gui');
%     acq_gui_data = guidata(acq_gui);


    % do single testpulse trial to get Rs
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    set(acq_gui_data.Cell2_type_popup,'Value',1)
    
    set(acq_gui_data.trial_length,'String',5.0)
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)


    do_intrinsics = 0;
    choice = questdlg('Do intrinsics?', ...
        'Do intrinsics?', ...
        'Cell 1','None','Cell 1 & 2','None');
    % Handle response
    switch choice
        case 'Cell 1'
            do_intrinsics = 1;
            set(acq_gui_data.Cell1_type_popup,'Value',2)
            acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
        case 'Cell 2'
            do_intrinsics = 1;
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        case 'Cell 1 & 2'
            do_intrinsics = 1;
            set(acq_gui_data.Cell1_type_popup,'Value',2)
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
            acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        case 'None'
            do_intrinsics = 0;
    end

    if do_intrinsics
        % tell user to switch to I=0
        user_confirm = msgbox('Please switch Multiclamp to CC with I = 0 for intrinsics cells');
        waitfor(user_confirm)

        % run intrinsic ephys
        % set acq params
        set(acq_gui_data.run,'String','Prepping...')
        
%         guidata(acq_gui,acq_gui_data);
        set(acq_gui_data.test_pulse,'Value',0)
        set(acq_gui_data.trigger_seq,'Value',0)
        % run trial

        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)
        
         switch choice
            case 'Cell 1'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell1_type_popup,'Value',2)
%                 acq_gui_data.data.ch1.pulseamp = 0;
                set(acq_gui_data.ccpulseamp1,'String','0');
                acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
            case 'Cell 2'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell2_type_popup,'Value',2)
%                 acq_gui_data.data.ch2.pulseamp = 0;
                set(acq_gui_data.ccpulseamp2,'String','0');
                acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
            case 'Cell 1 & 2'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell1_type_popup,'Value',2)
%                 set(acq_gui_data.Cell2_type_popup,'Value',2)
                set(acq_gui_data.ccpulseamp1,'String','0');
                acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                set(acq_gui_data.ccpulseamp2,'String','0');
                acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        end
    end


    user_confirm = msgbox('Please switch Multiclamp to VC with desired holding current. Rs is good?');
    waitfor(user_confirm)
end

% Handle response
switch clamp_choice1
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end

switch clamp_choice2
    case 'Voltage Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',1)
        set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;
    case 'Current Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',2)
        set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
%         set(acq_gui_data.Cell1_type_popup,'Value',3)
        set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end

guidata(hObject,handles);
guidata(acq_gui,acq_gui_data)

% shift focus
figure(acq_gui)

set(handles.rand_order,'Value',1);
set(handles.num_repeats,'String',num2str(10));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.075));
% POWERS HERE*****************************
user_input_powers = inputdlg('Enter desired powers (space-delimited):',...
             'Powers to run?',1,{'50 75 100'});
user_input_powers = user_input_powers{1};
initial_search_power = inputdlg('Enter initial search power (space-delimited):',...
             'Initial Search Power?',1,{'100'});
initial_search_power = initial_search_power{1};

set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
num_map_locations = size(obj_positions,1);
num_design_iters = 1;
design_iter_std_thresh = [0 .75];%percentile cutoff

i = 0;
for ii = 1:num_map_locations*num_design_iters
    ii
    new_i = ceil(ii/num_design_iters)
    rep_ind = mod(ii-1,num_design_iters)+1
    if num_design_iters > 1 && new_i == i
        reduce_map_by_std = 1;
    else
        i = new_i
        % move obj
        set(handles.thenewx,'String',num2str(obj_positions(i,1)))
        set(handles.thenewy,'String',num2str(obj_positions(i,2)))
        set(handles.thenewz,'String',num2str(obj_positions(i,3)))
        [handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
        reduce_map_by_std = 0;
    end
%     handles = guidata(hObject);
    
    % get this z-depth spots
    
    thresh_dist = 15;
    nuclear_locs = handles.data.nuclear_locs;
    % cut by z
    nuclear_locs = ...
        nuclear_locs(nuclear_locs(:,3) > (z_offsets(i) - thresh_dist) & ...
                       nuclear_locs(:,3) < (z_offsets(i) + thresh_dist),:);
    % cut by std dev  
    if reduce_map_by_std
        disp('DOING ONLINE DESIGN')      
        this_std_map = stddev_maps{i}{end}{1}; % this map location, highest pow, ch 1
        [sorted_stds,sort_order] = sort(this_std_map(:),1,'descend');
        sort_order = sort_order(~isnan(sorted_stds));
        [x_inds, y_inds] = ind2sub(size(this_std_map),sort_order);
        num_spots = ceil(length(sort_order)*(1 - design_iter_std_thresh(rep_ind)));
        good_locations = [x_inds(1:num_spots) y_inds(1:num_spots)]*1 - 151;
        dist_mat = squareform(pdist([nuclear_locs(:,[1 2]); good_locations]));
        dist_mat = dist_mat(1:size(nuclear_locs,1),size(nuclear_locs,1)+1:end);
        response_locs = any(dist_mat < 5*sqrt(2),2);
        nuclear_locs = nuclear_locs(response_locs,:);
        assignin('base','nuclear_locs',nuclear_locs)
        assignin('base','response_locs',response_locs)
        assignin('base','this_std_map',this_std_map)
    end
    nearby_locs = [handles.data.nearby_locations];
    nearby_locs = ...
        nearby_locs(nearby_locs(:,3) > (z_offsets(i) - thresh_dist) & ...
                       nearby_locs(:,3) < (z_offsets(i) + thresh_dist),:);
% 	nearby_trunc = ceil(size(nearby_locs,1)/2);
%     nearby_choice = randsample(size(nearby_locs,1),nearby_trunc);
%     nearby_locs = nearby_locs(nearby_choice,:);
%     rand_locs = handles.data.rand_locs;
%     rand_locs = ...
%         rand_locs(rand_locs(:,3) > (z_offsets(i) - 21) & ...
%                        rand_locs(:,3) < (z_offsets(i) + 21),:);               
    assignin('base','nuclear_locs_for_stim',nuclear_locs)
    instruction.type = 82;
    if num_design_iters == 1 || reduce_map_by_std
        instruction.multitarg_locs = [];
        instruction.single_spot_locs = [nuclear_locs];
        set(handles.target_intensity,'String',user_input_powers)
        set(handles.num_repeats,'String',num2str(20));
    else
        instruction.multitarg_locs = [nuclear_locs];
        instruction.single_spot_locs = [];
        set(handles.target_intensity,'String',initial_search_power)
        set(handles.num_repeats,'String',num2str(1));
    end
    %nuclear_locs];
%     instruction.nearby_locs = nearby_locs;
    instruction.targs_per_stim = 3;
    instruction.repeat_target = 10;
%     if ~isempty(instruction.multitarg_locs)
        instruction.num_stim = ...
            size(instruction.multitarg_locs,1)*ceil(instruction.repeat_target/instruction.targs_per_stim);
%     else
%         instruction.num_stim = 0;
%     end
    instruction.do_target = 1;
    assignin('base','instruction',instruction)
    [return_info,success,handles] = do_instruction(instruction,handles);
    guidata(hObject,handles)
    
    set(handles.num_stim,'String',num2str(return_info.num_stim));
    set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
    set(handles.tf_flag,'Value',1)
    set(handles.set_seq_trigger,'Value',0)
    
    [handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles);
%     handles = guidata(hObject);
%     acq_gui_data = get_acq_gui_data();
    max_seq_length = str2double(get(handles.max_seq_length,'String'));
    this_seq = acq_gui_data.data.sequence;
    num_runs = ceil(length(this_seq)/max_seq_length);
    start_trial = acq_gui_data.data.sweep_counter + 1;
    for run_i = 1:num_runs
        this_subseq = this_seq((run_i-1)*max_seq_length+1:min(run_i*max_seq_length,length(this_seq)));
        time_offset = this_subseq(1).start - 1000;
        for k = 1:length(this_subseq)
            this_subseq(k).start = this_subseq(k).start - time_offset;
        end
        total_duration = (this_subseq(end).start)/1000 + 5;
        
        set(acq_gui_data.trial_length,'String',num2str(total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        instruction.type = 32; %SEND SEQ
        handles.sequence = this_subseq;
        instruction.sequence = this_subseq;
        handles.total_duration = total_duration;
        instruction.waittime = total_duration + 120;
        disp('sending instruction...')
        [return_info,success,handles] = do_instruction(instruction,handles);
%         acq_gui_data = get_acq_gui_data();
%         acq_gui_data.data.stim_key =  return_info.stim_key;
        acq_gui_data.data.sequence =  this_subseq;
%         acq_gui = findobj('Tag','acq_gui');
        guidata(acq_gui,acq_gui_data)

        set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

        guidata(hObject,handles)
%         guidata(acq_gui,acq_gui_data)

        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)

        
    end
    
    % plot map
    try
        trials = start_trial:acq_gui_data.data.sweep_counter;
        show_raw_data = 1; do_stdmap = 1; do_corrmap = 1;
        [maps,~,~,~,stddev_maps{i}] = ...
            summarize_map(acq_gui_data.data,trials,show_raw_data,do_stdmap,do_corrmap);
    
%         this_std_map = stddev_maps{i}{end}{1}; % this map location, highest pow, ch 1
%         [sorted_stds,sort_order] = sort(this_std_map(:),1,'descend');
%         sort_order = sort_order(~isnan(sorted_stds));
%         [x_inds, y_inds] = ind2sub(size(this_std_map),sort_order);
%         figure
%         subplot(131)
%         plot_trace_stack(maps{i}{end}{1}{x_inds(1),y_inds(1)},30,'-')
%         title(['Horiz: ' num2str(y_inds(1)/1.82 - 129)  ', Vert: ' num2str(x_inds(1)/1.82 - 131)])
%         subplot(132)
%         plot_trace_stack(maps{i}{end}{1}{x_inds(2),y_inds(2)},30,'-')
%         title(['Horiz: ' num2str(y_inds(2)/1.82 - 129)  ', Vert: ' num2str(x_inds(2)/1.82 - 131)])
%         subplot(133)
%         plot_trace_stack(maps{i}{end}{1}{x_inds(3),y_inds(3)},30,'-')
%         title(['Horiz: ' num2str(y_inds(3)/1.82 - 129)  ', Vert: ' num2str(x_inds(3)/1.82 - 131)])
    catch e
        disp('Could not plot')
    end
%     this_seq_plot = acq_gui_data.data.trial_metadata(cur_trial).sequence;
%     this_stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
%     power_curve_num = unique([this_seq_plot.target_power]);
%     show_raw_data = 0;
%     for j = 1:length(power_curve_num)
%         [traces_ch1,traces_ch2] = ...
%         get_stim_stack(acq_gui_data.data,cur_trial,...
%             length(this_seq_plot),[this_seq_plot.start]);
% 
%         traces_pow{1} = traces_ch1([this_seq_plot.target_power] == power_curve_num(j),:);
%         traces_pow{2} = traces_ch2([this_seq_plot.target_power] == power_curve_num(j),:);
%         this_seq_power = this_seq_plot([this_seq_plot.target_power] == power_curve_num(j));
%         [~,~,~,stddev_maps] = ...
%             see_grid_multi(traces_pow,this_seq_power,this_stim_key,5,show_raw_data);
%         if show_raw_data
%             title(['Power = ' num2str(power_curve_num(j)) ' mW'])
%         end
%     end

end

set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)



function repeat_start_ind_Callback(hObject, eventdata, handles)
% hObject    handle to repeat_start_ind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repeat_start_ind as text
%        str2double(get(hObject,'String')) returns contents of repeat_start_ind as a double


% --- Executes during object creation, after setting all properties.
function repeat_start_ind_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repeat_start_ind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in test_temp.
function test_temp_Callback(hObject, eventdata, handles)
% hObject    handle to test_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% fields_to_get = {'z_start','z_stop','z_spacing'};
set(handles.close_socket_check,'Value',0)
set(handles.rand_order,'Value',1)
guidata(hObject,handles);
% z_start = str2double(get(handles.z_start,'String'));
% z_stop = str2double(get(handles.z_stop,'String'));
% z_spacing = str2double(get(handles.z_spacing,'String'));
% z_offsets = z_start:z_spacing:z_stop;
% z_offsets = [-70 -50 -30 -20 -10 0 10 20 30 50 70]';
% z_offsets = [-50 -10 0 10 50]';

set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
handles = guidata(hObject);

% pause(.1)
% get_obj_pos_Callback(hObject, eventdata, handles)
% handles = guidata(hObject);
% handles.data.obj_pos
num_repeats = 5;
set(handles.num_repeats,'String',num2str(5));
start_position = handles.data.obj_position;
% build obj_positions


guidata(hObject,handles);
% pause(.1)


% get Acq handles
acq_gui = findobj('Tag','acq_gui');
acq_gui_data = get_acq_gui_data();
% shift focus
figure(acq_gui)

% confirm everything ready
user_confirm = msgbox('Cell-attached? Test pulse off? V_m set to 0? I_h set to 0?');
waitfor(user_confirm)


power_curve = '100 150 200 250';

power_curve_num = strread(power_curve);
% set(acq_gui.use_lut,'Value',1);
% set(acq_gui.use_LED,'Value',0);
% set(acq_gui.use_2P,'Value',1);

% run power curve in cell-attached
% set sequence paraqms
set(handles.num_stim,'String',num2str(1));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.5));
set(handles.num_repeats,'String',num2str(5));
set(handles.target_intensity,'String',power_curve)

set(handles.ind_mult,'String',num2str(1))



% run on cell power curve cell-attached

% build sequence
build_seq_Callback(hObject, eventdata, handles)
pause(2.0)
handles = guidata(hObject);
acq_gui_data = guidata(acq_gui);
% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.Cell1_type_popup,'Value',3)
set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
guidata(acq_gui,acq_gui_data)
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
set(acq_gui_data.Highpass_cell1_check, 'Value',0)
% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
guidata(acq_gui,acq_gui_data)
% cleanup

% show data
try
    cur_trial = acq_gui_data.data.sweep_counter;
    this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
    [trace_stack] = ...
        get_stim_stack(acq_gui_data.data,cur_trial,...
        length(this_seq),[this_seq.start]);

    trace_grid = cell(length(power_curve_num),1);
    for i = 1:length(power_curve_num)
        trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
    end
    cell_attached_spikes_fig = figure;
    plot_trace_stack_grid(trace_grid,Inf,1,0);
catch e
    disp('failed to plot data')
end


% get_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);

do_whole_cell = 0;
choice = questdlg('Go Whole Cell?', ...
	'Go Whole Cell?', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        do_whole_cell = 1;
    case 'No'
        do_whole_cell = 0;
end

if do_whole_cell
    % tell user to break in and be in VC
    user_confirm = msgbox('Break in! Test pulse off?');
    waitfor(user_confirm)


    % do single testpulse trial to get Rs
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    set(acq_gui_data.trial_length,'String',1.0)
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)

    % tell user to switch to I=0
    user_confirm = msgbox('Please switch Multiclamp to CC with I = 0');
    waitfor(user_confirm)

    % run intrinsic ephys
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',2)
    acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
    guidata(acq_gui,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',0)
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)

    run_cc = 1;
    
%     messages = {'At body temp?','At room temp?'};
    if run_cc
        run_again = 1;
        while run_again
        

            % run power curve on cell in CC
            % set sequence paraqms
            set(handles.num_stim,'String',num2str(1));
            set(handles.duration,'String',num2str(.003));
            set(handles.iti,'String',num2str(0.5));
            set(handles.num_repeats,'String',num2str(5));
            set(handles.target_intensity,'String',power_curve)
            % build seq
            build_seq_Callback(hObject, eventdata, handles)
            pause(2.0)
            handles = guidata(hObject);
            acq_gui_data = guidata(acq_gui);
            % set acq params
            set(acq_gui_data.run,'String','Prepping...')
            % set(acq_gui_data.Cell1_type_popup,'Value',2)
            set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
            acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
            guidata(acq_gui,acq_gui_data)
            set(acq_gui_data.test_pulse,'Value',0)
            set(acq_gui_data.loop,'Value',1)
            set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
            set(acq_gui_data.trigger_seq,'Value',1)
            set(acq_gui_data.loop_count,'String',num2str(1))
            % run trial
            acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
            waitfor(acq_gui_data.run,'String','Start')
            guidata(acq_gui,acq_gui_data)

            % show data
            try
                cur_trial = acq_gui_data.data.sweep_counter;
                this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
                [trace_stack] = ...
                    get_stim_stack(acq_gui_data.data,cur_trial,...
                    length(this_seq),[this_seq.start]);
                trace_grid = cell(length(power_curve_num),1);
                for i = 1:length(power_curve_num)
                    trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
                end
                cc_power_curve_fig = figure;
                plot_trace_stack_grid(trace_grid,Inf,1,0);
            catch e
                disp('failed to plot data')
            end


            guidata(hObject,handles);
            set(acq_gui_data.trigger_seq,'Value',0)
            guidata(acq_gui,acq_gui_data)
            choice = questdlg('Run power curve again?', ...
                'Run power curve?', ...
                'Yes','No','No');
            % Handle response
            switch choice
                case 'Yes'
                    run_again = 1;
                case 'No'
                    run_again = 0;
            end
        end
    end


     % run intrinsic ephys
    % set acq params
%     set(acq_gui_data.run,'String','Prepping...')
%     set(acq_gui_data.Cell1_type_popup,'Value',2)
%     acq_gui_data = Acq('cell1_chrome_input_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
%     guidata(acq_gui,acq_gui_data);
%     set(acq_gui_data.test_pulse,'Value',0)
%     set(acq_gui_data.trigger_seq,'Value',0)
%     % run trial
%     acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
%     waitfor(acq_gui_data.run,'String','Start')
%     guidata(acq_gui,acq_gui_data)

    % run power curve on cell in VC
    % tell user to switch to VC with Vm offset to ealier Vm
    user_confirm = msgbox(['In VC with Vm set to baseline?']);
    waitfor(user_confirm)
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    % vc on cell power curve
    % set sequence params
    set(handles.num_stim,'String',num2str(1));
    set(handles.duration,'String',num2str(.003));
    % set(handles.iti,'String',num2str(1.0));

    % build seq
    build_seq_Callback(hObject, eventdata, handles)
    pause(2.0)
    acq_gui_data = guidata(acq_gui);
    handles = guidata(hObject);
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.test_pulse,'Value',1)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
    
end
guidata(hObject,handles);
set(acq_gui_data.trigger_seq,'Value',0)
% move obj
set(handles.close_socket_check,'Value',1)
guidata(acq_gui,acq_gui_data)
% get_obj_pos_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);


% --- Executes on button press in map_clicks.
function map_clicks_Callback(hObject, eventdata, handles)
% hObject    handle to map_clicks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.close_socket_check,'Value',0)
guidata(hObject,handles);

set_cell_pos = 0;
choice = questdlg('Set Ref Pos?', ...
	'Set Ref Pos?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        set_cell_pos = 1;
    case 'No'
        set_cell_pos = 0;
end

if set_cell_pos
    % confirm everything ready
    user_confirm = msgbox('SLM Zero-order over ref point?');
    waitfor(user_confirm)

    set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    handles = guidata(hObject);
end

user_confirm = msgbox('SLM Zero-order over desired mapping location?');
waitfor(user_confirm)
handles = update_obj_pos_Callback(hObject, eventdata, handles);

% make obj locations
z_offsets = [0]';
% z_offsets = [20]';
obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];
start_position = handles.data.obj_position;
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);

guidata(hObject,handles);

disp('take image...')

% 
% instruction.type = 91;
% % instruction.string = stackname;
% disp('sending instruction...')
% [return_info,success,handles] = do_instruction(instruction,handles);

% user_confirm = msgbox(sprintf('Take snap',...
%     stackname));
% waitfor(user_confirm)

% acq_gui = findobj('Tag','acq_gui');
% acq_gui_data = get_acq_gui_data();
% acq_gui_data.data.stackname = stackname;
% guidata(acq_gui,acq_gui_data)

disp('click targets...')
instruction.type = 73;
instruction.num_targs = 0;
[return_info,success,handles] = do_instruction(instruction,handles);
acq_gui_data.data.nuclear_locs = return_info.nuclear_locs;
handles.data.nuclear_locs = return_info.nuclear_locs;
acq_gui_data.data.snap_image = return_info.snap_image;
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)
% 
% %expand stim set
% nearby_locations = [];%return_info.nuclear_locs;
% % nearby_targets = 2;
% offsets = [-10 10];
% % for i = 1:nearby_targets
% nearby_stim = return_info.nuclear_locs + ...
%     [randsample(offsets,size(return_info.nuclear_locs,1),1)' ...
%      randsample(offsets,size(return_info.nuclear_locs,1),1)' ...
%      zeros(size(return_info.nuclear_locs,1),1)];
% nearby_locations = [nearby_locations; nearby_stim];
% % nearby_stim = return_info.nuclear_locs + ...
% %     [randsample(offsets,size(return_info.nuclear_locs,1),1)' ...
% %      zeros(size(return_info.nuclear_locs,1),1) ...
% %      zeros(size(return_info.nuclear_locs,1),1)];
% % nearby_locations = [nearby_locations; nearby_stim];
% % end
% nearby_locations(nearby_locations(:,1) < - 150 | nearby_locations(:,1) > 150,:) = [];
% nearby_locations(nearby_locations(:,2) < - 150 | nearby_locations(:,2) > 150,:) = [];
% num_nuc = size(handles.data.nuclear_locs,1);
% additional_locs = ceil(.25*num_nuc);
% xmax = round(max(handles.data.nuclear_locs(:,1)) - min(handles.data.nuclear_locs(:,1)));
% ymax = round(max(handles.data.nuclear_locs(:,2)) - min(handles.data.nuclear_locs(:,2)));
% zmax = round(max(handles.data.nuclear_locs(:,3)) - min(handles.data.nuclear_locs(:,3)));
% rand_locs(additional_locs,:) = [0 0 0];
% for i = 1:additional_locs
%     rand_locs(i,:) = [randi(xmax) randi(ymax) randi(zmax)] +...
%                                     round([min(handles.data.nuclear_locs(:,1)) min(handles.data.nuclear_locs(:,2)) min(handles.data.nuclear_locs(:,3))]);
% end
% handles.data.nearby_locations = nearby_locations;
% handles.data.rand_locs = rand_locs;
% acq_gui = findobj('Tag','acq_gui');
% acq_gui_data = get_acq_gui_data();
% acq_gui_data.data.nearby_locations = nearby_locations;
% acq_gui_data.data.rand_locs = rand_locs;
% guidata(acq_gui,acq_gui_data);


% whole cell or cell-attached?
% Construct a questdlg with three options
clamp_choice = questdlg('Patch Type?', ...
	'Patch type?', ...
	'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
% Handle response
switch clamp_choice
    case 'Voltage Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
%         set(acq_gui_data.test_pulse,'Value',1)
        whole_cell = 1;
    case 'Current Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
        whole_cell = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
        set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell = 0;
end

if whole_cell
    user_confirm = msgbox('Break in! Rs okay? Test pulse off? In v-clamp?');
    waitfor(user_confirm)



    guidata(acq_gui,acq_gui_data)


    acq_gui = findobj('Tag','acq_gui');
    acq_gui_data = guidata(acq_gui);


    % do single testpulse trial to get Rs
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    set(acq_gui_data.trial_length,'String',1.0)
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)


    do_intrinsics = 0;
    choice = questdlg('Do intrinsics?', ...
        'Do intrinsics?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            do_intrinsics = 1;
        case 'No'
            do_intrinsics = 0;
    end

    if do_intrinsics
        % tell user to switch to I=0
        user_confirm = msgbox('Please switch Multiclamp to CC with I = 0');
        waitfor(user_confirm)

        % run intrinsic ephys
        % set acq params
        set(acq_gui_data.run,'String','Prepping...')
        set(acq_gui_data.Cell1_type_popup,'Value',2)
        acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
        guidata(acq_gui,acq_gui_data);
        set(acq_gui_data.test_pulse,'Value',0)
        set(acq_gui_data.trigger_seq,'Value',0)
        % run trial

        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)
    end


    user_confirm = msgbox('Please switch Multiclamp to VC with desired holding current. Rs is good?');
    waitfor(user_confirm)
end

% Handle response
switch clamp_choice
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
        set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
        set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
        set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end

guidata(hObject,handles);

% shift focus
figure(acq_gui)

set(handles.rand_order,'Value',1);
set(handles.num_repeats,'String',num2str(5));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(5.0));
% POWERS HERE*****************************
set(handles.target_intensity,'String','50 150 250')


set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
num_map_locations = size(obj_positions,1);

for i = 1:num_map_locations
    

    % move obj
    set(handles.thenewx,'String',num2str(obj_positions(i,1)))
    set(handles.thenewy,'String',num2str(obj_positions(i,2)))
    set(handles.thenewz,'String',num2str(obj_positions(i,3)))
    obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

    handles = guidata(hObject);
    
    % get this z-depth spots
    
    nuclear_locs = handles.data.nuclear_locs;
%     nuclear_locs = ...
%         nuclear_locs(nuclear_locs(:,3) > (z_offsets(i) - 21) & ...
%                        nuclear_locs(:,3) < (z_offsets(i) + 21),:);
%     nearby_locs = [handles.data.nearby_locations];
%     nearby_locs = ...
%         nearby_locs(nearby_locs(:,3) > (z_offsets(i) - 21) & ...
%                        nearby_locs(:,3) < (z_offsets(i) + 21),:);
% 	nearby_trunc = ceil(size(nearby_locs,1)/2);
%     nearby_choice = randsample(size(nearby_locs,1),nearby_trunc);
%     nearby_locs = nearby_locs(nearby_choice,:);
%     rand_locs = handles.data.rand_locs;
%     rand_locs = ...
%         rand_locs(rand_locs(:,3) > (z_offsets(i) - 21) & ...
%                        rand_locs(:,3) < (z_offsets(i) + 21),:);               
    
%     instruction.type = 82;
%     instruction.multitarg_locs = [nuclear_locs];
%     instruction.single_spot_locs = [nuclear_locs];
% %     instruction.nearby_locs = nearby_locs;
%     instruction.targs_per_stim = 1;
%     instruction.repeat_target = 5;
%     instruction.num_stim = size(instruction.multitarg_locs,1)*(ceil(instruction.repeat_target/instruction.targs_per_stim));
%     instruction.do_target = 1;
%     [return_info,success,handles] = do_instruction(instruction,handles);
    instruction.type = 81;
    instruction.target_locs = nuclear_locs;
    instruction.do_target = 1;
    [return_info,success,handles] = do_instruction(instruction,handles);
    guidata(hObject,handles)
        set(handles.rand_order,'Value',1);
    set(handles.num_repeats,'String',num2str(10));
    set(handles.num_stim,'String',num2str(size(nuclear_locs,1)));
    set(handles.duration,'String',num2str(.003));
    set(handles.iti,'String',num2str(.500));
    set(handles.target_intensity,'String','75 150 250')

    guidata(hObject,handles)
%     set(handles.num_stim,'String',num2str(return_info.num_stim));
%     set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
    build_seq_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    acq_gui_data = get_acq_gui_data();
    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

    guidata(acq_gui,acq_gui_data)

    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)
    
    % plot map
    cur_trial = acq_gui_data.data.sweep_counter;
    this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
    this_stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
    power_curve_num = unique([this_seq.target_power]);

    for j = 1:length(power_curve_num)
        [traces_ch1,traces_ch2] = ...
        get_stim_stack(acq_gui_data.data,cur_trial,...
            length(this_seq),[this_seq.start]);

        traces_pow{1} = traces_ch1([this_seq.target_power] == power_curve_num(j),:);
        traces_pow{2} = traces_ch2([this_seq.target_power] == power_curve_num(j),:);
        this_seq_power = this_seq([this_seq.target_power] == power_curve_num(j));
        see_grid_multi(traces_pow,this_seq_power,this_stim_key,5,1);
        title(['Power = ' num2str(power_curve_num(j)) ' mW'])
    end
    

end

set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)


% --- Executes on button press in set_seq_trigger.
function set_seq_trigger_Callback(hObject, eventdata, handles)
% hObject    handle to set_seq_trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of set_seq_trigger



function max_seq_length_Callback(hObject, eventdata, handles)
% hObject    handle to max_seq_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_seq_length as text
%        str2double(get(hObject,'String')) returns contents of max_seq_length as a double


% --- Executes during object creation, after setting all properties.
function max_seq_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_seq_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in nrp_z_power.
function nrp_z_power_Callback(hObject, eventdata, handles)
% hObject    handle to nrp_z_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% fields_to_get = {'z_start','z_stop','z_spacing'};
set(handles.close_socket_check,'Value',0)
set(handles.rand_order,'Value',1)
guidata(hObject,handles);

% SET TO CLOSE SOCKET
% instruction.type = 00;
% instruction.
user_confirm = msgbox('Client socket off?');
waitfor(user_confirm)

user_confirm = msgbox('Take stack around patched cell(s)?');
waitfor(user_confirm)

user_confirm = msgbox('SLM Zero-order over desired mapping location?');
waitfor(user_confirm)
user_confirm = msgbox('Client socket waiting?');
waitfor(user_confirm)
handles = update_obj_pos_Callback(hObject, eventdata, handles);

z_offsets = [0]';
z_order = randperm(length(z_offsets));
obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];
start_position = handles.data.obj_position;
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);
obj_positions = obj_positions(z_order,:);


num_repeats = 5;
set(handles.num_repeats,'String',num2str(num_repeats));

disp('click targets...')
instruction.type = 73;
instruction.num_targs = 10;
[return_info,success,handles] = do_instruction(instruction,handles);
acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);
acq_gui_data.data.nuclear_locs = return_info.nuclear_locs;
handles.data.nuclear_locs = return_info.nuclear_locs;
acq_gui_data.data.snap_image = return_info.snap_image;
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)

% whole cell or cell-attached?
% Construct a questdlg with three options
clamp_choice = questdlg('Patch Type?', ...
	'Patch type?', ...
	'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
% Handle response
switch clamp_choice
    case 'Voltage Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
%         set(acq_gui_data.test_pulse,'Value',1)
        whole_cell = 1;
    case 'Current Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
        whole_cell = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
        set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell = 0;
end

if whole_cell
    user_confirm = msgbox('Break in! Rs okay? Test pulse off? In v-clamp?');
    waitfor(user_confirm)



    guidata(acq_gui,acq_gui_data)


    acq_gui = findobj('Tag','acq_gui');
    acq_gui_data = guidata(acq_gui);


    % do single testpulse trial to get Rs
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    set(acq_gui_data.trial_length,'String',1.0)
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)


    do_intrinsics = 0;
    choice = questdlg('Do intrinsics?', ...
        'Do intrinsics?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            do_intrinsics = 1;
        case 'No'
            do_intrinsics = 0;
    end

    if do_intrinsics
        % tell user to switch to I=0
        user_confirm = msgbox('Please switch Multiclamp to CC with I = 0');
        waitfor(user_confirm)

        % run intrinsic ephys
        % set acq params
        set(acq_gui_data.run,'String','Prepping...')
        set(acq_gui_data.Cell1_type_popup,'Value',2)
        acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
        guidata(acq_gui,acq_gui_data);
        set(acq_gui_data.test_pulse,'Value',0)
        set(acq_gui_data.trigger_seq,'Value',0)
        % run trial

        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)
    end


    user_confirm = msgbox('Please switch Multiclamp to VC with desired holding current. Rs is good?');
    waitfor(user_confirm)
end


% Handle response
switch clamp_choice
    case 'Voltage Clamp'
        user_confirm = msgbox('In VC? Rs good? Vm set to V_rest?');
        set(acq_gui_data.Cell1_type_popup,'Value',1)
        set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;
    case 'Current Clamp'
        user_confirm = msgbox('Rs good? In Current Clamp? I_h set to 0?');
        set(acq_gui_data.Cell1_type_popup,'Value',2)
        set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
        % confirm everything ready
        user_confirm = msgbox('Cell-attached? Test pulse off? I_h set to 0?');
        
        set(acq_gui_data.Cell1_type_popup,'Value',3)
        set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end
waitfor(user_confirm)
guidata(hObject,handles);


% shift focus
figure(acq_gui)

set(handles.rand_order,'Value',1);
set(handles.num_repeats,'String',num2str(10));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(.500));
% POWERS HERE*****************************
set(handles.target_intensity,'String','35 50 75')

set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
num_map_locations = size(obj_positions,1);
set(handles.set_seq_trigger,'Value',1)


for i = 1:num_map_locations
    

    % move obj
    set(handles.thenewx,'String',num2str(obj_positions(i,1)))
    set(handles.thenewy,'String',num2str(obj_positions(i,2)))
    set(handles.thenewz,'String',num2str(obj_positions(i,3)))
    obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

    handles = guidata(hObject);
    
    % get this z-depth spots
    
    nuclear_locs = handles.data.nuclear_locs;

    instruction.type = 81;
    instruction.target_locs = nuclear_locs;
    instruction.do_target = 1;
    [return_info,success,handles] = do_instruction(instruction,handles);
    guidata(hObject,handles)
        set(handles.rand_order,'Value',1);
    set(handles.num_stim,'String',num2str(size(nuclear_locs,1)));
    set(handles.repeat_start_ind,'String','1')
    guidata(hObject,handles)
%     set(handles.num_stim,'String',num2str(return_info.num_stim));
%     set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
    build_seq_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    [acq_gui,acq_gui_data] = get_acq_gui_data();
    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

    guidata(acq_gui,acq_gui_data)

    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
%     guidata(acq_gui,acq_gui_data)
    [acq_gui,acq_gui_data] = get_acq_gui_data();
    
    % plot map
    try
            cur_trial = acq_gui_data.data.sweep_counter;
            this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
            [trace_stack] = ...
                get_stim_stack(acq_gui_data.data,cur_trial,...
                length(this_seq),[this_seq.start]);
            trace_grid = cell(length(power_curve_num),1);
            for i = 1:length(power_curve_num)
                trace_grid{i} = trace_stack([this_seq.target_power] == power_curve_num(i),:);
            end
            figure
            plot_trace_stack_grid(trace_grid,Inf,1,0);
        catch e
            disp('failed to plot data')
    end
            
%     cur_trial = acq_gui_data.data.sweep_counter;
%     this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
%     this_stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
%     power_curve_num = unique([this_seq.target_power]);
% 
%     for j = 1:length(power_curve_num)
%         [traces_ch1,traces_ch2] = ...
%         get_stim_stack(acq_gui_data.data,cur_trial,...
%             length(this_seq),[this_seq.start]);
% 
%         traces_pow{1} = traces_ch1([this_seq.target_power] == power_curve_num(j),:);
%         traces_pow{2} = traces_ch2([this_seq.target_power] == power_curve_num(j),:);
%         this_seq_power = this_seq([this_seq.target_power] == power_curve_num(j));
%         see_grid_multi(traces_pow,this_seq_power,this_stim_key,5,0);
% %         title(['Power = ' num2str(power_curve_num(j)) ' mW, z = ' num2str(obj_positions(i,3))])
%     end
%     figure
%     plot_trace_stack_grid(traces_pow,Inf,1,0);
    

end

[acq_gui,acq_gui_data] = get_acq_gui_data();
acq_gui_data.data.obj_positions_ordered = obj_positions;
guidata(acq_gui,acq_gui_data)
set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)


% --- Executes on button press in target_connection_map.
function target_connection_map_Callback(hObject, eventdata, handles)
% hObject    handle to target_connection_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.close_socket_check,'Value',0)
guidata(hObject,handles);

user_confirm = msgbox('SET REF POS: SLM Zero-order over desired mapping start location at top of slice?');
waitfor(user_confirm)
handles = update_obj_pos_Callback(hObject, eventdata, handles);
[acq_gui, acq_gui_data] = get_acq_gui_data;
acq_gui_data.data.ref_obj_position = handles.data.obj_position;
handles.data.ref_obj_position = handles.data.obj_position;
guidata(acq_gui, acq_gui_data);
guidata(hObject,handles)

set_cell_pos = 0;
choice = questdlg('Set Patched Cell 1 Pos?', ...
	'Set Cell Pos?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        set_cell_pos = 1;
    case 'No'
        set_cell_pos = 0;
end

if set_cell_pos
    % confirm everything ready
    user_confirm = msgbox('Z-plane aligned with patched cell 1?');
    waitfor(user_confirm)
% 
%     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    disp('click targets...')
    instruction.type = 73;
    instruction.num_targs = 1;
    [return_info,success,handles] = do_instruction(instruction,handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    handles.data.click_targ = return_info.nuclear_locs(1:2);
    acq_gui_data.data.snap_image = return_info.snap_image;
    guidata(acq_gui,acq_gui_data)
    
    handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    
    handles.data.cell1_pos = [handles.data.click_targ handles.data.obj_position(3)] - ...
        [0 0 handles.data.ref_obj_position(3)];
    acq_gui_data.data.cell_pos = handles.data.obj_position + [handles.data.click_targ 0];
    
    set(acq_gui_data.cell_x,'String',num2str(acq_gui_data.data.cell_pos(1)));
    set(acq_gui_data.cell_y,'String',num2str(acq_gui_data.data.cell_pos(2)));
    set(acq_gui_data.cell_z,'String',num2str(acq_gui_data.data.cell_pos(3)));
    
    guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)

end

% move obj to ref position (top of slice, centered on map fov)
set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
set(handles.thenewz,'String',num2str(handles.data.ref_obj_position(3)))

[handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

% make obj locations
z_offsets = inputdlg('Z Locations?',...
             'Z Locations?',1,{num2str(handles.data.cell1_pos(3))});
z_offsets = strread(z_offsets{1})';
obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);

guidata(hObject,handles);

disp('take stack...')

set(handles.close_socket_check,'Value',0);
clock_array = clock;
stackname = [num2str(clock_array(2)) '_' num2str(clock_array(3)) ...
    '_' num2str(clock_array(4)) ...
    '_' num2str(clock_array(5))];

instruction.type = 00;
instruction.string = stackname;
disp('sending instruction...')
[return_info,success,handles] = do_instruction(instruction,handles);

user_confirm = msgbox(sprintf('120 um Stack Taken with 2um spacing?\nUse name: %s',...
    stackname));
waitfor(user_confirm)

% acq_gui = findobj('Tag','acq_gui');
% acq_gui_data = get_acq_gui_data();
acq_gui_data.data.stackname = stackname;
guidata(acq_gui,acq_gui_data)


disp('detecting nuclei...')
% instruction.type = 72;
% instruction.stackname = stackname;
% [return_info,success,handles] = do_instruction(instruction,handles);
% acq_gui_data.data.nuclear_locs = return_info.nuclear_locs;
% handles.data.detect_img = return_info.detect_img;
% acq_gui_data.data.detect_img = return_info.detect_img;
% figure;
% imagesc(return_info.detect_img)
% handles.data.nuclear_locs = return_info.nuclear_locs;
% dummy locs
handles.data.nuclear_locs = evalin('base','data.trial_metadata(end).nuclear_locs');
acq_gui_data.data.nuclear_locs = handles.data.nuclear_locs;

if set_cell_pos
    handles.data.nuclear_locs = [handles.data.nuclear_locs; ...
                                 handles.data.cell1_pos];
end

acq_gui_data.data.nuclear_locs = handles.data.nuclear_locs;

assignin('base','nuclear_locs_w_cells',handles.data.nuclear_locs)

%expand stim set
nearby_locations = [];%return_info.nuclear_locs;
% nearby_targets = 2;
offsets = [-5 5];
% for i = 1:nearby_targets
nearby_stim = handles.data.nuclear_locs + ...
    [randsample(offsets,size(handles.data.nuclear_locs,1),1)' ...
     randsample(offsets,size(handles.data.nuclear_locs,1),1)' ...
     zeros(size(handles.data.nuclear_locs,1),1)];
nearby_locations = [nearby_locations; nearby_stim];
% nearby_stim = return_info.nuclear_locs + ...
%     [randsample(offsets,size(return_info.nuclear_locs,1),1)' ...
%      zeros(size(return_info.nuclear_locs,1),1) ...
%      zeros(size(return_info.nuclear_locs,1),1)];
% nearby_locations = [nearby_locations; nearby_stim];
% end
nearby_locations(nearby_locations(:,1) < - 150 | nearby_locations(:,1) > 150,:) = [];
nearby_locations(nearby_locations(:,2) < - 150 | nearby_locations(:,2) > 150,:) = [];
num_nuc = size(handles.data.nuclear_locs,1);
additional_locs = ceil(.25*num_nuc);
xmax = round(max(handles.data.nuclear_locs(:,1)) - min(handles.data.nuclear_locs(:,1)));
ymax = round(max(handles.data.nuclear_locs(:,2)) - min(handles.data.nuclear_locs(:,2)));
zmax = round(max(handles.data.nuclear_locs(:,3)) - min(handles.data.nuclear_locs(:,3)));
rand_locs(additional_locs,:) = [0 0 0];
for i = 1:additional_locs
    rand_locs(i,:) = [randi(xmax) randi(ymax) randi(zmax)] +...
                                    round([min(handles.data.nuclear_locs(:,1)) min(handles.data.nuclear_locs(:,2)) min(handles.data.nuclear_locs(:,3))]);
end
handles.data.nearby_locations = nearby_locations;
handles.data.rand_locs = rand_locs;
% acq_gui = findobj('Tag','acq_gui');
% acq_gui_data = get_acq_gui_data();
acq_gui_data.data.nearby_locations = nearby_locations;
acq_gui_data.data.rand_locs = rand_locs;
guidata(acq_gui,acq_gui_data);
guidata(hObject,handles)

% whole cell or cell-attached?
% Construct a questdlg with three options
clamp_choice1 = questdlg('Cell 1 Patch Type?', ...
	'Patch type?', ...
	'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
% Handle response
switch clamp_choice1
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell1 = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
        whole_cell1 = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell1 = 0;
end


if whole_cell1
    
    user_confirm = msgbox('Break in! Rs okay? Test pulse off? In v-clamp?');
    waitfor(user_confirm)


%     acq_gui = findobj('Tag','acq_gui');
%     acq_gui_data = guidata(acq_gui);


    % do single testpulse trial to get Rs
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',1)
%     set(acq_gui_data.Cell2_type_popup,'Value',1)
    
    set(acq_gui_data.trial_length,'String',5.0)
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)


    do_intrinsics = 0;
    choice = questdlg('Do intrinsics?', ...
        'Do intrinsics?', ...
        'Cell 1','None','Cell 1');
    % Handle response
    switch choice
        case 'Cell 1'
            do_intrinsics = 1;
            set(acq_gui_data.Cell1_type_popup,'Value',2)
            acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
        case 'Cell 2'
            do_intrinsics = 1;
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        case 'Cell 1 & 2'
            do_intrinsics = 1;
            set(acq_gui_data.Cell1_type_popup,'Value',2)
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
            acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        case 'None'
            do_intrinsics = 0;
    end

    if do_intrinsics
        % tell user to switch to I=0
        user_confirm = msgbox('Please switch Multiclamp to CC with I = 0 for intrinsics cells');
        waitfor(user_confirm)

        % run intrinsic ephys
        % set acq params
        set(acq_gui_data.run,'String','Prepping...')
        
%         guidata(acq_gui,acq_gui_data);
        set(acq_gui_data.test_pulse,'Value',0)
        set(acq_gui_data.trigger_seq,'Value',0)
        % run trial

        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)
        
         switch choice
            case 'Cell 1'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell1_type_popup,'Value',2)
%                 acq_gui_data.data.ch1.pulseamp = 0;
                set(acq_gui_data.ccpulseamp1,'String','0');
                acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
            case 'Cell 2'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell2_type_popup,'Value',2)
%                 acq_gui_data.data.ch2.pulseamp = 0;
                set(acq_gui_data.ccpulseamp2,'String','0');
                acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
            case 'Cell 1 & 2'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell1_type_popup,'Value',2)
%                 set(acq_gui_data.Cell2_type_popup,'Value',2)
                set(acq_gui_data.ccpulseamp1,'String','0');
                acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                set(acq_gui_data.ccpulseamp2,'String','0');
                acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        end
    end


    user_confirm = msgbox('Please switch Multiclamp to VC with desired holding current. Rs is good?');
    waitfor(user_confirm)
end

% Handle response
switch clamp_choice1
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end



guidata(hObject,handles);
guidata(acq_gui,acq_gui_data)

% shift focus
figure(acq_gui)

set(handles.rand_order,'Value',1);
set(handles.num_repeats,'String',num2str(5));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.150));
% POWERS HERE*****************************
user_input_powers = inputdlg('Enter desired powers (space-delimited):',...
             'Powers to run?',1,{'75 100 150'});
user_input_powers = user_input_powers{1};
initial_search_power = inputdlg('Enter initial search power (space-delimited):',...
             'Initial Search Power?',1,{'150'});
initial_search_power = initial_search_power{1};

% PUT IN 



% move obj to z-depth of cell
cell1_z = handles.data.ref_obj_position(3) + handles.data.cell1_pos(3);
set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
set(handles.thenewz,'String',num2str(cell1_z))
[handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

%     handles = guidata(hObject);

% get this z-depth spots
cell1_z = handles.data.cell1_pos(3);
z_thresh_dist = 41;
xy_thresh_dist = 101;
nuclear_locs = handles.data.nuclear_locs;
% cut by within dist of cell_pos
nuclear_locs = ...
    nuclear_locs(abs(nuclear_locs(:,1) - handles.data.cell1_pos(1)) < xy_thresh_dist & ...
                 abs(nuclear_locs(:,2) - handles.data.cell1_pos(2)) < xy_thresh_dist,:);% & ...
                 %abs(nuclear_locs(:,3) - handles.data.cell1_pos(3)) < z_thresh_dist,:);

            
assignin('base','nuclear_locs_for_stim',nuclear_locs)
instruction.type = 82;

instruction.multitarg_locs = [];
instruction.single_spot_locs = [nuclear_locs];
powers = strread(user_input_powers);
init_power = num2str(powers(1));
set(handles.target_intensity,'String',init_power)
set(handles.num_repeats,'String',num2str(3));

%nuclear_locs];
%     instruction.nearby_locs = nearby_locs;
instruction.targs_per_stim = 3;
instruction.repeat_target = 10;
%     if ~isempty(instruction.multitarg_locs)
    instruction.num_stim = ...
        size(instruction.multitarg_locs,1)*(ceil(instruction.repeat_target/instruction.targs_per_stim));
%     else
%         instruction.num_stim = 0;
%     end
instruction.do_target = 1;
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)

set(handles.num_stim,'String',num2str(return_info.num_stim));
set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
set(handles.tf_flag,'Value',1)
set(handles.set_seq_trigger,'Value',0)

[handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles);
%     handles = guidata(hObject);
%     acq_gui_data = get_acq_gui_data();
max_seq_length = str2double(get(handles.max_seq_length,'String'));
this_seq = acq_gui_data.data.sequence;
num_runs = ceil(length(this_seq)/max_seq_length);
start_trial = acq_gui_data.data.sweep_counter + 1;
for run_i = 1:num_runs
    this_subseq = this_seq((run_i-1)*max_seq_length+1:min(run_i*max_seq_length,length(this_seq)));
    time_offset = this_subseq(1).start - 1000;
    for k = 1:length(this_subseq)
        this_subseq(k).start = this_subseq(k).start - time_offset;
    end
    total_duration = (this_subseq(end).start)/1000 + 5;

    set(acq_gui_data.trial_length,'String',num2str(total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    instruction.type = 32; %SEND SEQ
    handles.sequence = this_subseq;
    instruction.sequence = this_subseq;
    handles.total_duration = total_duration;
    instruction.waittime = total_duration + 120;
    disp('sending instruction...')
    [return_info,success,handles] = do_instruction(instruction,handles);
%         acq_gui_data = get_acq_gui_data();
%         acq_gui_data.data.stim_key =  return_info.stim_key;
    acq_gui_data.data.sequence =  this_subseq;
%         acq_gui = findobj('Tag','acq_gui');
    guidata(acq_gui,acq_gui_data)

    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

    guidata(hObject,handles)
%         guidata(acq_gui,acq_gui_data)

    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)


end

% plot map

trials = acq_gui_data.data.sweep_counter;
show_raw_data = 1; do_stdmap = 1; do_corrmap = 0;
[maps,~,~,~,stddev_maps] = ...
    summarize_map(acq_gui_data.data,trials,show_raw_data,do_stdmap,do_corrmap);
assignin('base','maps',maps)
% try
    img_center = [130 127]';
    this_std_map = stddev_maps{end}{1}; % this map location, highest pow, ch 1
    [sorted_stds,sort_order] = sort(this_std_map(:),1,'descend');
    sort_order = sort_order(~isnan(sorted_stds));
    [x_inds, y_inds] = ind2sub(size(this_std_map),sort_order);
    x_inds_1um = x_inds*5 - 155
    y_inds_1um = y_inds*5 - 155
    num_to_show = 5;
    figure
    for jj = 1:num_to_show
        subplot(1,num_to_show,jj)
        plot_trace_stack(maps{1}{x_inds(jj),y_inds(jj)},30,'-')
        title(['Horiz: ' num2str(y_inds_1um(jj)/1.82 + img_center(1))  ', Vert: ' num2str(x_inds_1um(jj)/1.82 + img_center(2))])
    end
%     subplot(152)
%     plot_trace_stack(maps{i}{end}{1}{x_inds(2),y_inds(2)},30,'-')
%     title(['Horiz: ' num2str(y_inds(2)/1.82 + img_center(1))  ', Vert: ' num2str(x_inds(2)/1.82 + img_center(2))])
%     subplot(153)
%     plot_trace_stack(maps{i}{end}{1}{x_inds(3),y_inds(3)},30,'-')
%     title(['Horiz: ' num2str(y_inds(3)/1.82 + img_center(1))  ', Vert: ' num2str(x_inds(3)/1.82 + img_center(2))])
%     subplot(154)
%     plot_trace_stack(maps{i}{end}{1}{x_inds(3),y_inds(3)},30,'-')
%     title(['Horiz: ' num2str(y_inds(3)/1.82 + img_center(1))  ', Vert: ' num2str(x_inds(3)/1.82 + img_center(2))])
%     subplot(155)
%     plot_trace_stack(maps{i}{end}{1}{x_inds(3),y_inds(3)},30,'-')
%     title(['Horiz: ' num2str(y_inds(3)/1.82 + img_center(1))  ', Vert: ' num2str(x_inds(3)/1.82 + img_center(2))])
% catch e
%     disp('Could not plot')
% end

target_loc = inputdlg('Select Target:',...
             'Target?',1,{'1'});
target_loc = str2double(target_loc{1});

% num_spots = ceil(length(sort_order)*(1 - design_iter_std_thresh(rep_ind)));
target_loc_1um = [x_inds(target_loc) y_inds(target_loc)]*5 - 155;
dist_mat = squareform(pdist([nuclear_locs(:,[1 2]); target_loc_1um]));
dist_mat = dist_mat(1:size(nuclear_locs,1),size(nuclear_locs,1)+1:end);
[target_dist, target_ind] = min(dist_mat);

target_cell_loc = nuclear_locs(target_ind,:)

% goto target cell z
target_cell_z = handles.data.ref_obj_position(3) + target_cell_loc(3);
set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
set(handles.thenewz,'String',num2str(target_cell_z))
[handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);


got_connected_cell = 0;

while ~got_connected_cell
    user_confirm = msgbox('Target Cell in cell-attached?');
    waitfor(user_confirm)

    % goto target cell z
    target_cell_z = handles.data.ref_obj_position(3) + target_cell_loc(3);
    set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
    set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
    set(handles.thenewz,'String',num2str(target_cell_z))
    [handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

    set_cell2_pos = 0;
    choice = questdlg('Set Patched Cell 2 Pos?', ...
        'Set Cell Pos?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            set_cell2_pos = 1;
        case 'No'
            set_cell2_pos = 0;
    end

    if set_cell2_pos
        % confirm everything ready
        user_confirm = msgbox('Z-plane aligned with patched cell 2?');
        waitfor(user_confirm)
    % 
    %     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
        disp('click targets...')
        instruction.type = 73;
        instruction.num_targs = 1;
        [return_info,success,handles] = do_instruction(instruction,handles);
        [acq_gui, acq_gui_data] = get_acq_gui_data();
        handles.data.click_targ = return_info.nuclear_locs(1:2);
        acq_gui_data.data.snap_image2 = return_info.snap_image;
        guidata(acq_gui,acq_gui_data)

        handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);

        handles.data.cell2_pos = [handles.data.click_targ handles.data.obj_position(3)] - ...
            [0 0 handles.data.ref_obj_position(3)];

        [acq_gui, acq_gui_data] = get_acq_gui_data();
        acq_gui_data.data.cell2_pos = handles.data.obj_position + [handles.data.click_targ 0];

        set(acq_gui_data.cell2_x,'String',num2str(acq_gui_data.data.cell2_pos(1)));
        set(acq_gui_data.cell2_y,'String',num2str(acq_gui_data.data.cell2_pos(2)));
        set(acq_gui_data.cell2_z,'String',num2str(acq_gui_data.data.cell2_pos(3)));

        guidata(acq_gui, acq_gui_data);
        guidata(hObject,handles)

    end

    set(acq_gui_data.record_cell2_check,'Value',1);

    if set_cell2_pos
        handles.data.nuclear_locs = [handles.data.nuclear_locs; ...
                                     handles.data.cell2_pos];
    end

    acq_gui_data.data.nuclear_locs = handles.data.nuclear_locs;
    guidata(acq_gui,acq_gui_data)


    clamp_choice2 = questdlg('Cell 2 Patch Type?', ...
        'Patch type?', ...
        'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
    % Handle response
    switch clamp_choice2
        case 'Voltage Clamp'
            set(acq_gui_data.Cell2_type_popup,'Value',1)
            set(acq_gui_data.test_pulse,'Value',1)
            whole_cell2 = 1;
        case 'Current Clamp'
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            whole_cell2 = 1;
        case 'Cell Attached'
            set(acq_gui_data.Cell2_type_popup,'Value',3)
            set(acq_gui_data.test_pulse,'Value',1)
            whole_cell2 = 0;
    end

    if whole_cell2

        user_confirm = msgbox('Break in! Rs okay? Test pulse off? In v-clamp?');
        waitfor(user_confirm)


    %     acq_gui = findobj('Tag','acq_gui');
    %     acq_gui_data = guidata(acq_gui);


        % do single testpulse trial to get Rs
        % set acq params
        set(acq_gui_data.run,'String','Prepping...')
        set(acq_gui_data.Cell1_type_popup,'Value',1)
        set(acq_gui_data.Cell2_type_popup,'Value',1)

        set(acq_gui_data.trial_length,'String',5.0)
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        set(acq_gui_data.test_pulse,'Value',1)
        set(acq_gui_data.loop,'Value',1)
        set(acq_gui_data.loop_count,'String',num2str(1))
        set(acq_gui_data.trigger_seq,'Value',0)
        % run trial
        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)


        do_intrinsics = 0;
        choice = questdlg('Do intrinsics?', ...
            'Do intrinsics?', ...
            'Yes','No','Yes');
        switch choice
            case 'Yes'
                choice2 = questdlg('Do intrinsics?', ...
                    'Do intrinsics?', ...
                    'Cell 1','Cell 2','Cell 1 & 2','Cell 1');
                % Handle response
                switch choice2
                    case 'Cell 1'
                        do_intrinsics = 1;
                        set(acq_gui_data.Cell1_type_popup,'Value',2)
                        acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                    case 'Cell 2'
                        do_intrinsics = 1;
                        set(acq_gui_data.Cell2_type_popup,'Value',2)
                        acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
                    case 'Cell 1 & 2'
                        do_intrinsics = 1;
                        set(acq_gui_data.Cell1_type_popup,'Value',2)
                        set(acq_gui_data.Cell2_type_popup,'Value',2)
                        acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                        acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
                    case 'None'
                        do_intrinsics = 0;
                end
            case 'No'
                do_intrinsics = 0;
        end

        if do_intrinsics
            % tell user to switch to I=0
            user_confirm = msgbox('Please switch Multiclamp to CC with I = 0 for intrinsics cells');
            waitfor(user_confirm)

            % run intrinsic ephys
            % set acq params
            set(acq_gui_data.run,'String','Prepping...')

    %         guidata(acq_gui,acq_gui_data);
            set(acq_gui_data.test_pulse,'Value',0)
            set(acq_gui_data.trigger_seq,'Value',0)
            % run trial

            acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
            waitfor(acq_gui_data.run,'String','Start')
            guidata(acq_gui,acq_gui_data)

             switch choice2
                case 'Cell 1'
                    do_intrinsics = 1;
    %                 set(acq_gui_data.Cell1_type_popup,'Value',2)
    %                 acq_gui_data.data.ch1.pulseamp = 0;
                    set(acq_gui_data.ccpulseamp1,'String','0');
                    acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                    acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                case 'Cell 2'
                    do_intrinsics = 1;
    %                 set(acq_gui_data.Cell2_type_popup,'Value',2)
    %                 acq_gui_data.data.ch2.pulseamp = 0;
                    set(acq_gui_data.ccpulseamp2,'String','0');
                    acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                    acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
                case 'Cell 1 & 2'
                    do_intrinsics = 1;
    %                 set(acq_gui_data.Cell1_type_popup,'Value',2)
    %                 set(acq_gui_data.Cell2_type_popup,'Value',2)
                    set(acq_gui_data.ccpulseamp1,'String','0');
                    acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                    set(acq_gui_data.ccpulseamp2,'String','0');
                    acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                    acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                    acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
            end
        end


        user_confirm = msgbox('Please switch Multiclamp to VC with desired holding current. Rs is good?');
        waitfor(user_confirm)
    end

    handles = guidata(hObject);

        % get this z-depth spots

    nuclear_locs = handles.data.cell2_pos;
    instruction.type = 81;
    instruction.target_locs = nuclear_locs;
    instruction.do_target = 1;
    [return_info,success,handles] = do_instruction(instruction,handles);
    guidata(hObject,handles)
        set(handles.rand_order,'Value',1);
    set(handles.num_repeats,'String',num2str(5));
    set(handles.num_stim,'String',num2str(size(nuclear_locs,1)));
    % set(handles.duration,'String',num2str(.003));
    set(handles.iti,'String',num2str(.500));
    set(handles.target_intensity,'String',user_input_powers)

    guidata(hObject,handles)
    set(handles.set_seq_trigger,'Value',1);
    %     set(handles.num_stim,'String',num2str(return_info.num_stim));
    %     set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
    build_seq_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    [acq_gui,acq_gui_data] = get_acq_gui_data();
    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

    guidata(acq_gui,acq_gui_data)

    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)

    % plot map
    cur_trial = acq_gui_data.data.sweep_counter;
    this_seq = acq_gui_data.data.trial_metadata(cur_trial).sequence;
    this_stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
    power_curve_num = unique([this_seq.target_power]);

    for j = 1:length(power_curve_num)
        [traces_ch1,traces_ch2] = ...
        get_stim_stack(acq_gui_data.data,cur_trial,...
            length(this_seq),{[this_seq.start]});

        traces_pow{1} = traces_ch1([this_seq.target_power] == power_curve_num(j),:);
        traces_pow{2} = traces_ch2([this_seq.target_power] == power_curve_num(j),:);
        this_seq_power = this_seq([this_seq.target_power] == power_curve_num(j));
        see_grid_multi(traces_pow,[],this_seq_power,this_stim_key,5,1);

        title(['Power = ' num2str(power_curve_num(j)) ' mW'])
    end
    
%     do_intrinsics = 0;
    choice = questdlg('Connected Cell?', ...
        'Connected Cell?', ...
        'Yes','No','No');
    switch choice
        case 'Yes'
            got_connected_cell = 1;
        case 'No'
            got_connected_cell = 0;
    end
end

user_confirm = msgbox('Map It?');
waitfor(user_confirm)

set(handles.iti,'String',num2str(0.075));

set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(handles.set_seq_trigger,'Value',0);
set(acq_gui_data.loop_count,'String',num2str(1))
num_map_locations = size(obj_positions,1);
num_design_iters = 2;
design_iter_std_thresh = [0 .75];%percentile cutoff

i = 0;
for ii = 1:num_map_locations*num_design_iters
    ii
    new_i = ceil(ii/num_design_iters)
    rep_ind = mod(ii-1,num_design_iters)+1
    if new_i == i
        reduce_map_by_std = 1;
    else
        i = new_i
        % move obj
        set(handles.thenewx,'String',num2str(obj_positions(i,1)))
        set(handles.thenewy,'String',num2str(obj_positions(i,2)))
        set(handles.thenewz,'String',num2str(obj_positions(i,3)))
        [handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
        reduce_map_by_std = 0;
    end
%     handles = guidata(hObject);
    
    % get this z-depth spots
    
    thresh_dist = 41;
    nuclear_locs = handles.data.nuclear_locs;
    % cut by within dist of cell_pos
    nuclear_locs = ...
        nuclear_locs(nuclear_locs(:,3) > (z_offsets(i) - thresh_dist) & ...
                       nuclear_locs(:,3) < (z_offsets(i) + thresh_dist),:);
    % cut by std dev  
    if reduce_map_by_std
        disp('DOING ONLINE DESIGN')      
        this_std_map = stddev_maps{i}{end}{1}; % this map location, highest pow, ch 1
        [sorted_stds,sort_order] = sort(this_std_map(:),1,'descend');
        sort_order = sort_order(~isnan(sorted_stds));
        [x_inds, y_inds] = ind2sub(size(this_std_map),sort_order);
        num_spots = ceil(length(sort_order)*(1 - design_iter_std_thresh(rep_ind)));
        good_locations = [x_inds(1:num_spots) y_inds(1:num_spots)]*1 - 155;
        dist_mat = squareform(pdist([nuclear_locs(:,[1 2]); good_locations]));
        dist_mat = dist_mat(1:size(nuclear_locs,1),size(nuclear_locs,1)+1:end);
        response_locs = any(dist_mat < 5*sqrt(2),2);
        nuclear_locs = nuclear_locs(response_locs,:);
        assignin('base','nuclear_locs',nuclear_locs)
        assignin('base','response_locs',response_locs)
        assignin('base','this_std_map',this_std_map)
    end
    nearby_locs = [handles.data.nearby_locations];
    nearby_locs = ...
        nearby_locs(nearby_locs(:,3) > (z_offsets(i) - thresh_dist) & ...
                       nearby_locs(:,3) < (z_offsets(i) + thresh_dist),:);
% 	nearby_trunc = ceil(size(nearby_locs,1)/2);
%     nearby_choice = randsample(size(nearby_locs,1),nearby_trunc);
%     nearby_locs = nearby_locs(nearby_choice,:);
%     rand_locs = handles.data.rand_locs;
%     rand_locs = ...
%         rand_locs(rand_locs(:,3) > (z_offsets(i) - 21) & ...
%                        rand_locs(:,3) < (z_offsets(i) + 21),:);               
    assignin('base','nuclear_locs_for_stim',nuclear_locs)
    clear instruction
    instruction.type = 82;
    if reduce_map_by_std
        instruction.multitarg_locs = [];
        instruction.single_spot_locs = [nuclear_locs];
        set(handles.target_intensity,'String',user_input_powers)
        set(handles.num_repeats,'String',num2str(20));
    else
        instruction.multitarg_locs = [nuclear_locs];
        instruction.single_spot_locs = [];
        set(handles.target_intensity,'String',initial_search_power)
        set(handles.num_repeats,'String',num2str(1));
    end
    %nuclear_locs];
%     instruction.nearby_locs = nearby_locs;
    instruction.targs_per_stim = 3;
    instruction.repeat_target = 10;
%     if ~isempty(instruction.multitarg_locs)
        instruction.num_stim = ...
            size(instruction.multitarg_locs,1)*(ceil(instruction.repeat_target/instruction.targs_per_stim));
%     else
%         instruction.num_stim = 0;
%     end
    instruction.do_target = 1;
    assignin('base','instruction_targets',instruction)
    [return_info,success,handles] = do_instruction(instruction,handles);
    guidata(hObject,handles)
    
    set(handles.num_stim,'String',num2str(return_info.num_stim));
    set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
    set(handles.tf_flag,'Value',1)
    set(handles.set_seq_trigger,'Value',0)
    
    [handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles);
%     handles = guidata(hObject);
%     acq_gui_data = get_acq_gui_data();
    max_seq_length = str2double(get(handles.max_seq_length,'String'));
    this_seq = acq_gui_data.data.sequence;
    num_runs = ceil(length(this_seq)/max_seq_length);
    start_trial = acq_gui_data.data.sweep_counter + 1;
    for run_i = 1:num_runs
        this_subseq = this_seq((run_i-1)*max_seq_length+1:min(run_i*max_seq_length,length(this_seq)));
        time_offset = this_subseq(1).start - 1000;
        for k = 1:length(this_subseq)
            this_subseq(k).start = this_subseq(k).start - time_offset;
        end
        total_duration = (this_subseq(end).start)/1000 + 5;
        
        set(acq_gui_data.trial_length,'String',num2str(total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        instruction.type = 32; %SEND SEQ
        handles.sequence = this_subseq;
        instruction.sequence = this_subseq;
        handles.total_duration = total_duration;
        instruction.waittime = total_duration + 120;
        disp('sending instruction...')
        [return_info,success,handles] = do_instruction(instruction,handles);
%         acq_gui_data = get_acq_gui_data();
%         acq_gui_data.data.stim_key =  return_info.stim_key;
        acq_gui_data.data.sequence =  this_subseq;
%         acq_gui = findobj('Tag','acq_gui');
        guidata(acq_gui,acq_gui_data)

        set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

        guidata(hObject,handles)
%         guidata(acq_gui,acq_gui_data)

        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)

        
    end
    
    % plot map
    
    trials = start_trial:acq_gui_data.data.sweep_counter;
    show_raw_data = 0; do_stdmap = 1; do_corrmap = 1;
    [maps,~,~,~,stddev_maps{i}] = ...
        summarize_map(acq_gui_data.data,trials,show_raw_data,do_stdmap,do_corrmap);
    try
        this_std_map = stddev_maps{i}{end}{1}; % this map location, highest pow, ch 1
        [sorted_stds,sort_order] = sort(this_std_map(:),1,'descend');
        sort_order = sort_order(~isnan(sorted_stds));
        [x_inds, y_inds] = ind2sub(size(this_std_map),sort_order);
        figure
        subplot(131)
        plot_trace_stack(maps{i}{end}{1}{x_inds(1),y_inds(1)},30,'-')
        title(['Horiz: ' num2str(y_inds(1)/1.82 - 129)  ', Vert: ' num2str(x_inds(1)/1.82 - 131)])
        subplot(132)
        plot_trace_stack(maps{i}{end}{1}{x_inds(2),y_inds(2)},30,'-')
        title(['Horiz: ' num2str(y_inds(2)/1.82 - 129)  ', Vert: ' num2str(x_inds(2)/1.82 - 131)])
        subplot(133)
        plot_trace_stack(maps{i}{end}{1}{x_inds(3),y_inds(3)},30,'-')
        title(['Horiz: ' num2str(y_inds(3)/1.82 - 129)  ', Vert: ' num2str(x_inds(3)/1.82 - 131)])
    catch e
        disp('Could not plot')
    end
%     this_seq_plot = acq_gui_data.data.trial_metadata(cur_trial).sequence;
%     this_stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
%     power_curve_num = unique([this_seq_plot.target_power]);
%     show_raw_data = 0;
%     for j = 1:length(power_curve_num)
%         [traces_ch1,traces_ch2] = ...
%         get_stim_stack(acq_gui_data.data,cur_trial,...
%             length(this_seq_plot),[this_seq_plot.start]);
% 
%         traces_pow{1} = traces_ch1([this_seq_plot.target_power] == power_curve_num(j),:);
%         traces_pow{2} = traces_ch2([this_seq_plot.target_power] == power_curve_num(j),:);
%         this_seq_power = this_seq_plot([this_seq_plot.target_power] == power_curve_num(j));
%         [~,~,~,stddev_maps] = ...
%             see_grid_multi(traces_pow,this_seq_power,this_stim_key,5,show_raw_data);
%         if show_raw_data
%             title(['Power = ' num2str(power_curve_num(j)) ' mW'])
%         end
%     end

end

set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)


% --- Executes on button press in map_w_online.
function map_w_online_Callback(hObject, eventdata, handles)
% hObject    handle to map_w_online (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.close_socket_check,'Value',0)
guidata(hObject,handles);

user_confirm = msgbox('Set Reference Position for Objective/SLM Zero-Order?');
waitfor(user_confirm)
handles = update_obj_pos_Callback(hObject, eventdata, handles);
[acq_gui, acq_gui_data] = get_acq_gui_data;
acq_gui_data.data.ref_obj_position = handles.data.obj_position;
handles.data.ref_obj_position = handles.data.obj_position;
guidata(acq_gui, acq_gui_data);
guidata(hObject,handles)

set_cell_pos = 0;
choice = questdlg('Set Patched Cell 1 Pos?', ...
	'Set Cell Pos?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        set_cell_pos = 1;
    case 'No'
        set_cell_pos = 0;
end

if set_cell_pos
    
    % confirm everything ready
    user_confirm = msgbox('Z-plane aligned with patched cell 1?');
    waitfor(user_confirm)
% 
%     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    disp('click targets...')
    instruction.type = 73;
    instruction.num_targs = 1;
    [return_info,success,handles] = do_instruction(instruction,handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    handles.data.click_targ = return_info.nuclear_locs(1:2);
    acq_gui_data.data.cell1_snap_image = return_info.snap_image;
    guidata(acq_gui,acq_gui_data)
    
%     [acq_gui, acq_gui_data] = get_acq_gui_data();
    
    handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);
    handles.data.cell1_pos = [handles.data.click_targ handles.data.obj_position(3)] - ...
        [0 0 handles.data.ref_obj_position(3)];
    acq_gui_data.data.cell_pos = handles.data.obj_position + [handles.data.click_targ 0];
    acq_gui_data.data.ref_obj_pos = handles.data.ref_obj_position;
    
    set(acq_gui_data.cell_x,'String',num2str(acq_gui_data.data.cell_pos(1)));
    set(acq_gui_data.cell_y,'String',num2str(acq_gui_data.data.cell_pos(2)));
    set(acq_gui_data.cell_z,'String',num2str(acq_gui_data.data.cell_pos(3)));
    
    guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)

end


set_cell2_pos = 0;
choice = questdlg('Set Patched Cell 2 Pos?', ...
	'Set Cell Pos?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        set_cell2_pos = 1;
    case 'No'
        set_cell2_pos = 0;
end

if set_cell2_pos
    % confirm everything ready
    user_confirm = msgbox('Z-plane aligned with patched cell 2?');
    waitfor(user_confirm)
% 
%     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    disp('click targets...')
    instruction.type = 73;
    instruction.num_targs = 1;
    [return_info,success,handles] = do_instruction(instruction,handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    handles.data.click_targ = return_info.nuclear_locs(1:2);
    acq_gui_data.data.cell2_snap_image = return_info.snap_image;
    guidata(acq_gui,acq_gui_data)
    
    handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);
    
    handles.data.cell2_pos = [handles.data.click_targ handles.data.obj_position(3)] - ...
        [0 0 handles.data.ref_obj_position(3)];
    
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    acq_gui_data.data.cell2_pos = handles.data.obj_position + [handles.data.click_targ 0];
    set(acq_gui_data.cell2_x,'String',num2str(acq_gui_data.data.cell2_pos(1)));
    set(acq_gui_data.cell2_y,'String',num2str(acq_gui_data.data.cell2_pos(2)));
    set(acq_gui_data.cell2_z,'String',num2str(acq_gui_data.data.cell2_pos(3)));
    
    guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)
    
    set(acq_gui_data.record_cell2_check,'Value',1);

end



% move obj to ref position (top of slice, centered on map fov)
set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
set(handles.thenewz,'String',num2str(handles.data.ref_obj_position(3)))

[handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

% make obj locations
% z_offsets = [30]';
% z_offsets = handles.data.cell2_pos(3) handles.data.cell1_pos(3)];\
if ~set_cell2_pos
    z_offsets = inputdlg('Z Locations?',...
             'Z Locations?',1,{[num2str(handles.data.cell1_pos(3))]});
else
    z_offsets = inputdlg('Z Locations?',...
                 'Z Locations?',1,{[num2str(handles.data.cell1_pos(3)) ' ' num2str(handles.data.cell2_pos(3))]});
end
z_offsets = strread(z_offsets{1})';
obj_positions = [zeros(length(z_offsets),1) zeros(length(z_offsets),1) z_offsets];
obj_positions = bsxfun(@plus,obj_positions,handles.data.obj_position);

guidata(hObject,handles);

% disp('take stack and nuclear detect...')
% 
% set(handles.close_socket_check,'Value',0);
% clock_array = clock;
% stackname = [num2str(clock_array(2)) '_' num2str(clock_array(3)) ...
%     '_' num2str(clock_array(4)) ...
%     '_' num2str(clock_array(5))];
% 
% instruction.type = 00;
% instruction.string = stackname;
% disp('sending instruction...')
% [return_info,success,handles] = do_instruction(instruction,handles);

% user_confirm = msgbox(sprintf('Stack Taken with 2um spacing?\nUse name: %s',...
%     stackname));
% waitfor(user_confirm)

% acq_gui = findobj('Tag','acq_gui');
% acq_gui_data = get_acq_gui_data();
% acq_gui_data.data.stackname = stackname;
% guidata(acq_gui,acq_gui_data)


disp('detecting nuclei...')
instruction.type = 74;
instruction.stackname = stackname;
[return_info,success,handles] = do_instruction(instruction,handles);
acq_gui_data.data.nuclear_locs = return_info.nuclear_locs;
handles.data.nuclear_locs = return_info.nuclear_locs;

acq_gui_data.data.nuclear_locs = handles.data.nuclear_locs;
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)
assignin('base','nuclear_locs_w_cells',handles.data.nuclear_locs)

set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
set(handles.thenewz,'String',num2str(handles.data.ref_obj_position(3)))

[handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);


% whole cell or cell-attached?
% Construct a questdlg with three options
clamp_choice1 = questdlg('Cell 1 Patch Type?', ...
	'Patch type?', ...
	'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
% Handle response
switch clamp_choice1
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell1 = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
        whole_cell1 = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell1 = 0;
end

if set_cell2_pos
    clamp_choice2 = questdlg('Cell 2 Patch Type?', ...
        'Patch type?', ...
        'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
    % Handle response
    switch clamp_choice2
        case 'Voltage Clamp'
            set(acq_gui_data.Cell2_type_popup,'Value',1)
            set(acq_gui_data.test_pulse,'Value',1)
            whole_cell2 = 1;
        case 'Current Clamp'
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            whole_cell2 = 1;
        case 'Cell Attached'
            set(acq_gui_data.Cell2_type_popup,'Value',3)
            set(acq_gui_data.test_pulse,'Value',1)
            whole_cell2 = 0;
    end
else
    clamp_choice2 = 'Cell Attached';
    set(acq_gui_data.Cell2_type_popup,'Value',3)
    set(acq_gui_data.test_pulse,'Value',0)
    whole_cell2 = 0;
end

if whole_cell1 || whole_cell2
    
    user_confirm = msgbox('Break in! Rs okay? Test pulse off? In v-clamp?');
    waitfor(user_confirm)


%     acq_gui = findobj('Tag','acq_gui');
%     acq_gui_data = guidata(acq_gui);


    % do single testpulse trial to get Rs
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    set(acq_gui_data.Cell2_type_popup,'Value',1)
    
    set(acq_gui_data.trial_length,'String',5.0)
    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
    set(acq_gui_data.trigger_seq,'Value',0)
    % run trial
    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    waitfor(acq_gui_data.run,'String','Start')
    guidata(acq_gui,acq_gui_data)


    do_intrinsics = 0;
    choice = questdlg('Do intrinsics?', ...
        'Do intrinsics?', ...
        'Cell 1','None','Cell 1 & 2','None');
    % Handle response
    switch choice
        case 'Cell 1'
            do_intrinsics = 1;
            set(acq_gui_data.Cell1_type_popup,'Value',2)
            acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
        case 'Cell 2'
            do_intrinsics = 1;
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        case 'Cell 1 & 2'
            do_intrinsics = 1;
            set(acq_gui_data.Cell1_type_popup,'Value',2)
            set(acq_gui_data.Cell2_type_popup,'Value',2)
            acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
            acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        case 'None'
            do_intrinsics = 0;
    end

    if do_intrinsics
        % tell user to switch to I=0
        user_confirm = msgbox('Please switch Multiclamp to CC with I = 0 for intrinsics cells');
        waitfor(user_confirm)

        % run intrinsic ephys
        % set acq params
        set(acq_gui_data.run,'String','Prepping...')
        
%         guidata(acq_gui,acq_gui_data);
        set(acq_gui_data.test_pulse,'Value',0)
        set(acq_gui_data.trigger_seq,'Value',0)
        % run trial

        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)
        
         switch choice
            case 'Cell 1'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell1_type_popup,'Value',2)
%                 acq_gui_data.data.ch1.pulseamp = 0;
                set(acq_gui_data.ccpulseamp1,'String','0');
                acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
            case 'Cell 2'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell2_type_popup,'Value',2)
%                 acq_gui_data.data.ch2.pulseamp = 0;
                set(acq_gui_data.ccpulseamp2,'String','0');
                acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
            case 'Cell 1 & 2'
                do_intrinsics = 1;
%                 set(acq_gui_data.Cell1_type_popup,'Value',2)
%                 set(acq_gui_data.Cell2_type_popup,'Value',2)
                set(acq_gui_data.ccpulseamp1,'String','0');
                acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                set(acq_gui_data.ccpulseamp2,'String','0');
                acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
        end
    end


    user_confirm = msgbox('Please switch Multiclamp to VC with desired holding current. Rs is good?');
    waitfor(user_confirm)
end

% Handle response
switch clamp_choice1
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end

switch clamp_choice2
    case 'Voltage Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',1)
        set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;
    case 'Current Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',2)
        set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
%         set(acq_gui_data.Cell1_type_popup,'Value',3)
        set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end

guidata(hObject,handles);
guidata(acq_gui,acq_gui_data)

% shift focus
figure(acq_gui)

set(handles.rand_order,'Value',1);
set(handles.num_repeats,'String',num2str(10));
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.075));
% POWERS HERE*****************************
user_input_powers = inputdlg('Enter desired powers (space-delimited):',...
             'Powers to run?',1,{'50 75 100'});
user_input_powers = user_input_powers{1};
initial_search_power = inputdlg('Enter initial search power (space-delimited):',...
             'Initial Search Power?',1,{'100'});
initial_search_power = initial_search_power{1};

set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
num_map_locations = size(obj_positions,1);
num_design_iters = 1;
design_iter_std_thresh = [0 .75];%percentile cutoff

i = 0;
for ii = 1:num_map_locations*num_design_iters
    ii
    new_i = ceil(ii/num_design_iters)
    rep_ind = mod(ii-1,num_design_iters)+1
    if num_design_iters > 1 && new_i == i
        reduce_map_by_std = 1;
    else
        i = new_i
        % move obj
        set(handles.thenewx,'String',num2str(obj_positions(i,1)))
        set(handles.thenewy,'String',num2str(obj_positions(i,2)))
        set(handles.thenewz,'String',num2str(obj_positions(i,3)))
        [handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
        reduce_map_by_std = 0;
    end
%     handles = guidata(hObject);
    
    % get this z-depth spots
    
    thresh_dist = 15;
    nuclear_locs = handles.data.nuclear_locs;
    % cut by z
    nuclear_locs = ...
        nuclear_locs(nuclear_locs(:,3) > (z_offsets(i) - thresh_dist) & ...
                       nuclear_locs(:,3) < (z_offsets(i) + thresh_dist),:);
    % cut by std dev  
    if reduce_map_by_std
        disp('DOING ONLINE DESIGN')      
        this_std_map = stddev_maps{i}{end}{1}; % this map location, highest pow, ch 1
        [sorted_stds,sort_order] = sort(this_std_map(:),1,'descend');
        sort_order = sort_order(~isnan(sorted_stds));
        [x_inds, y_inds] = ind2sub(size(this_std_map),sort_order);
        num_spots = ceil(length(sort_order)*(1 - design_iter_std_thresh(rep_ind)));
        good_locations = [x_inds(1:num_spots) y_inds(1:num_spots)]*1 - 151;
        dist_mat = squareform(pdist([nuclear_locs(:,[1 2]); good_locations]));
        dist_mat = dist_mat(1:size(nuclear_locs,1),size(nuclear_locs,1)+1:end);
        response_locs = any(dist_mat < 5*sqrt(2),2);
        nuclear_locs = nuclear_locs(response_locs,:);
        assignin('base','nuclear_locs',nuclear_locs)
        assignin('base','response_locs',response_locs)
        assignin('base','this_std_map',this_std_map)
    end
    nearby_locs = [handles.data.nearby_locations];
    nearby_locs = ...
        nearby_locs(nearby_locs(:,3) > (z_offsets(i) - thresh_dist) & ...
                       nearby_locs(:,3) < (z_offsets(i) + thresh_dist),:);
% 	nearby_trunc = ceil(size(nearby_locs,1)/2);
%     nearby_choice = randsample(size(nearby_locs,1),nearby_trunc);
%     nearby_locs = nearby_locs(nearby_choice,:);
%     rand_locs = handles.data.rand_locs;
%     rand_locs = ...
%         rand_locs(rand_locs(:,3) > (z_offsets(i) - 21) & ...
%                        rand_locs(:,3) < (z_offsets(i) + 21),:);               
    assignin('base','nuclear_locs_for_stim',nuclear_locs)
    instruction.type = 82;
    if num_design_iters == 1 || reduce_map_by_std
        instruction.multitarg_locs = [];
        instruction.single_spot_locs = [nuclear_locs];
        set(handles.target_intensity,'String',user_input_powers)
        set(handles.num_repeats,'String',num2str(20));
    else
        instruction.multitarg_locs = [nuclear_locs];
        instruction.single_spot_locs = [];
        set(handles.target_intensity,'String',initial_search_power)
        set(handles.num_repeats,'String',num2str(1));
    end
    %nuclear_locs];
%     instruction.nearby_locs = nearby_locs;
    instruction.targs_per_stim = 3;
    instruction.repeat_target = 10;
%     if ~isempty(instruction.multitarg_locs)
        instruction.num_stim = ...
            size(instruction.multitarg_locs,1)*ceil(instruction.repeat_target/instruction.targs_per_stim);
%     else
%         instruction.num_stim = 0;
%     end
    instruction.do_target = 1;
    assignin('base','instruction',instruction)
    [return_info,success,handles] = do_instruction(instruction,handles);
    guidata(hObject,handles)
    
    set(handles.num_stim,'String',num2str(return_info.num_stim));
    set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
    set(handles.tf_flag,'Value',1)
    set(handles.set_seq_trigger,'Value',0)
    
    [handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles);
%     handles = guidata(hObject);
%     acq_gui_data = get_acq_gui_data();
    max_seq_length = str2double(get(handles.max_seq_length,'String'));
    this_seq = acq_gui_data.data.sequence;
    num_runs = ceil(length(this_seq)/max_seq_length);
    start_trial = acq_gui_data.data.sweep_counter + 1;
    for run_i = 1:num_runs
        this_subseq = this_seq((run_i-1)*max_seq_length+1:min(run_i*max_seq_length,length(this_seq)));
        time_offset = this_subseq(1).start - 1000;
        for k = 1:length(this_subseq)
            this_subseq(k).start = this_subseq(k).start - time_offset;
        end
        total_duration = (this_subseq(end).start)/1000 + 5;
        
        set(acq_gui_data.trial_length,'String',num2str(total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        instruction.type = 32; %SEND SEQ
        handles.sequence = this_subseq;
        instruction.sequence = this_subseq;
        handles.total_duration = total_duration;
        instruction.waittime = total_duration + 120;
        disp('sending instruction...')
        [return_info,success,handles] = do_instruction(instruction,handles);
%         acq_gui_data = get_acq_gui_data();
%         acq_gui_data.data.stim_key =  return_info.stim_key;
        acq_gui_data.data.sequence =  this_subseq;
%         acq_gui = findobj('Tag','acq_gui');
        guidata(acq_gui,acq_gui_data)

        set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

        guidata(hObject,handles)
%         guidata(acq_gui,acq_gui_data)

        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        guidata(acq_gui,acq_gui_data)

        
    end
    
    % plot map
    try
        trials = start_trial:acq_gui_data.data.sweep_counter;
        show_raw_data = 1; do_stdmap = 1; do_corrmap = 1;
        [maps,~,~,~,stddev_maps{i}] = ...
            summarize_map(acq_gui_data.data,trials,show_raw_data,do_stdmap,do_corrmap);
    
%         this_std_map = stddev_maps{i}{end}{1}; % this map location, highest pow, ch 1
%         [sorted_stds,sort_order] = sort(this_std_map(:),1,'descend');
%         sort_order = sort_order(~isnan(sorted_stds));
%         [x_inds, y_inds] = ind2sub(size(this_std_map),sort_order);
%         figure
%         subplot(131)
%         plot_trace_stack(maps{i}{end}{1}{x_inds(1),y_inds(1)},30,'-')
%         title(['Horiz: ' num2str(y_inds(1)/1.82 - 129)  ', Vert: ' num2str(x_inds(1)/1.82 - 131)])
%         subplot(132)
%         plot_trace_stack(maps{i}{end}{1}{x_inds(2),y_inds(2)},30,'-')
%         title(['Horiz: ' num2str(y_inds(2)/1.82 - 129)  ', Vert: ' num2str(x_inds(2)/1.82 - 131)])
%         subplot(133)
%         plot_trace_stack(maps{i}{end}{1}{x_inds(3),y_inds(3)},30,'-')
%         title(['Horiz: ' num2str(y_inds(3)/1.82 - 129)  ', Vert: ' num2str(x_inds(3)/1.82 - 131)])
    catch e
        disp('Could not plot')
    end
%     this_seq_plot = acq_gui_data.data.trial_metadata(cur_trial).sequence;
%     this_stim_key = acq_gui_data.data.trial_metadata(cur_trial).stim_key;
%     power_curve_num = unique([this_seq_plot.target_power]);
%     show_raw_data = 0;
%     for j = 1:length(power_curve_num)
%         [traces_ch1,traces_ch2] = ...
%         get_stim_stack(acq_gui_data.data,cur_trial,...
%             length(this_seq_plot),[this_seq_plot.start]);
% 
%         traces_pow{1} = traces_ch1([this_seq_plot.target_power] == power_curve_num(j),:);
%         traces_pow{2} = traces_ch2([this_seq_plot.target_power] == power_curve_num(j),:);
%         this_seq_power = this_seq_plot([this_seq_plot.target_power] == power_curve_num(j));
%         [~,~,~,stddev_maps] = ...
%             see_grid_multi(traces_pow,this_seq_power,this_stim_key,5,show_raw_data);
%         if show_raw_data
%             title(['Power = ' num2str(power_curve_num(j)) ' mW'])
%         end
%     end

end

set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction(instruction,handles);
guidata(hObject,handles)