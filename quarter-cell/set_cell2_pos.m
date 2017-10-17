function handles = set_cell2_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,params)

handles.data.set_cell2_pos = 0;
choice = questdlg('Set Patched Cell 2 Pos?', ...
	'Set Cell Pos?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        handles.data.set_cell2_pos = 1;
    case 'No'
        handles.data.set_cell2_pos = 0;
end

if handles.data.set_cell2_pos
    
    % confirm everything ready
    user_confirm = msgbox('Z-plane aligned with patched cell 2?');
    waitfor(user_confirm)
% 
%     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    disp('click targets...')
    instruction.type = 73;
    instruction.num_targs = 1;
    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    handles.data.click_targ = return_info.nuclear_locs(1:2);
    acq_gui_data.data.cell2_snap_image = return_info.snap_image;
    guidata(acq_gui,acq_gui_data)
    
%     handles = update_obj_pos_Callback(handles.update_obj_pos, eventdata, handles);
    handles = ...
        socket_control_tester('update_obj_pos_Callback',hObject,eventdata,handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    
    handles.data.cell2_pos = [handles.data.click_targ handles.data.obj_position(3)] - ...
        [0 0 handles.data.ref_obj_position(3)];
    acq_gui_data.data.cell2_pos = handles.data.obj_position + [handles.data.click_targ 0];
%     acq_gui_data.data.ref_obj_pos = handles.data.ref_obj_position;
    
    set(acq_gui_data.cell2_x,'String',num2str(acq_gui_data.data.cell_pos(1)));
    set(acq_gui_data.cell2_y,'String',num2str(acq_gui_data.data.cell_pos(2)));
    set(acq_gui_data.cell2_z,'String',num2str(acq_gui_data.data.cell_pos(3)));
    
    guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)
    exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
end