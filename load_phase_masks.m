function [experiment_query, neighbourhood] = load_phase_masks(experiment_setup,neighbourhood,handles,varargin)

if ~isempty(varargin) && ~isempty(varargin{1})
    user_finish = varargin{1};
else
    user_finish = 1;
end
send_phase_masks = 1;
if experiment_setup.enable_user_breaks
    choice = questdlg('Send phase masks?', ...
        'Send phase masks?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            send_phase_masks = 1;
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
            send_phase_masks = 0;
    end
end
if send_phase_masks
    disp('sending phase masks')
    instruction = struct();
    instruction.type = 85;
    instruction.user_finish = user_finish;
    instruction.filename = [experiment_setup.exp_id ...
            '_n' num2str(neighbourhood.neighbourhood_ID)...
            '_b' num2str(neighbourhood.batch_ID + 1) '_to_acquisition.mat'];
%                 instruction.precomputed_target = experiment_query.phase_masks;
    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
    if ~return_info.bad_file
        neighbourhood = return_info.neighbourhood;
        experiment_query = return_info.experiment_query;
    else
        neighbourhood = [];
        experiment_query = [];
        
        filename = [experiment_setup.phase_mask_dir experiment_setup.exp_id ...
            '_n' num2str(neighbourhood.neighbourhood_ID)...
            '_b' num2str(neighbourhood.batch_ID + 1) '_to_acquisition.mat'];
        delete(filename)
        filename = [experiment_setup.phase_mask_dir experiment_setup.exp_id ...
            '_n' num2str(neighbourhood.neighbourhood_ID)...
            '_b' num2str(neighbourhood.batch_ID + 1) '_batch_ready.mat'];
        delete(filename)
        instruction.type = 300; 
        instruction.dont_write = 1;
        instruction.neighbourhoods = neighbourhood;
        instruction.get_return = 0;
        instruction.experiment_setup = experiment_setup;
        
        if experiment_setup.is_exp
            [return_info, success, handles] = do_instruction_analysis(instruction, handles);
        else
            [return_info, success] = do_instruction_local(instruction);
        end
        
    end
end