function handles = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,params)

detect_nucs = 1;
if handles.data.enable_user_breaks
    choice = questdlg('Detect Nuclei?', ...
        'Detect Nuclei?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            detect_nucs = 1;
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
            detect_nucs = 0;
    end
end

if detect_nucs
    disp('detecting nuclei...')
    instruction = struct();
    instruction.type = 75;

    instruction.filename = [handles.data.params.map_id '_stack'];
    instruction.stackmat = acq_gui_data.data.stack;
%     imagemat = handles.data.stack;
%     save(['C:\data\Shababo\' handles.data.params.map_id '.mat'],'imagemat')
%     pause(5)
%     copyfile(['C:\data\Shababo\' handles.data.params.map_id '.mat'], ['X:\shababo\' handles.data.params.map_id '.mat']);
%     pause(5)
    
%     instruction.stackmat = 0;
    instruction.image_zero_order_coord = handles.data.image_zero_order_coord;
    instruction.image_um_per_px = handles.data.image_um_per_px;
    instruction.stack_um_per_slice = handles.data.stack_um_per_slice;
    
    instruction.dummy_targs = 1;
    instruction.num_dummy_targs = 200;
    
    [return_info,success,handles] = do_instruction_analysis(instruction,handles);

    acq_gui_data.data.nuclear_locs = return_info.nuclear_locs;
    acq_gui_data.data.fluor_vals = return_info.fluor_vals;
    handles.data.nuclear_locs = return_info.nuclear_locs;
    handles.data.fluor_vals = return_info.fluor_vals;

    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
    exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
%     assignin('base','nuclear_locs_w_cells',handles.data.nuclear_locs)
end