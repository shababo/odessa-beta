function [handles,experiment_setup] = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,experiment_setup)

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
    instruction.make_neurons_struct = 0;
    instruction.experiment_setup = experiment_setup;
    instruction.dummy_targs = 0;
    if instruction.dummy_targs
        dummy_targs = 1;
        choice = questdlg('Are you sure you want to use simulated cell locations?', ...
            'Are you sure you want to use simulated cell locations?', ...
            'yes','no','no');
        % Handle response
        switch choice
            case 'yes'
                dummy_targs = 1;
            case 'no'
                dummy_targs = 0;
        end
        instruction.dummy_targs = dummy_targs;
    end
    instruction.num_dummy_targs = 600;
    instruction.get_return = 1;
    instruction.z_stack_offset = experiment_setup.z_stack_offset;
    [return_info,success,handles] = do_instruction_analysis(instruction,handles);

%     acq_gui_data.data.nuclear_locs = return_info.nuclear_locs;
%     acq_gui_data.data.fluor_vals = return_info.fluor_vals;
    experiment_setup.nuclear_locs_image_coord = return_info.nuclear_locs_image_coord;
    experiment_setup.nuclear_locs = return_info.nuclear_locs;
    experiment_setup.fluor_vals = return_info.fluor_vals;
    if instruction.make_neurons_struct
        experiment_setup.neurons = neurons;
    end
%     handles.data.experiment_setup = experiment_setup;

%     guidata(acq_gui,acq_gui_data)
%     guidata(hObject,handles)
%     handles.data.experiment_setup = experiment_setup;
%     exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
%     assignin('base','nuclear_locs_w_cells',handles.data.nuclear_locs)
end