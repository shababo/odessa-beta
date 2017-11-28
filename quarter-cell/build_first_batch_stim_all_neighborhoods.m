function [experiment_query, neighbourhoods] = build_first_batch_stim_all_neighborhoods(experiment_setup,neighbourhoods,varargin)

if ~isempty(varargin) && ~isempty(varargin{1})
    handles = varargin{1};
    hObject = varargin{2};
else
    handles = [];
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
    
    if ~experiment_setup.is_exp && ~experiment_setup.sim.do_instructions
        for i = 1:length(neighbourhoods)
            [experiment_query(i,1), neighbourhoods(i)] = run_online_pipeline(neighbourhoods(i),...
                empty_design(neighbourhoods(i),experiment_setup.groups.(experiment_setup.default_group)),...
                experiment_setup);
        end
    else
        instruction.type = 300; 
%         instruction.experiment_query = struct();
        for i = 1:length(neighbourhoods)
            instruction.experiment_query(i) = ...
                empty_design(neighbourhoods(i),experiment_setup.groups.(experiment_setup.default_group));
        end
        instruction.neighbourhoods = neighbourhoods;
        instruction.get_return = 0;
        instruction.experiment_setup = experiment_setup;
        
        if experiment_setup.is_exp
            [return_info, success, handles] = do_instruction_analysis(instruction, handles);
            guidata(hObject,handles)
        else
            [return_info, success] = do_instruction_local(instruction);
        end
        experiment_query = [];

    end
    
end

