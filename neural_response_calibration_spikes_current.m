function neural_response_calibration_spikes_current(experiment_setup,varargin)

disp('Experiment start...')

switch experiment_setup.experiment_type
    case 'pilot'
        
    case 'experiment'
        
        handles = varargin{1};
        hObject = varargin{2};
           
        set(handles.close_socket_check,'Value',0)
        guidata(hObject,handles);

        [acq_gui, acq_gui_data] = get_acq_gui_data;
        figure(acq_gui)
        
%         wrndlg = warndlg('Go to patched cell with piezo = 120 and then set the piezeo to 0um.');
%         waitfor(wrndlg)
%         
%         wrndlg = warndlg('Confirm that acquireImageCaptureSettingName is 70_170_2 on Slidebook computer.');
%         waitfor(wrndlg)
%         
%         experiment_setup.cell_z = 50;
        
        wrndlg = warndlg('Set 0 position by going to top of slice with piezo = 0');
        waitfor(wrndlg)
        
        wrndlg = warndlg('Confirm that acquireImageCaptureSettingName is 0_130_2 on Slidebook computer.');
        waitfor(wrndlg) 

        answer = inputdlg('What is piezo z depth for cell in um?');
        experiment_setup.cell_z = str2num(answer{1});

        eventdata = [];
        disp('Get objective ref position...')
        [experiment_setup, handles] = set_new_ref_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
        [acq_gui, acq_gui_data] = get_acq_gui_data;
        
        
        disp('Start bg recording')
        wrndlg = warndlg('Cell attached recording ready? Both cells?');
        waitfor(wrndlg)
        
        
        set(acq_gui_data.test_pulse,'Value',1)
        set(acq_gui_data.loop,'Value',1)
        set(acq_gui_data.trigger_seq,'Value',0)
        set(acq_gui_data.loop_count,'String',num2str(1))
        set(acq_gui_data.trial_length,'String',num2str(experiment_setup.stack_duration))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        pause(1.0)
        
        disp('Take stack...')
        [handles, experiment_setup] = take_slidebook_stack(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
%         [acq_gui, acq_gui_data] = get_acq_gui_data;

        disp('Detect nuclei...')
        experiment_setup.z_stack_offset = 0;
        [handles, experiment_setup] = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
        guidata(hObject,handles)
        
        disp('Interactive patched cell selection...')
        stack_viewer_fig = stack_viewer(experiment_setup.stack,{experiment_setup.nuclear_locs_image_coord},...
            {experiment_setup.fluor_vals'},ceil((experiment_setup.cell_z - experiment_setup.z_stack_offset)/experiment_setup.stack_um_per_slice),experiment_setup.stack_ch2,handles,hObject);
        waitfor(stack_viewer_fig)
        
        handles = guidata(hObject);
        assignin('base','stack_viewer_out',handles.data.stack_viewer_output)
        experiment_setup.patched_cell_pos = handles.data.stack_viewer_output.selected_cell_pos;
        experiment_setup.select_cell_index_full = handles.data.stack_viewer_output.selected_cell_index_full;
%         experiment_setup.patched_cell_pos_2 = handles.data.stack_viewer_output.selected_cell_pos_2;
%         experiment_setup.select_cell_index_full_2 = handles.data.stack_viewer_output.selected_cell_index_full_2;
        experiment_setup.fluor_thresh = handles.data.stack_viewer_output.fluor_thresh;
        experiment_setup.patched_cell_loc = experiment_setup.nuclear_locs(handles.data.stack_viewer_output.selected_cell_index_full,:);
        experiment_setup.patched_cell_fluor = experiment_setup.fluor_vals(handles.data.stack_viewer_output.selected_cell_index_full);
%         experiment_setup.patched_cell_loc_2 = experiment_setup.nuclear_locs(handles.data.stack_viewer_output.selected_cell_index_full_2,:);
%         experiment_setup.patched_cell_fluor_2 = experiment_setup.fluor_vals(handles.data.stack_viewer_output.selected_cell_index_full_2);

        
        experiment_setup.nuclear_locs_thresh = ...
            experiment_setup.nuclear_locs(experiment_setup.fluor_vals > experiment_setup.fluor_thresh,:);
        
%         % choose spike protocols
%         spike_prot_choices = choose_spike_timing_calibration_types;
% 
%         % choose current protocols
%         current_prot_choices = choose_current_calibration_types;
%         
%         experiment_setup.spike_prot_choices = spike_prot_choices;
%         experiment_setup.current_prot_choices = current_prot_choices;
% 
        total_trials = 0;
        all_targets = [];
%         total_targets = 0;
        total_seqs = 0;
%         all_seqs = cell(0);
%         
%         if spike_prot_choices.do_spike_power

            targs_offset = [0 0 0
                            0 0 20
                            0 0 -20
                            0 0 -40
                            0 0 40];
%             random_set_x1 = randsample([-30 -20 -12 -5 0 5 10 15],10,1)';
%             random_set_y1 = randsample([-10 -7 -5 -3 0 3 5 7 10],10,1)';
%             random_set_z1 = randsample([-40 -30 -25 -20 -15 -10 0 10 15 20 25 30 40],10,1)';
            rand_set = mvnrnd([0 0 0], diag([7.5 7.5 20].^2), 5);
            cell1_targs = bsxfun(@plus,experiment_setup.patched_cell_loc,[targs_offset; rand_set]);
            rand_set = mvnrnd([0 0 0], diag([3 3 10].^2), 5);
            cell1_targs = [cell1_targs; bsxfun(@plus,experiment_setup.patched_cell_loc,[rand_set])];
            
            cell2_targs = [];
%             random_set_x2 = randsample([-30 -20 -12 -5 0 5 10 15],10,1)';
%             random_set_y2 = randsample([-10 -7 -5 -3 0 3 5 7 10],10,1)';
%             random_set_z2 = randsample([-40 -30 -25 -20 -15 -10 0 10 15 20 25 30 40],10,1)';
%             rand_set = mvnrnd([0 0 0], diag([7.5 7.5 20].^2), 10);
%             cell2_targs = bsxfun(@plus,experiment_setup.patched_cell_loc_2,[targs_offset; rand_set]);
                            
% 
            all_targets = [all_targets; cell1_targs; cell2_targs];
            
            all_targets(all_targets(:,1) < -148,1) = -148;
            all_targets(all_targets(:,1) > 148,1) = 148;
            all_targets(all_targets(:,2) < -148,2) = -148;
            all_targets(all_targets(:,2) > 148,2) = 148;
            all_targets(all_targets(:,3) < 1,3) = 1;
            all_targets(all_targets(:,3) > 398,3) = 398;
            experiment_setup.all_targets = all_targets;
%             total_targets = total_targets + 1;

            % compute pockels refs
            clear instruction
            instruction.type = 86;
            instruction.targets = experiment_setup.all_targets;
            instruction.build_pockels_ref = 1;
            instruction.make_phase_masks = 0;
            instruction.get_return = 1;
            disp('sending instruction...')
            [return_info,success,handles] = do_instruction_slidebook(instruction,handles);

            init_powers = '2.5 5 10 15 25'; %2.5 is the same as min power!
            set(handles.target_intensity,'String',init_powers)
            set(handles.num_repeats,'String',num2str(1));
            set(handles.tf_flag,'Value',1)
            set(handles.set_seq_trigger,'Value',0)
            set(handles.num_stim,'String',num2str(size(instruction.targets,1)));
            set(handles.rand_order,'Value',1);
            set(handles.duration,'String',num2str(.003));
            set(handles.iti,'String',num2str(0.5));
            set(handles.ind_offset,'String',total_trials);

            handles.data.piezo_z = all_targets(:,3);
            handles.data.piezo_z_multiply = 0;
            

            [handles, acq_gui, acq_gui_data] = socket_control_tester('build_seq_Callback',handles.build_seq,eventdata,handles);
            total_seqs = total_seqs + 1;
            all_seqs{total_seqs} = acq_gui_data.data.sequence;
            total_trials = total_trials + length(all_seqs{total_seqs});

        
%         % setup patches/take intrinsics
%         handles = setup_patches(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
%         [acq_gui, acq_gui_data] = get_acq_gui_data;


        experiment_setup.spike_all_targets = all_targets;

        % load holograms
        clear instruction
        instruction.type = 86;
        instruction.targets = all_targets;
        instruction.build_pockels_ref = 0;
        instruction.make_phase_masks = 1;
        instruction.get_return = 1;
        disp('sending instruction...')
        [return_info,success,handles] = do_instruction_slidebook(instruction,handles);

        % prep for acq
        set(acq_gui_data.test_pulse,'Value',1)
        set(acq_gui_data.loop,'Value',1)
        set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
        set(acq_gui_data.trigger_seq,'Value',1)
        set(acq_gui_data.loop_count,'String',num2str(1))
        
        for ii = 1:3
            
            full_seq = combine_sequences(all_seqs,get(handles.rand_order,'Value'));
            experiment_setup.spike_seq = full_seq;
            % set seq to trigger
            instruction = struct();
            instruction.type = 32; %SEND SEQ
            handles.sequence = full_seq;
            instruction.sequence = full_seq;
            handles.total_duration = full_seq(end).start/1000 + 5;
            disp('sending instruction...')
            [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
            acq_gui_data.data.stim_key =  experiment_setup.spike_all_targets;
            acq_gui_data.data.sequence =  full_seq;
            guidata(acq_gui,acq_gui_data)

            set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
            acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
            guidata(hObject,handles)

            Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
            waitfor(acq_gui_data.run,'String','Start')
            [acq_gui, acq_gui_data] = get_acq_gui_data;
        
            handles.data.experiment_setup = experiment_setup;
            exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
        end
        
        % setup patches/take intrinsics
        handles = setup_patches(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
        [acq_gui, acq_gui_data] = get_acq_gui_data;
        
        if get(acq_gui_data.Cell1_type_popup,'Value') ~= 3
            
            try

            
                experiment_setup.current_targs = all_targets;
                % compute pockels refs
                clear instruction
                instruction.type = 86;
                instruction.targets = all_targets;
                instruction.build_pockels_ref = 1;
                instruction.make_phase_masks = 0;
                instruction.get_return = 1;
                disp('sending instruction...')
                [return_info,success,handles] = do_instruction_slidebook(instruction,handles);

                handles.data.piezo_z = all_targets(:,3);
                handles.data.piezo_z_multiply = 0;

                init_powers = '2.5 5 10 15 25'; %2.5 is the same as min power!
                set(handles.target_intensity,'String',init_powers)
                set(handles.num_repeats,'String',num2str(1));
                set(handles.tf_flag,'Value',1)
                set(handles.set_seq_trigger,'Value',0)
                set(handles.num_stim,'String',num2str(size(instruction.targets,1)));
                set(handles.rand_order,'Value',1);
                set(handles.duration,'String',num2str(.003));
                set(handles.iti,'String',num2str(0.5));
                set(handles.ind_offset,'String',total_trials);

                [handles, acq_gui, acq_gui_data] = socket_control_tester('build_seq_Callback',handles.build_seq,eventdata,handles);
    %             total_seqs = total_seqs + 1;
                all_seqs{total_seqs} = acq_gui_data.data.sequence;
                total_trials = length(all_seqs{total_seqs});

    %             full_seq = combine_sequences(all_seqs,get(handles.rand_order,'Value'));
    %             experiment_setup.current_seq = full_seq;

    %             experiment_setup.current_all_targets = all_targets;

                % load holograms
                clear instruction
                instruction.type = 86;
                instruction.targets = all_targets;
                instruction.build_pockels_ref = 0;
                instruction.make_phase_masks = 1;
                instruction.get_return = 1;
                disp('sending instruction...')
                [return_info,success,handles] = do_instruction_slidebook(instruction,handles);

                % prep for acq
                set(acq_gui_data.test_pulse,'Value',1)
                set(acq_gui_data.loop,'Value',1)
                set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
                set(acq_gui_data.trigger_seq,'Value',1)
                set(acq_gui_data.loop_count,'String',num2str(1))

                for ii = 1:3

                    full_seq = combine_sequences(all_seqs,get(handles.rand_order,'Value'));
                    experiment_setup.spike_seq = full_seq;
                    % set seq to trigger
                    instruction = struct();
                    instruction.type = 32; %SEND SEQ
                    handles.sequence = full_seq;
                    instruction.sequence = full_seq;
                    handles.total_duration = full_seq(end).start/1000 + 5;
                    disp('sending instruction...')
                    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
                    acq_gui_data.data.stim_key =  experiment_setup.spike_all_targets;
                    acq_gui_data.data.sequence =  full_seq;
                    guidata(acq_gui,acq_gui_data)

                    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
                    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
                    guidata(hObject,handles)

                    Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
                    waitfor(acq_gui_data.run,'String','Start')
                    [acq_gui, acq_gui_data] = get_acq_gui_data;

                    handles.data.experiment_setup = experiment_setup;
                    exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
                end
            
            catch e
                disp ('boo')
            end
        end
end

handles.data.experiment_setup = experiment_setup;
exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')

if strcmp(experiment_setup.experiment_type,'experiment')
    set(handles.close_socket_check,'Value',1);
    instruction.type = 00;
    instruction.string = 'done';
    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
    guidata(hObject,handles)
end
if strcmp(experiment_setup.experiment_type,'experiment')
    set(handles.close_socket_check,'Value',1);
    instruction.type = 00;
    instruction.string = 'done';
    [return_info,success,handles] = do_instruction_analysis(instruction,handles);
    guidata(hObject,handles)
end