function handles = build_first_batch_stim_all_neighborhoods(experiment_setup,varargin)

if ~isempty(varargin) && ~isempty(varargin{1})
    handles = varargin{1};
end

build_first_batch_stim = 1;
if experiment_setup.enable_user_breaks
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
                    experiment_setup.enable_user_breaks = 1;
                case 'No'
                    experiment_setup.enable_user_breaks = 0;
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
    instruction.exp_id = experiment_setup.exp_id;
    if experiment_setup.is_exp
        [return_info, success, handles] = do_instruction_analysis(instruction, handles);
    else
        [return_info, success, handles] = do_instruction_local(instruction);
    end
    
end