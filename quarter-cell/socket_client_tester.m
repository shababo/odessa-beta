function varargout = socket_client_tester(varargin)
% SOCKET_CLIENT_TESTER MATLAB code for socket_client_tester.fig
%      SOCKET_CLIENT_TESTER, by itself, creates a new SOCKET_CLIENT_TESTER or raises the existing
%      singleton*.
%
%      H = SOCKET_CLIENT_TESTER returns the handle to a new SOCKET_CLIENT_TESTER or the handle to
%      the existing singleton*.
%
%      SOCKET_CLIENT_TESTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOCKET_CLIENT_TESTER.M with the given input arguments.
%
%      SOCKET_CLIENT_TESTER('Property','Value',...) creates a new SOCKET_CLIENT_TESTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before socket_client_tester_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to socket_client_tester_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help socket_client_tester

% Last Modified by GUIDE v2.5 13-Mar-2017 14:24:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @socket_client_tester_OpeningFcn, ...
                   'gui_OutputFcn',  @socket_client_tester_OutputFcn, ...
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


% --- Executes just before socket_client_tester is made visible.
function socket_client_tester_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to socket_client_tester (see VARARGIN)

% Choose default command line output for socket_client_tester
handles.output = hObject;

if ~isempty(varargin) && ~isempty(varargin{1})
    location = varargin{1};
else
    location = 'slidebook';
end

switch location
    case 'slidebook'
        handles.server_ipaddress = '128.32.177.239';
        handles.port_num = 3000;
        handles.client_port = 3001;
    case 'turing'
        handles.server_ipaddress = '128.32.177.238';
        handles.port_num = 3001;
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes socket_client_tester wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = socket_client_tester_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'BackgroundColor',[.8 .8 .8])
drawnow
disp('init socket if not...')
if ~isfield(handles,'sock') 
    handles.sock = -1;
% elseif isfield(handles,'sock') && isfield(handles,'close_socket') && handles.close_
end

while handles.sock < 0
    disp('attempting to open socket')
    handles.sock = msconnect(handles.server_ipaddress,handles.port_num);
    drawnow
end


disp('waiting for instruction...')
% if ~isfield(handles,'waittime')
%     handles.waittime = 120;
% end
instruction = [];
while isempty(instruction)
    disp('check for instruction...')
    [instruction, success] = msrecv(handles.sock,5);
end

if isempty(instruction)
    disp('no instruction!!')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
    guidata(hObject,handles)
    return
end

assignin('base','instruction',instruction)
disp('got info...')

MOVE_OBJ = 10;
GET_OBJ_POS_STEP0 = 20;
GET_OBJ_POS_STEP1 = 21;
GET_SEQ = 30;
RETRIGGER_SEQ = 31;
GET_VAR = 40;
PRECOMPUTE_PHASE = 50;
OBJ_GO_TO = 60;
DETECT_NUC = 70;
DETECT_NUC_LOCAL = 71;
DETECT_NUC_SERVE = 72;
PRECOMPUTE_PHASE_NUCLEAR = 81;
PRINT = 00;
instruction.type
return_info = struct();
if success >= 0
    disp('doing something...')
    instruction.type
    switch instruction.type
        case PRINT
            disp(instruction.string)
        case OBJ_GO_TO
            disp('moving obj...')
            vars{1} = instruction.theNewX';
            names{1} = 'theNewX';
            vars{2} = instruction.theNewY;
            names{2} = 'theNewY';
            vars{3} = instruction.theNewZ;
            names{3} = 'theNewZ';
%             vars{4} = 1;
%             names{4} = 'isMoveStageAbsolute';
            assignin_base(names,vars);
            evalin('base','move_stage_absolute')
            
%             pause(1)
%             pause(1)
%             pause(1)
%             pause(1)
%             java.lang.Thread.sleep(5*1000);
%             return_info.currX = getVariable('base','currentStageX');
%             return_info.currY = getVariable('base','currentStageY');
%             return_info.currZ = getVariable('base','currentStageZ');
%             pause(2)
%             assignin_base({'isGetStageLocation'},{1})
%             pause(3)
            return_info.currX = evalin('base','currentStageX');
            return_info.currY = evalin('base','currentStageY');
            return_info.currZ = evalin('base','currentStageZ');
            return_info.success = 1;
        case MOVE_OBJ
            disp('moving obj...')
            vars{1} = instruction.deltaX;
            names{1} = 'deltaX';
            vars{2} = instruction.deltaY;
            names{2} = 'deltaY';
            vars{3} = instruction.deltaZ;
            names{3} = 'deltaZ';
%             vars{4} = 1;
%             names{4} = 'isMoveStageRelative';
            assignin_base(names,vars);
            evalin('base','move_stage_relative');
%             pause(1)
%             pause(1)
%             pause(1)
%             pause(1)
%             java.lang.Thread.sleep(5*1000);
%             return_info.currX = getVariable('base','currentStageX');
%             return_info.currY = getVariable('base','currentStageY');
%             return_info.currZ = getVariable('base','currentStageZ');
% %             pause(2)
%             assignin_base({'isGetStageLocation'},{1})
%             pause(3)
            return_info.currX = evalin('base','currentStageX');
            return_info.currY = evalin('base','currentStageY');
            return_info.currZ = evalin('base','currentStageZ');
            return_info.success = 1;
            
        case GET_OBJ_POS_STEP0
            disp('prepping ws')
            evalin('base','clear currentStageX')
            evalin('base','clear currentStageY')
            evalin('base','clear currentStageZ')
%             assignin_base({'isGetStageLocation'},{1})
            evalin('base','get_stage_location')
            return_info.currX = evalin('base','currentStageX');
            return_info.currY = evalin('base','currentStageY');
            return_info.currZ = evalin('base','currentStageZ');
            return_info.success = 1;

        case GET_OBJ_POS_STEP1
            disp('getting pos vars')
            return_info.currX = evalin('base','currentStageX');
            return_info.currY = evalin('base','currentStageY');
            return_info.currZ = evalin('base','currentStageZ');
            return_info.success = 1;
        case GET_SEQ
            disp('setting seq')
            sequence = instruction.sequence;
            tf_flag = instruction.tf_flag;
            if sequence(1).power > 2
                if tf_flag
                    lut = evalin('base','lut_tf');
                    pockels_ratio_refs = evalin('base','pockels_ratio_refs_tf');
                else
                    lut = evalin('base','lut_notf');
                    pockels_ratio_refs = evalin('base','pockels_ratio_refs_notf');                
                end
            end
%             pockels_ratio_refs = [pockels_ratio_refs pockels_ratio_refs];
            for i = 1:length(sequence)
                if sequence(i).power > 2
                    ind = sequence(i).precomputed_target_index;
                    sequence(i).target_power = sequence(i).power;
                    sequence(i).power = 100*get_voltage(lut,pockels_ratio_refs(ind)*sequence(i).power);
                else
                    sequence(i).power = sequence(i).power*100;
                end
            end
            %sequence(i).precomputed_target_index
            vars{1} = sequence;
            names{1} = 'sequence';
%             vars{2} = 1;
%             names{2} = 'isTriggeredSequenceReady';
            assignin_base(names,vars);
            evalin('base','set_seq_trigger')
%             pause(1)
            return_info.success = 1;
            if tf_flag
                return_info.stim_key = evalin('base','tf_stim_key');
                pockels_ratio_refs = evalin('base','pockels_ratio_refs_tf');
            else
                return_info.stim_key = evalin('base','notf_stim_key');
                pockels_ratio_refs = evalin('base','pockels_ratio_refs_notf');                
            end
            return_info.sequence = sequence;
            
        case RETRIGGER_SEQ
%             vars{1} = 1;
%             names{1} = 'isTriggeredSequenceReady';
%             assignin_base(names,vars);
%             pause(1)
            evalin('base','set_seq_trigger')
            return_info.success = 1;
        case GET_VAR
            assignin_base({instruction.name},{instruction.value})
            return_info.success = 1;
        case DETECT_NUC_LOCAL
            system(['smbclient //adesnik2.ist.berkeley.edu/inhibition adesnik110623 -c ''cd /shababo ; '...
                'get ' instruction.stackname '.tif ' '/media/shababo/data/' '5_5_10_6' '.tif''']);
            pause(1)
            nuclear_locs = detect_nuclei(['/media/shababo/data/' '5_5_10_6']);
%             nuclear_locs = [1 2 3; 4 5 6; 7 8 9; 1 2 3];
            return_info.nuclear_locs = nuclear_locs;
        case DETECT_NUC_SERVE
            instruction_out.type = DETECT_NUC_LOCAL;
            instruction_out.stackname = instruction.stackname;
            copyfile([instruction.stackname '_C0.tif'], ['Y:\shababo\' instruction.stackname '.tif']);
            pause(1)
            [return_info,success,handles] = do_instruction(instruction_out,handles) ;
            
        case PRECOMPUTE_PHASE
            tf_flag = instruction.tf_flag;
            if tf_flag
                spots_phase = evalin('base','tf_all_spots_phase');
%                 pockels_ratio_refs = evalin('base','pockels_ratio_refs_tf');
            else
                spots_phase = evalin('base','notf_all_spots_phase');
%                 pockels_ratio_refs = evalin('base','pockels_ratio_refs_notf');                
            end
            diskRadii = evalin('base','diskRadii');
            diskPhase = evalin('base','diskPhase');
        case PRECOMPUTE_PHASE_NUCLEAR
            
            disk_grid = evalin('base','tf_disk_grid');
            disk_key = evalin('base','tf_disk_key');
            fine_spot_grid = evalin('base','tf_fine_spots_phase');
            fine_spot_key = evalin('base','tf_fine_spots_key');
            do_target = 0;
            phase_masks_target = ...
                build_single_loc_phases(locations,coarse_disks,disk_key,...
                fine_spots,spot_key,do_target);
            if do_target
                vars{1} = phase_masks_target;
                names{1} = 'precomputed_target';
                evalin('base','set_precomp_target_ready')
            end
                
            assignin_base(names,vars);
    end
    
    
end
clear return_info
return_info.test_turing = 1;
return_info.nuclear_locs = nuclear_locs;
assignin('base','return_info',return_info)
disp('sending return info')
mssend(handles.sock,return_info);
handles.close_socket = instruction.close_socket;
% if isfield(instruction,'waittime')
%     handles.waittime = instruction.waittime
% else
%     handles.waittime = 120
% end

guidata(hObject,handles)


if isfield(instruction,'close_socket') && instruction.close_socket
    disp('closing socket')
    msclose(handles.sock)
%     handles.sock = -1;
    handles = rmfield(handles,'sock');
elseif ~isfield(instruction,'close_socket')
    disp('closing socket')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
else
    disp('socket open')
    
    start_Callback(hObject, eventdata, handles)
%     warndlg('restart socket!')
%     set(handles.start,'BackgroundColor','Red')
%     
%     drawnow
end
guidata(hObject,handles)

% %recur!
% if isfield(instruction,'reset') && instruction.reset
%     start_Callback(hObject, eventdata, handles)
% end


function assignin_base(names,vars)

for i = 1:length(names)
    assignin('base',names{i},vars{i});
end

function vname_string = vname(var)

vname_string = inputname(1);
            
            
            
            
            
            
            


% --- Executes on button press in check_socket.
function check_socket_Callback(hObject, eventdata, handles)
% hObject    handle to check_socket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in close_socket.
function close_socket_Callback(hObject, eventdata, handles)
% hObject    handle to close_socket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'sock') && handles.sock > 0
    disp('closing socket')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
    guidata(hObject,handles)
else
    disp('no socket')
end

set(handles.socket_status,'String','Socket: Closed')

function [return_info, success, handles] = do_instruction(instruction, handles)

instruction.close_socket = 1;
% if instruction.type == 21
%     handles.sock
% end
if ~isfield(handles,'sock_out')
    disp('opening socket...')
    srvsock = mslisten(handles.client_port);
%     handles.sock = -1;
    handles.sock_out = msaccept(srvsock);
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
mssend(handles.sock_out,instruction);
disp('getting return info...')
pause(.1)
[return_info, success] = msrecv(handles.sock_out,15);
assignin('base','return_info',return_info)
% success = 1;

if instruction.close_socket
    disp('closing socket')
    msclose(handles.sock_out)
    handles = rmfield(handles,'sock_out');
end
