function [handles, experiment_setup] = set_cell1_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup)

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
    
    answer = inputdlg('What is piezo z depth for cell in um?');
    experiment_setup.cell_z = str2num(answer{1});
% 
%     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    disp('click targets...')
    instruction.type = 73;
    instruction.num_targs = 1;
    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
    [acq_gui, acq_gui_data] = get_acq_gui_data();
    handles.data.cell1_pos = [return_info.nuclear_locs(1:2) experiment_setup.cell_z];
    handles.data.cell1_pos_image = [return_info.nuclear_locs_image_coord(1:2) experiment_setup.cell_z/2];
    acq_gui_data.data.cell1_snap_image = return_info.snap_image;
    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
    exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
end