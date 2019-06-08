function click_mapping(experiment_setup,varargin)

disp('Experiment start...')


        
handles = varargin{1};
hObject = varargin{2};

set(handles.close_socket_check,'Value',0)
guidata(hObject,handles);


[acq_gui, acq_gui_data] = get_acq_gui_data;
figure(acq_gui)

eventdata = [];
disp('Get objective ref position...')
[experiment_setup, handles] = set_new_ref_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
[acq_gui, acq_gui_data] = get_acq_gui_data;

disp('click targets...')
instruction.type = 73;
instruction.num_targs = 0;
[return_info,success,handles] = do_instruction_slidebook(instruction,handles);
experiment_setup.targets = return_info.nuclear_locs;
acq_gui_data.data.nuclear_locs = experiment_setup.targets;
handles.data.nuclear_locs = experiment_setup.targets;
acq_gui_data.data.snap_image = return_info.snap_image;
guidata(acq_gui,acq_gui_data)
guidata(hObject,handles)

all_targets = experiment_setup.targets;
all_targets(all_targets(:,1) < -148,1) = -148;
all_targets(all_targets(:,1) > 148,1) = 148;
all_targets(all_targets(:,2) < -148,2) = -148;
all_targets(all_targets(:,2) > 148,2) = 148;
all_targets(all_targets(:,3) < 1,3) = 1;
all_targets(all_targets(:,3) > 398,3) = 398;
experiment_setup.all_targets = all_targets;

% compute pockels refs
clear instruction
instruction.type = 86;
instruction.targets = experiment_setup.all_targets;
instruction.build_pockels_ref = 1;
instruction.make_phase_masks = 1;
instruction.get_return = 1;
disp('sending instruction...')
[return_info,success,handles] = do_instruction_slidebook(instruction,handles);


set(acq_gui_data.Cell1_type_popup,'Value',1)
set(acq_gui_data.Cell2_type_popup,'Value',1)

init_powers = '15 40 75'; 
set(handles.target_intensity,'String',init_powers)
set(handles.num_repeats,'String',num2str(20));
set(handles.tf_flag,'Value',1)
set(handles.set_seq_trigger,'Value',1)
set(handles.num_stim,'String',num2str(size(instruction.targets,1)));
set(handles.rand_order,'Value',1);
set(handles.duration,'String',num2str(.010));
set(handles.iti,'String',num2str(2.0));

handles.data.piezo_z = all_targets(:,3);
handles.data.piezo_z_multiply = 0;

[handles, acq_gui, acq_gui_data] = socket_control_tester('build_seq_Callback',handles.build_seq,eventdata,handles);

% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String','1') 


wrndlg = warndlg('Imaging Ready To Go??');
waitfor(wrndlg)

% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
[acq_gui, acq_gui_data] = get_acq_gui_data;

guidata(acq_gui, acq_gui_data);
guidata(hObject,handles)
handles.data.experiment_setup = experiment_setup;
exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')    

handles.data.experiment_setup = experiment_setup;
exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')

if strcmp(experiment_setup.experiment_type,'experiment')
    set(handles.close_socket_check,'Value',1);
    instruction.type = 00;
    instruction.string = 'done';
    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
    guidata(hObject,handles)
end
