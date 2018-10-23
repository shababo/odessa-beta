function [experiment_setup, handles] = test_connection_ephys(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup)

if experiment_setup.ch1_pre
    
    handles.data.start_trial = acq_gui_data.data.sweep_counter + 1;
    
    user_confirm = msgbox('Cell 1 in CC and Cell 2 in VC?');
    waitfor(user_confirm)
    
    set(acq_gui_data.Cell1_type_popup,'Value',2)
    set(acq_gui_data.Cell2_type_popup,'Value',1)
    
    acq_gui_data = Acq('connection_1to2_Callback',acq_gui_data.connection_1to2,eventdata,acq_gui_data);
    
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.trigger_seq,'Value',0)
    set(acq_gui_data.loop_count,'String',num2str(1)) 
%     set(acq_gui_data.loop_count,'String',num2str(experiment_setup.num_connection_test_reps)) 

    for run_i = 1:experiment_setup.num_connection_test_reps
        % run trial
        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    end
%     [acq_gui, acq_gui_data] = get_acq_gui_data;
            
%     guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)
    handles.data.experiment_setup = experiment_setup;
    exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
    
    set(acq_gui_data.ccpulseamp1,'String','0');
    acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
    acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
    
    % plot data
    trials = handles.data.start_trial:acq_gui_data.data.sweep_counter;
    traces_ch1 = acq_gui_data.data.sweeps{handles.data.start_trial}(:,1)';
    traces_ch2 = acq_gui_data.data.sweeps{handles.data.start_trial}(:,2)';
    for trial_ind = trials(2:end)
        traces_ch1 = [traces_ch1; acq_gui_data.data.sweeps{trial_ind}(:,1)'];
        traces_ch2 = [traces_ch2; acq_gui_data.data.sweeps{trial_ind}(:,2)'];
    end
    experiment_setup.datafig = figure;
    plot_trace_stack([mean(traces_ch1,1); traces_ch1],50,'-c')
    hold on
    plot_trace_stack([mean(traces_ch2,1); traces_ch2],50,'-k')
    title('CH 1 -> CH 2')
    
end

if experiment_setup.ch2_pre
    
    handles.data.start_trial = acq_gui_data.data.sweep_counter + 1;
    
    user_confirm = msgbox('Cell 1 in VC and Cell 2 in CC?');
    waitfor(user_confirm)
    
    set(acq_gui_data.Cell1_type_popup,'Value',1)
    set(acq_gui_data.Cell2_type_popup,'Value',2)
    
    acq_gui_data = Acq('connection_2to1_Callback',acq_gui_data.connection_1to2,eventdata,acq_gui_data);
    
    % set acq params
    set(acq_gui_data.run,'String','Prepping...')
    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.trigger_seq,'Value',0)
%     set(acq_gui_data.loop_count,'String',num2str(experiment_setup.num_connection_test_reps)) 
    set(acq_gui_data.loop_count,'String',num2str(1)) 
    % run trial
    for run_i = 1:experiment_setup.num_connection_test_reps
        acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
    end
%     waitfor(acq_gui_data.run,'String','Start')
    [acq_gui, acq_gui_data] = get_acq_gui_data;
            
    guidata(acq_gui, acq_gui_data);
    guidata(hObject,handles)
    handles.data.experiment_setup = experiment_setup;
    exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
    
    set(acq_gui_data.ccpulseamp2,'String','0');
    acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
    acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
    
    % plot data
    trials = handles.data.start_trial:acq_gui_data.data.sweep_counter;
    traces_ch1 = acq_gui_data.data.sweeps{handles.data.start_trial}(:,1)';
    traces_ch2 = acq_gui_data.data.sweeps{handles.data.start_trial}(:,2)';
    for trial_ind = trials(2:end)
        traces_ch1 = [traces_ch1; acq_gui_data.data.sweeps{trial_ind}(:,1)'];
        traces_ch2 = [traces_ch2; acq_gui_data.data.sweeps{trial_ind}(:,2)'];
    end

    experiment_setup.datafig = figure;
    plot_trace_stack([mean(traces_ch2,1); traces_ch2],50,'-c')
    hold on
    plot_trace_stack([mean(traces_ch1,1); traces_ch1],50,'-k')
    title('CH 2 -> CH 1')
    
end


