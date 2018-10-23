function [experiment_setup, handles] = get_cell_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup)

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
    user_confirm = msgbox('Piezo peroper aligned with cell?');
    waitfor(user_confirm)
    
    answer = inputdlg('What is piezo z depth for cell in um?');
    experiment_setup.cell_z = str2num(answer{1});
% 
%     set_cell1_pos_Callback(handles.set_cell1_pos,eventdata,handles);
    disp('click targets...')
    instruction.type = 73;
    instruction.num_targs = 1;
    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
    experiment_setup.new_cell_pos = [return_info.nuclear_locs(1:2) experiment_setup.cell_z];
    experiment_setup.new_cell_pos_image_coord = [return_info.nuclear_locs_image_coord(1:2) experiment_setup.cell_z/2];
    experiment_setup.new_snap_image = return_info.snap_image;
    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
    handles.data.experiment_setup = experiment_setup;
    exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
end