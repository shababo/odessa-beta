function [experiment_setup, handles] = get_obj_position(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup)

disp('Getting current obj pos...')

instruction.type = 20; %GET_OBJ_POS
instruction.close_socket = get(handles.close_socket_check,'Value');
[return_info,success,handles] = do_instruction_slidebook(instruction,handles);

guidata(hObject,handles)
acq_gui_data.data.obj_position = [return_info.currX return_info.currY return_info.currZ];

handles.data.obj_position = [return_info.currX return_info.currY return_info.currZ];
experiment_setup.exp.obj_position = [return_info.currX return_info.currY return_info.currZ];

guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)