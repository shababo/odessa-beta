function neural_response_calibration(experiment_setup,varargin)

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

        wrndlg = warndlg('Set 0 position by going to top of slice with piezo = 0');
        waitfor(wrndlg)

        answer = inputdlg('Go to cell z depth. What is piezo z depth for cell in um?');
        experiment_setup.cell_z = str2num(answer{1});

        wrndlg = warndlg('Set 0 position by going to top of slice with piezo = 0');
        waitfor(wrndlg)

        eventdata = [];
        disp('Get objective ref position...')
        [experiment_setup, handles] = set_new_ref_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
        [acq_gui, acq_gui_data] = get_acq_gui_data;

        disp('Take stack...')
        [handles, experiment_setup] = take_slidebook_stack(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
        [acq_gui, acq_gui_data] = get_acq_gui_data;

        disp('Detect nuclei...')
        [handles, experiment_setup] = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
        disp('Interactive patched cell selection...')
        stack_viewer(experiment_setup.stack,experiment_setup.nuclear_locs_image_coord,experiment_setup.cell_z,handles)



        % choose spike protocols
        spike_prot_choices = choose_spike_timing_calibration_types

        % choose current protocols
        current_prot_choices = choose_current_calibration_types

        total_trials = 0;
        all_targets = [];
        total_targets = 0;
        total_seqs = 0;
        all_seqs = cell(0);
        if spike_prot_choices.do_spike_power

            experiment_setup.nuc_loc
            all_targets = [all_targets; experiment_setup.nuc_loc];
            total_targets = total_targets + 1;

            % compute pockels refs
            clear instruction
            instruction.type = 86;
            instruction.targets = experiment_setup.nuc_loc;
            instruction.build_pockels_ref = 1;
            instruction.make_phase_masks = 0;
            instruction.get_return = 1;
            disp('sending instruction...')
            [return_info,success,handles] = do_instruction_slidebook(instruction,handles);

            init_powers = '2.5 10 25 50 80'; %2.5 is the same as min power!
            set(handles.target_intensity,'String',init_powers)
            set(handles.num_repeats,'String',num2str(3));
            set(handles.tf_flag,'Value',1)
            set(handles.set_seq_trigger,'Value',0)
            set(handles.num_stim,'String',num2str(1));
            set(handles.rand_order,'Value',1);
            set(handles.duration,'String',num2str(.003));
            set(handles.iti,'String',num2str(2.0));
            set(handles.ind_offset,'String',total_trials);

            handles.data.piezo_z = experiment_setup.nuc_loc(3);
            handles.data.piezo_z_multiply = 1;

            [handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles);
            total_seqs = total_seqs + 1;
            all_seqs{total_seqs} = acq_gui_data.data.sequence;
            total_trials = total_trials + length(all_seqs{total_seqs});

        end 

        if spike_prot_choices.do_radial_vert

            measure_points = [-50 -30 -15 -10 -7 -4 -2 0 2 4 7 10 15 25]; % um
            num_targets = length(measure_points);
            radial_vert_targs = ...
                zeros(num_targets,3);

            count = 1;
            for i = 1:num_targets
                    radial_vert_targs(i,:) = experiment_setup.nuc_loc + ...
                        [measure_points(i) 0 0];
            end
            all_targets = [all_targets; radial_vert_targs];
            total_targets = total_targets + num_targets;
            experiment_setup.radial_vert_targs = radial_vert_targs;

            % compute pockels refs
            clear instruction
            instruction.type = 86;
            instruction.targets = experiment_setup.radial_vert_targs;
            instruction.build_pockels_ref = 1;
            instruction.make_phase_masks = 0;
            instruction.get_return = 1;
            disp('sending instruction...')
            [return_info,success,handles] = do_instruction_slidebook(instruction,handles);

            init_powers = '50';
            set(handles.target_intensity,'String',init_powers)
            set(handles.num_repeats,'String',num2str(3));
            set(handles.tf_flag,'Value',1)
            set(handles.set_seq_trigger,'Value',0)
            set(handles.num_stim,'String',num2str(1));
            set(handles.rand_order,'Value',1);
            set(handles.duration,'String',num2str(.003));
            set(handles.iti,'String',num2str(2.0));
            set(handles.ind_offset,'String',total_trials);

            handles.data.piezo_z = experiment_setup.nuc_loc(3);
            handles.data.piezo_z_multiply = 1;

            [handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles);
            total_seqs = total_seqs + 1;
            all_seqs{total_seqs} = acq_gui_data.data.sequence;
            total_trials = total_trials + length(all_seqs{total_seqs});

        end

        if spike_prot_choices.do_radial_horiz

            measure_points = [-25 -15 -10 -7 -4 -2 0 2 4 7 10 15 25]; % um
            num_targets = length(measure_points);
            radial_horiz_targs = ...
                zeros(num_targets,3);

            count = 1;
            for i = 1:num_targets
                    radial_horiz_targs(i,:) = experiment_setup.nuc_loc + ...
                        [0 measure_points(i) 0];
            end
            all_targets = [all_targets; radial_horiz_targs];
            total_targets = total_targets + num_targets;
            experiment_setup.radial_horiz_targs = radial_horiz_targs;

            % compute pockels refs
            clear instruction
            instruction.type = 86;
            instruction.targets = experiment_setup.radial_horiz_targs;
            instruction.build_pockels_ref = 1;
            instruction.make_phase_masks = 0;
            instruction.get_return = 1;
            disp('sending instruction...')
            [return_info,success,handles] = do_instruction_slidebook(instruction,handles);

            init_powers = '50';
            set(handles.target_intensity,'String',init_powers)
            set(handles.num_repeats,'String',num2str(3));
            set(handles.tf_flag,'Value',1)
            set(handles.set_seq_trigger,'Value',0)
            set(handles.num_stim,'String',num2str(1));
            set(handles.rand_order,'Value',1);
            set(handles.duration,'String',num2str(.003));
            set(handles.iti,'String',num2str(2.0));
            set(handles.ind_offset,'String',total_trials);

            handles.data.piezo_z = experiment_setup.nuc_loc(3);
            handles.data.piezo_z_multiply = 1;

            [handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles);
            total_seqs = total_seqs + 1;
            all_seqs{total_seqs} = acq_gui_data.data.sequence;
            total_trials = total_trials + length(all_seqs{total_seqs});

        end

        if spike_prot_choices.do_axial

            all_targets = [all_targets; experiment_setup.nuc_loc];
            total_targets = total_targets + 1;
            experiment_setup.axial_targs = experiment_setup.nuc_loc;

            % compute pockels refs
            clear instruction
            instruction.type = 86;
            instruction.targets = experiment_setup.axial_targs;
            instruction.build_pockels_ref = 1;
            instruction.make_phase_masks = 0;
            instruction.get_return = 1;
            disp('sending instruction...')
            [return_info,success,handles] = do_instruction_slidebook(instruction,handles);

            init_z = [-60 -45 -30 -20 -10 0 10 20 30 45 60] + experiment_setup.nuc_loc(3);
            handles.data.piezo_z = init_z;
            handles.data.piezo_z_multiply = 1;

            init_powers = '50';
            set(handles.target_intensity,'String',init_powers)
            set(handles.num_repeats,'String',num2str(3));
            set(handles.tf_flag,'Value',1)
            set(handles.set_seq_trigger,'Value',0)
            set(handles.num_stim,'String',num2str(1));
            set(handles.rand_order,'Value',1);
            set(handles.duration,'String',num2str(.003));
            set(handles.iti,'String',num2str(2.0));
            set(handles.ind_offset,'String',total_trials);

            [handles, acq_gui, acq_gui_data] = build_seq_Callback(hObject, eventdata, handles);
            total_seqs = total_seqs + 1;
            all_seqs{total_seqs} = acq_gui_data.data.sequence;
            total_trials = total_trials + length(all_seqs{total_seqs});

        end

        experiment_setup.spike_prot_choices = spike_prot_choices;
        experiment_setup.current_prot_choices = current_prot_choices;

        experiment_setup.spike_first_round_all_seqs = all_seqs;
        experiment_setup.spike_first_round_all_targets = all_targets;
        full_seq = combine_sequences(sequences,rand_order);
        experiment_setup.spike_first_round_seq = full_seq;
        total_duration = (full_seq(end).start + full_seq(end).duration)/1000 + 5;

        % load holograms
        clear instruction
        instruction.type = 86;
        instruction.targets = experiment_setup.spike_first_round_all_targets;
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

        % set seq to trigger
        instruction = struct();
        instruction.type = 32; %SEND SEQ
        handles.sequence = full_seq;
        instruction.sequence = full_seq;
        handles.total_duration = total_duration;
        disp('sending instruction...')
        [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
        acq_gui_data.data.stim_key =  experiment_setup.spike_first_round_all_targets;
        acq_gui_data.data.sequence =  full_seq;
        guidata(acq_gui,acq_gui_data)

        set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);


        % do next round of spiking based on threshold


        % setup patches/take intrinsics
        handles = setup_patches(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
        [acq_gui, acq_gui_data] = get_acq_gui_data;

        % get currents
        full_seq = combine_sequences(sequences,rand_order);
        experiment_setup.current_seq = full_seq;

        experiment_setup.current_all_targets = experiment_setup.spike_first_round_all_targets;

        % load holograms
        clear instruction
        instruction.type = 86;
        instruction.targets = experiment_setup.current_all_targets;
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

        % set seq to trigger
        instruction = struct();
        instruction.type = 32; %SEND SEQ
        handles.sequence = full_seq;
        instruction.sequence = full_seq;
        handles.total_duration = total_duration;
        disp('sending instruction...')
        [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
        acq_gui_data.data.stim_key =  experiment_setup.current_all_targets;
        acq_gui_data.data.sequence =  full_seq;
        guidata(acq_gui,acq_gui_data)

        set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        
end