% --- Executes on button press in obj_go_to.
function [handles,acq_gui,acq_gui_data] = obj_go_to(handles,hObject)
% hObject    handle to obj_go_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('moving obj')
instruction.type = 60; %MOVE_OBJ
instruction.theNewX = handles.data.obj_go_to_pos(1);
instruction.theNewY = handles.data.obj_go_to_pos(2);
instruction.theNewZ = handles.data.obj_go_to_pos(3);

disp('sending instruction...')
[return_info,success,handles] = do_instruction_slidebook(instruction,handles) ;
guidata(hObject,handles)

% disp('operation done, setting fields...')
% set(handles.currX,'String',num2str(return_info.currX));
% set(handles.currY,'String',num2str(return_info.currY));
% set(handles.currZ,'String',num2str(return_info.currZ));

disp('sending to acq gui')
acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);
acq_gui_data.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
handles.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
% acq_gui_data.success = 1;

guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)