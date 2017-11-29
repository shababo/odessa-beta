function [return_info, success, handles] = do_instruction_slidebook(instruction, handles)

instruction.close_socket = get(handles.close_socket_check,'Value');
% if instruction.type == 21
%     handles.sock
% end

% if ~isfield(instruction,'portnum')
%     instruction.portnum = 3000;
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
instruction.type
mssend(handles.sock,instruction);

pause(.1)
return_info = [];
if isfield(instruction,'get_return')
    get_return = instruction.get_return;
else
    get_return = 1;
end
if get_return
    disp('getting return info...')
    while isempty(return_info)
        [return_info, success] = msrecv(handles.sock,1);
    end
    assignin('base','return_info',return_info)
end
success = 1;

if instruction.close_socket
    disp('closing socket')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
end