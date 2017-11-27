function [handles, experiment_setup] = take_slidebook_stack(hObject,handles,acq_gui,acq_gui_data,experiment_setup)

take_new_stack = 1;
if experiment_setup.enable_user_breaks
    choice = questdlg('Take a stack?', ...
        'Take a stack?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            take_new_stack = 1;
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
            take_new_stack = 0;
    end
end

if take_new_stack
    
    disp('take stack')
    instruction = struct();
    instruction.type = 92;
    
    instruction.filename = [experiment_setup.exp_id '_stack'];
    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
    experiment_setup.stack = return_info.image;
    if isfield(return_info,'image_zero_order_coord')
        acq_gui_data.data.image_zero_order_coord = return_info.image_zero_order_coord;
        acq_gui_data.data.image_um_per_px = return_info.image_um_per_px;
        acq_gui_data.data.stack_um_per_slice = return_info.stack_um_per_slice;     
        handles.data.image_zero_order_coord = return_info.image_zero_order_coord;
        handles.data.image_um_per_px = return_info.image_um_per_px;
        handles.data.stack_um_per_slice = return_info.stack_um_per_slice; 
    end
%     handles.data.stack = return_info.image;
    
    guidata(hObject,handles);
    guidata(acq_gui, acq_gui_data);
    handles.data.experiment_setup = experiment_setup;
    exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
    
end
