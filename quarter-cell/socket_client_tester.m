
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
                   'gui_LayoutFcn',  [] , ...c
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
    server_location = varargin{1};
else
    server_location = 'ephys';
end

if length(varargin) > 1 && ~isempty(varargin{2})
    client_location = varargin{2};
else
    client_location = 'slidebook';
end

switch server_location
    case 'ephys'
        handles.server_ipaddress = '128.32.177.239';
    case 'c'
        handles.server_ipaddress = '128.32.177.238';
end

switch client_location
    case 'slidebook'
        handles.port_num = 3000;
        handles.data = struct();
    case 'analysis'
        handles.port_num = 3001;
%         handles.data.params = init_oed(0);
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
disp('attempting to open socket')

while handles.sock < 0

% sock = -1;
% while sock < 0

    handles.sock = msconnect(handles.server_ipaddress,handles.port_num);
%     sock = msconnect('128.32.177.239',3000);
    drawnow
end


disp('waiting for instruction...')
% if ~isfield(handles,'waittime')
%     handles.waittime = 120;
% end
instruction = [];
disp('check for instruction...')
pause(.1)
disp('check for instruction...')
while isempty(instruction)

    
    [instruction, success] = msrecv(handles.sock,.5);

end
disp('got instruction')
if isempty(instruction)
    disp('no instruction!!')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
    guidata(hObject,handles)
    return
end

assignin('base','instruction',instruction)
disp('got info...')



[return_info,handles] = do_instruction(instruction,handles);

assignin('base','return_info',return_info)
disp('sending return info')
mssend(handles.sock,return_info);
handles.close_socket = instruction.close_socket;
% if isfield(instruction,'waittime')
%     handles.waittime = instruction.waittime
% else
%     handles.waittime = 120
% end

handles.data.return_info = return_info;
guidata(hObject,handles)

% pause(10);

if ~isfield(instruction,'close_socket') || ...
        (isfield(instruction,'close_socket') && instruction.close_socket)
        
    disp('closing socket')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
    dont_close_restart = 0;
elseif isfield(instruction,'close_socket')
    dont_close_restart = 1;
end
guidata(hObject,handles)
if (isfield(instruction,'restart_socket') && instruction.restart_socket) || ...
        dont_close_restart
    
    disp('socket open')
    start_Callback(hObject, eventdata, handles)

end
guidata(hObject,handles)

% %recur!
% if isfield(instruction,'reset') && instruction.reset
%     start_Callback(hObject, eventdata, handles)
% end




% function vname_string = vname(var)
% 
% vname_string = inputname(1);
            
            
            
            
            
            
            


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


if isfield(handles,'sock_out') && handles.sock_out > 0
    disp('closing socket out')
    msclose(handles.sock_out)
    handles = rmfield(handles,'sock_out');
    guidata(hObject,handles)
else
    disp('no socket')
end

set(handles.socket_status,'String','Socket: Closed')

% function [return_info, success, handles] = do_instruction(instruction, handles)
% 
% instruction.close_socket = 1;
% % if instruction.type == 21
% %     handles.sock
% % end
% if ~isfield(handles,'sock_out')
%     disp('opening socket...')
%     srvsock = mslisten(handles.client_port);
% %     handles.sock = -1;
%     handles.sock_out = msaccept(srvsock);
%     disp('socket open..')
%     msclose(srvsock);
% end
% % if isfield(handles,'close_socket')
% %     instruction.close_socket = get(handles.close_socket_check,'Value');
% % else
% %     instruction.close_socket = 1;
% % end
% if isfield(instruction,'get_return')
%     get_return = instruction.get_return;
% else
%     get_return = 1;
% end
% pause(.1)
% disp('sending instruction...')
% mssend(handles.sock_out,instruction);
% if get_return
%     disp('getting return info...')
%     pause(.1)
%     return_info = [];
%     while isempty(return_info)
%         [return_info, success] = msrecv(handles.sock_out,5);
%     end
%     assignin('base','return_info',return_info)
% else
%     return_info = [];
% end
% % success = 1;
% 
% if instruction.close_socket
%     disp('closing socket')
%     msclose(handles.sock_out)
%     handles = rmfield(handles,'sock_out');
% end
