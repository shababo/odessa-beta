function handles = set_new_ref_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup)

take_new_ref = 0;
choice = questdlg('Set Reference Position for Objective/SLM Zero-Order?',...
	'Set Reference Position for Objective/SLM Zero-Order?', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        take_new_ref = 1;
    case 'No'
        take_new_ref = 0;
end

if take_new_ref
    
%     handles = update_obj_pos_Callback(hObject, eventdata, handles);
    handles = ...
        socket_control_tester('update_obj_pos_Callback',hObject,eventdata,handles);
    acq_gui_data.data.ref_obj_position = handles.data.obj_position;
    handles.data.ref_obj_position = handles.data.obj_position;
    guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)
    exp_data = handles.data; save(experiment_setup.fullsavefile,'exp_data')
end