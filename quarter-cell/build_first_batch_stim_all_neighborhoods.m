function handles = build_first_batch_stim_all_neighborhoods(hObject,handles,acq_gui,acq_gui_data,params)

build_first_batch_stim = 1;
if handles.data.enable_user_breaks
    choice = questdlg('Build stim and phase masks for first batch?', ...
        'Build stim and phase masks for first batch?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            build_first_batch_stim = 1;
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
            build_first_batch_stim = 0;
    end
end


if build_first_batch_stim
    
    
    instruction.type = 300; 
    instruction.experiment_query = struct();
    for i = 1:length(handles.data.neighbourhoods)
        instruction.experiment_query(i) = empty_design(handles.data.neighbourhoods(i));
    end
    instruction.neighbourhoods = handles.data.neighbourhoods;
    instruction.get_return = 0;
    instruction.exp_id = handles.data.experiment_setup.exp_id;
    [return_info, success, handles] = do_instruction_analysis(instruction, handles);
    
end