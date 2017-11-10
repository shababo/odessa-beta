function handles = create_neighbourhoods_caller(hObject,handles,acq_gui,acq_gui_data,experiment_setup)

do_build_neighbourhooods = 1;
if experiment_setup.enable_user_breaks
    choice = questdlg('Compute Cell Groups and Optimal Targets?', ...
        'Compute Cell Groups and Optimal Targets?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            do_build_neighbourhooods = 1;
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
            do_build_neighbourhooods = 0;
    end
end


if do_build_neighbourhooods
    disp('computing optimal locations and cell groups...')
    % instruction.type = 76;
    % instruction.nuclear_locs = handles.data.nuclear_locs;
    % instruction.z_locs = handles.data.z_offsets;
    % instruction.z_slice_width = handles.data.experiment_setup.exp.z_slice_width;
    % 
    % [return_info,success,handles] = do_instruction_analysis(instruction,handles);
    % handles.data.cells_targets = return_info.cells_targets;

    % z_slice_width = 30;
    handles.data.neighbourhoods = create_neighbourhoods(experiment_setup);

    acq_gui_data.data.neighbourhoods = handles.data.neighbourhoods;

    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
    exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')
end