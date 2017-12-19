function handles = init_first_batches_from_stack(hObject,handles,acq_gui,acq_gui_data,experiment_setup)

% THIS FUNCTION DOES NOT SUBSCRIBE TO NEW DATA STRUCTURES YET

init_batches = 1;
if experiment_setup.enable_user_breaks
    choice = questdlg('Detect nucs and init hoods and first batches?', ...
        'Detect nucs and init hoods and first batches?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            init_batches = 1;
            choice = questdlg('Continue user control?',...
                'Continue user control?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    experiment_setup.enable_user_breaks = 1;
                case 'No'
                    experiment_setup.enable_user_breaks = 0;
            end
        case 'No'
            init_batches = 0;
    end
end

if init_batches
    disp('sending stack for nuc detection, n''hood creating, and first batch creation...')
    instruction = struct();
    instruction.type = 500;

    instruction.filename = [experiment_setup.exp_id '_stack'];
    instruction.experiment_setup = experiment_setup;
    instruction.dummy_targs = experiment_setup.exp.sim_locs;
    instruction.get_return = 0;
    [return_info,success,handles] = do_instruction_analysis(instruction,handles);

    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
%     handles.data.experiment_setup = experiment_setup;
%     exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
%     assignin('base','nuclear_locs_w_cells',handles.data.nuclear_locs)
end