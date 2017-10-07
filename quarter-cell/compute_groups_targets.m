function handles = compute_groups_targets(hObject,handles,acq_gui,acq_gui_data,params)

do_cells_targets = 1;
if handles.data.enable_user_breaks
    choice = questdlg('Compute Cell Groups and Optimal Targets?', ...
        'Detect Nuclei?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            do_cells_targets = 1;
            choice = questdlg('Continue user control?',...
                'Continue user control?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    handles.data.enable_user_breaks = 1;
                case 'No'
                    handles.data.enable_user_breaks = 0;
            end
        case 'No'
            do_cells_targets = 0;
    end
end


if do_cells_targets
    disp('computing optimal locations and cell groups...')
    % instruction.type = 76;
    % instruction.nuclear_locs = handles.data.nuclear_locs;
    % instruction.z_locs = handles.data.z_offsets;
    % instruction.z_slice_width = handles.data.params.exp.z_slice_width;
    % 
    % [return_info,success,handles] = do_instruction_analysis(instruction,handles);
    % handles.data.cells_targets = return_info.cells_targets;

    % z_slice_width = 30;
    handles.data.cells_targets = get_groups_and_stim_locs(...
                    handles.data.nuclear_locs(:,1:3), handles.data.params,...
                    handles.data.z_offsets);

    acq_gui_data.data.cells_targets = handles.data.cells_targets;

    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
    exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
end