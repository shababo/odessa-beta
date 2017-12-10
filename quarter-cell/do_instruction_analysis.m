function [return_info, success, handles] = ...
    do_instruction_analysis(instruction, handles)

instruction.close_socket = get(handles.close_socket_check,'Value');

if ~isfield(handles,'sock_analysis')
    disp('opening socket...')
    srvsock = mslisten(3001);
    handles.sock_analysis = msaccept(srvsock);
    disp('socket open..')
    msclose(srvsock);
    guidata(handles.close_socket_check,handles)
end
% if isfield(handles,'close_socket')

%     instruction.close_socket = get(handles.close_socket_check,'Value');

% else
%     instruction.close_socket = 1;
% end
pause(1)
disp('sending instruction...')
instruction.type
mssend(handles.sock_analysis,instruction);

pause(1)
return_info = [];
if isfield(instruction,'get_return')
    get_return = instruction.get_return;
else
    get_return = 1;
end
if get_return
    disp('getting return info...')
    pause(1)
    while isempty(return_info)
        [return_info, success] = msrecv(handles.sock_analysis,5);
    end
%     assignin('base','return_info',return_info)
end
success = 1;

if instruction.close_socket
    disp('closing socket')
    msclose(handles.sock_analysis)
    handles = rmfield(handles,'sock_analysis');
end