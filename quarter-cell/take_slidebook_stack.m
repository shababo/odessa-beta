function handles = take_slidebook_stack(hObject,handles,acq_gui,acq_gui_data,params)

take_new_stack = 1;
if handles.data.enable_user_breaks
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
                    handles.data.enable_user_breaks = 1;
                case 'No'
                    handles.data.enable_user_breaks = 0;
            end
        case 'No'
            take_new_stack = 0;
    end
end

if take_new_stack
    disp('take stack')
    instruction = struct();
    instruction.type = 92;
    
    instruction.filename = [handles.data.params.map_id '_stack'];
    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
    acq_gui_data.data.stack = return_info.image;
    acq_gui_data.data.image_zero_order_coord = return_info.image_zero_order_coord;
    acq_gui_data.data.image_um_per_px = return_info.image_um_per_px;
    acq_gui_data.data.stack_um_per_slice = return_info.stack_um_per_slice;     
    handles.data.image_zero_order_coord = return_info.image_zero_order_coord;
    handles.data.image_um_per_px = return_info.image_um_per_px;
    handles.data.stack_um_per_slice = return_info.stack_um_per_slice;     
%     handles.data.stack = return_info.image;
    
    guidata(hObject,handles);
    guidata(acq_gui, acq_gui_data);
    exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
end
