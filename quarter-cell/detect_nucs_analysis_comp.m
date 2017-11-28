function [handles, neurons] = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,experiment_setup)

% THIS FUNCTION DOES NOT SUBSCRIBE TO NEW DATA STRUCTURES YET

detect_nucs = 1;
if experiment_setup.enable_user_breaks
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
                    experiment_setup.enable_user_breaks = 1;
                case 'No'
                    experiment_setup.enable_user_breaks = 0;
            end
        case 'No'
            detect_nucs = 0;
    end
end

if detect_nucs
    disp('detecting nuclei...')
    instruction = struct();
    instruction.type = 75;

    instruction.filename = [experiment_setup.exp_id '_stack'];
%     instruction.stackmat = experiment_setup.stack;
%     imagemat = handles.data.stack;
%     save(['C:\data\Shababo\' handles.data.experiment_setup.map_id '.mat'],'imagemat')
%     pause(5)
%     copyfile(['C:\data\Shababo\' handles.data.experiment_setup.map_id '.mat'], ['X:\shababo\' handles.data.experiment_setup.map_id '.mat']);
%     pause(5)
    
%     instruction.stackmat = 0;
%     instruction.image_zero_order_coord = experiment_setup.image_zero_order_coord;
%     instruction.image_um_per_px = experiment_setup.image_um_per_px;
%     instruction.stack_um_per_slice = experiment_setup.stack_um_per_slice;
    instruction.make_neurons_struct = 1;
    instruction.experiment_setup = experiment_setup;
    instruction.dummy_targs = 1;
    instruction.num_dummy_targs = 200;
    
    [return_info,success,handles] = do_instruction_analysis(instruction,handles);

%     acq_gui_data.data.nuclear_locs = return_info.nuclear_locs;
%     acq_gui_data.data.fluor_vals = return_info.fluor_vals;
    handles.data.nuclear_locs = return_info.nuclear_locs;
    handles.data.fluor_vals = return_info.fluor_vals;
    neurons = return_info.neurons;
%     handles.data.experiment_setup = experiment_setup;

    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
    exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')
%     assignin('base','nuclear_locs_w_cells',handles.data.nuclear_locs)
end