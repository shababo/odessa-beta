function [experiment_setup, handles] = test_connection_optical(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup)

handles.data.start_trial = acq_gui_data.data.sweep_counter + 1;

set_pos = 1;

choice = questdlg('Set position of cell?', ...
    'Set position of cell?', ...
	'yes','no','yes');
% Handle response
switch choice
    case 'yes'
        set_pos = 1;
    case 'no'
        set_pos = 0;
end

if set_pos
%     wrndlg = warndlg('Set 0 position by going to top of slice with piezo = 0');
%     waitfor(wrndlg)

    [experiment_setup, handles] = get_cell_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;
    if experiment_setup.ch1_pre


        experiment_setup.cell1_pos = experiment_setup.new_cell_pos;
        experiment_setup.cell1_pos_image_coord = experiment_setup.new_cell_pos_image_coord;
        experiment_setup.cell1_snap_image = experiment_setup.new_snap_image;
        experiment_setup.presyn_cell_pos = experiment_setup.cell1_pos;

    elseif experiment_setup.ch2_pre

        experiment_setup.cell2_pos = experiment_setup.new_cell_pos;
        experiment_setup.cell2_pos_image_coord = experiment_setup.new_cell_pos_image_coord;
        experiment_setup.cell2_snap_image = experiment_setup.new_snap_image;
        experiment_setup.presyn_cell_pos = experiment_setup.cell2_pos;

    end
end

targs_offset = [0 0 0
                12 0 0
                -12 0 0
                0 8 0
                0 -8 0];

all_targets = bsxfun(@plus,targs_offset,experiment_setup.presyn_cell_pos);


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

wrndlg = warndlg('Both cells in VC and ready to go?');
waitfor(wrndlg)
set(acq_gui_data.Cell1_type_popup,'Value',1)
set(acq_gui_data.Cell2_type_popup,'Value',1)

init_powers = '15 25 40 60'; 
set(handles.target_intensity,'String',init_powers)
set(handles.num_repeats,'String',num2str(3));
set(handles.tf_flag,'Value',1)
set(handles.set_seq_trigger,'Value',1)
set(handles.num_stim,'String',num2str(size(instruction.targets,1)));
set(handles.rand_order,'Value',1);
set(handles.duration,'String',num2str(.003));
set(handles.iti,'String',num2str(0.5));

handles.data.piezo_z = all_targets(:,3);
handles.data.piezo_z_multiply = 0;

[handles, acq_gui, acq_gui_data] = socket_control_tester('build_seq_Callback',handles.build_seq,eventdata,handles);

% set acq params
set(acq_gui_data.run,'String','Prepping...')
set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String','1') 

% run trial
acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
waitfor(acq_gui_data.run,'String','Start')
[acq_gui, acq_gui_data] = get_acq_gui_data;

guidata(acq_gui, acq_gui_data);
guidata(hObject,handles)
handles.data.experiment_setup = experiment_setup;
exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')    

% plot data
trials = handles.data.start_trial:acq_gui_data.data.sweep_counter;
[traces_ch1, traces_ch2] = get_traces(acq_gui_data.data,trials,experiment_setup.trials.Fs,experiment_setup.trials.max_time_sec);
    

if experiment_setup.ch1_pre
    pre_traces = traces_ch1;
    post_traces = traces_ch2;
    titlestr = 'CH 1 -> CH 2';
elseif experiment_setup.ch2_pre
    pre_traces = traces_ch2;
    post_traces = traces_ch1;
    titlestr = 'CH 2 -> CH 1';
end

experiment_setup.datafig = figure;
plot_trace_stack([mean(pre_traces,1); pre_traces],50,'-c')
hold on
plot_trace_stack([mean(post_traces,1); post_traces],50,'-k')
title(titlestr)






    


