function run_mapping_experiment(experiment_setup,varargin)

if strcmp(experiment_setup.experiment_type,'experiment')
    
    is_exp = 1;
    handles = varargin{1};
    hObject = varargin{2};
    
    choice = questdlg('Choose start point?',...
        'Choose start point?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            experiment_setup.enable_user_breaks = 1;
        case 'No'
            experiment_setup.enable_user_breaks = 0;
    end
    guidata(hObject,handles)
    
    reinit_oed = 0;
    if experiment_setup.enable_user_breaks
        choice = questdlg('Initialize OED experiment_setup?',...
            'Initialize OED experiment_setup?', ...
            'Yes','No','Yes');
        % Handle response
        switch choice
            case 'Yes'
                reinit_oed = 1;
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
                guidata(hObject,handles)
            case 'No'
                reinit_oed = 0;
        end
    end

    if reinit_oed
        load_map = 1;
        experiment_setup = get_experiment_setup(load_map);
        guidata(hObject,handles)
    end

    load_exp = 0;
    if experiment_setup.enable_user_breaks
        choice = questdlg('Load an experiment?',...
            'Initialize OED experiment_setup?', ...
            'Yes','No','Yes');
        % Handle response
        switch choice
            case 'Yes'
                load_exp = 1;
            case 'No'
                load_exp = 0;
        end
    end

    if load_exp
        [data_filename,data_pathname] = uigetfile('*.mat','Select data .mat file...');
        load(fullfile(data_pathname,data_filename),'exp_data')
        handles.data = exp_data;
        experiment_setup = handles.data.experiment_setup;
    end

    guidata(hObject,handles)

    % shift focus
    [acq_gui, acq_gui_data] = get_acq_gui_data;
    figure(acq_gui)

    set(handles.close_socket_check,'Value',0)
    guidata(hObject,handles);
    
else
    is_exp = 0;
    experiment_setup.enable_user_breaks = 0;
end



% get cell locations or simulate
if is_exp && ~experiment_setup.exp.sim_locs
    
    eventdata = [];
    handles = set_new_ref_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    % move obj to ref position (top of slice, centered on map fov)
    set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
    set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
    set(handles.thenewz,'String',num2str(handles.data.ref_obj_position(3)))

    [handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

    handles = take_slidebook_stack(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    set_depths = 1;
    choice = questdlg('Set Z-Depths?', ...
        'Set Cell Pos?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            set_depths = 1;
        case 'No'
            set_depths = 0;
    end

    if set_depths
        handles.data.z_offsets = inputdlg('Z Locations?',...
                     'Z Locations?',1,{experiment_setup.exp.z_depths});
        handles.data.z_offsets = strread(handles.data.z_offsets{1})';
        handles.data.obj_positions = [zeros(length(handles.data.z_offsets),1) zeros(length(handles.data.z_offsets),1) handles.data.z_offsets];
        handles.data.obj_positions = bsxfun(@plus,handles.data.obj_positions,handles.data.obj_position);
        acq_gui_data.data.obj_positions = handles.data.obj_positions;
        guidata(hObject,handles);
        guidata(acq_gui,acq_gui_data)
        exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')
    end

    % Set power, TODO: add user break
    user_input_powers = inputdlg('Enter desired powers (space-delimited):',...
                 'Powers to run?',1,{experiment_setup.exp.power_levels});
    user_input_powers = strread(user_input_powers{1});
    handles.data.experiment_setup.exp.user_power_level = user_input_powers;
    experiment_setup = handles.data.experiment_setup;
    guidata(hObject,handles)

    [handles, experiment_setup] = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;
else
    experiment_setup = sim_cell_positions(experiment_setup);
end

if experiment_setup.is_exp
    handles = create_neighbourhoods_caller(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
    neighbourhoods = handles.data.neighbourhoods;
    [acq_gui, acq_gui_data] = get_acq_gui_data;

else
    neighbourhoods = create_neighbourhoods(experiment_setup);   
end

handles = build_first_batch_stim_all_neighborhoods(hObject,handles,acq_gui,acq_gui_data,experiment_setup);

if experiment_setup.is_exp
    % get info on patched cells while first batches prep
    handles = set_cell1_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    handles = set_cell2_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    handles = setup_patches(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
    set(acq_gui_data.trigger_seq,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
end
num_map_locations = length(neighbourhoods);


while not_terminated
    for i = 1:num_map_locations
    
        % check for holograms to do
        
        if experiemnt_setup.is_exp
            % move obj
            set(handles.thenewx,'String',num2str(handles.data.obj_positions(i,1)))
            set(handles.thenewy,'String',num2str(handles.data.obj_positions(i,2)))
            set(handles.thenewz,'String',num2str(handles.data.obj_positions(i,3)))
            [handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
    
    
    
        %------------------------------------------%
        % Run the designed trials
        
        do_create_stim_phases = 1;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Design targets and compute holo?', ...
                'Design targets and compute holo?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    do_create_stim_phases = 1;
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
                    do_create_stim_phases = 0;
            end
        end
        
        if do_create_stim_phases
            
            multi_spot_targs = [];
            multi_spot_pockels = [];
            pockels_ratios = [];
            single_spot_targs = [];
            single_spot_pockels_refs = [];
            handles.data.group_powers = cell(0);
            
            num_stim = 0;

            handles.data.sequence_groups = zeros(3,2);
            % add undefined targets
            handles.data.sequence_groups(1,:) = [1 length(handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter})];
            if ~isempty(handles.data.design.trials_pockels_ratios_multi_undefined{i}{handles.data.design.iter})
                multi_spot_targs = cat(1,multi_spot_targs,handles.data.design.trials_locations_undefined_key{i}{handles.data.design.iter});
                multi_spot_pockels = [multi_spot_pockels handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter}];
                pockels_ratios = cat(1,pockels_ratios,handles.data.design.trials_pockels_ratios_multi_undefined{i}{handles.data.design.iter});
                undefined_freq = size(handles.data.design.trials_locations_undefined_key{i}{handles.data.design.iter},1) * ...
                    experiment_setup.design.n_spots_per_trial/length(handles.data.design.undefined_cells{i}{handles.data.design.iter});
                handles.data.group_repeats(1) = 1;
                num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter});
                handles.data.group_powers{1} = experiment_setup.exp.max_power_ref;
                handles.data.group_multi_flag(1) = 1;
            else
                single_spot_targs = cat(1,single_spot_targs,handles.data.design.trials_locations_undefined_key{i}{handles.data.design.iter});
                single_spot_pockels_refs = [single_spot_pockels_refs handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter}];
                undefined_freq = experiment_setup.design.K_undefined;
                handles.data.group_repeats(1) = experiment_setup.design.reps_undefined_single;
                num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter})*experiment_setup.design.reps_undefined_single;
                handles.data.group_powers{1} = handles.data.design.trials_powers_undefined{i}{handles.data.design.iter};
                handles.data.group_multi_flag(1) = 0;
            end

            % add disconnected targets
            handles.data.sequence_groups(2,:) = [1  length(handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter})] +...
                handles.data.sequence_groups(1,2);
            if ~isempty(handles.data.design.trials_pockels_ratios_multi_disconnected{i}{handles.data.design.iter})
                multi_spot_targs = cat(1,multi_spot_targs,handles.data.design.trials_locations_disconnected_key{i}{handles.data.design.iter});
                multi_spot_pockels = [multi_spot_pockels handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter}];
                pockels_ratios = cat(1,pockels_ratios,handles.data.design.trials_pockels_ratios_multi_disconnected{i}{handles.data.design.iter});
                disconnected_freq = size(handles.data.design.trials_locations_disconnected_key{i}{handles.data.design.iter},1) * ...
                    experiment_setup.design.n_spots_per_trial/length(handles.data.design.potentially_disconnected_cells{i}{handles.data.design.iter});
                handles.data.group_repeats(2) = 1;
                num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter});
                handles.data.group_powers{2} = experiment_setup.exp.max_power_ref;
                handles.data.group_multi_flag(2) = 1;
            else
                single_spot_targs = cat(1,single_spot_targs,handles.data.design.trials_locations_disconnected_key{i}{handles.data.design.iter});
                single_spot_pockels_refs = [single_spot_pockels_refs handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter}];
                disconnected_freq = experiment_setup.design.K_disconnected;
                handles.data.group_repeats(2) = experiment_setup.design.reps_disconnected_single;
                num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter})*experiment_setup.design.reps_disconnected_single;
                handles.data.group_powers{2} = handles.data.design.trials_powers_disconnected{i}{handles.data.design.iter};
                handles.data.group_multi_flag(2) = 0;
            end

            % add connected targets
            handles.data.sequence_groups(3,:) = [1  length(handles.data.design.trials_pockels_ratios_connected{i}{handles.data.design.iter})] + ...
                handles.data.sequence_groups(2,2);
            single_spot_targs = cat(1,single_spot_targs,handles.data.design.trials_locations_connected_key{i}{handles.data.design.iter});
                single_spot_pockels_refs = [single_spot_pockels_refs handles.data.design.trials_pockels_ratios_connected{i}{handles.data.design.iter}];
            handles.data.group_repeats(3) = experiment_setup.design.reps_connected;%experiment_setup.design.K_connected;
            num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_connected{i}{handles.data.design.iter})*experiment_setup.design.reps_connected;
            handles.data.group_powers{3} = handles.data.design.trials_powers_connected{i}{handles.data.design.iter};
            handles.data.group_multi_flag(3) = 0;
    %         num_stim_check = size(multi_spot_targs,1)+size(single_spot_targs,1)

            % compute maximal stim freq
            undefined_freq = num_stim/undefined_freq;
            disconnected_freq = num_stim/disconnected_freq;
            connected_freq = num_stim/experiment_setup.design.K_connected;

            handles.data.stim_freq = min([[undefined_freq disconnected_freq connected_freq]*experiment_setup.exp.max_spike_freq experiment_setup.exp.max_stim_freq])
            set(handles.iti,'String',num2str(1/handles.data.stim_freq))

            guidata(hObject,handles)
            
            % build the holograms
            instruction = struct();
            instruction.type = 83;
            instruction.do_target = 1;
            instruction.multi_spot_targs = multi_spot_targs;
            instruction.multi_spot_pockels = multi_spot_pockels;
            instruction.pockels_ratios = pockels_ratios;
            instruction.single_spot_targs = single_spot_targs;
            instruction.single_spot_pockels_refs = single_spot_pockels_refs;

            [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
            guidata(hObject,handles)
            exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data');
            set(handles.num_stim,'String',num2str(num_stim));
        end
%         set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
        
        do_run_trials = 1;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Run the trials?', ...
                'Run the trials?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    do_run_trials = 1;
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
                    do_run_trials = 0;
            end
        end
        
        if do_run_trials
            set(handles.tf_flag,'Value',1)
            set(handles.set_seq_trigger,'Value',0)
            set(handles.target_intensity,'String',user_input_powers)

            [handles, acq_gui, acq_gui_data] = build_seq_groups(hObject, eventdata, handles);
        %     handles = guidata(hObject);
        %     acq_gui_data = get_acq_gui_data();
            max_seq_length = str2double(get(handles.max_seq_length,'String'));
            this_seq = acq_gui_data.data.sequence;
            num_runs = ceil(length(this_seq)/max_seq_length);
            handles.data.start_trial = acq_gui_data.data.sweep_counter + 1;

            for run_i = 1:num_runs

                this_subseq = this_seq((run_i-1)*max_seq_length+1:min(run_i*max_seq_length,length(this_seq)));
                time_offset = this_subseq(1).start - 1000;
                for k = 1:length(this_subseq)
                    this_subseq(k).start = this_subseq(k).start - time_offset;
                end
                total_duration = (this_subseq(end).start + this_subseq(end).duration)/1000 + 5;

                set(acq_gui_data.trial_length,'String',num2str(total_duration + 1.0))
                acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
                instruction = struct();
                instruction.type = 32; %SEND SEQ
                handles.sequence = this_subseq;
                instruction.sequence = this_subseq;
                handles.total_duration = total_duration;
                instruction.waittime = total_duration + 120;
                disp('sending instruction...')
                [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
        %         acq_gui_data = get_acq_gui_data();
        %         acq_gui_data.data.stim_key =  return_info.stim_key;
                acq_gui_data.data.sequence =  this_subseq;
        %         acq_gui = findobj('Tag','acq_gui');
                guidata(acq_gui,acq_gui_data)

                set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
                acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

                guidata(hObject,handles)
                exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')
        %         guidata(acq_gui,acq_gui_data)

                acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
                waitfor(acq_gui_data.run,'String','Start')
                guidata(acq_gui,acq_gui_data)

            end
        end
        
        do_oasis_and_vi = 1;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Run OASIS and VI?', ...
                'Run OASIS and VI?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    do_oasis_and_vi = 1;
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
                    do_oasis_and_vi = 0;
            end
        end
        
        if do_oasis_and_vi
            trials = handles.data.start_trial:acq_gui_data.data.sweep_counter;
            [traces, ~, full_seq] = get_traces(acq_gui_data.data,trials);
            if ~experiment_setup.design.do_connected_vi
                traces = traces([full_seq.group] ~= 3,:);
            end
            instruction = struct();
            instruction.data = traces;
            instruction.type = 200;
            instruction.filename = [handles.data.experiment_setup.map_id '_z' num2str(i) '_iter' num2str(handles.data.design.iter)];

            instruction.do_dummy_data = 0;


            handles.data.full_seq = full_seq;

            
            handles.data.design.i = i;
            handles.data.design.n_cell_this_plane = n_cell_this_plane;
            
            instruction.exp_data = handles.data;
            [return_info,success,handles] = do_instruction_analysis(instruction,handles);
            
            handles.data = return_info.data; 
            guidata(hObject,handles)
            exp_data = handles.data;
            save(handles.data.experiment_setup.fullsavefile,'exp_data')
            
        end    
            
        regroup_cells = 1;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Regroup cells?', ...
            'Regroup cells?', ...
            'Yes','No','Yes');
            % Handle response
            switch choice
            case 'Yes'
                regroup_cells = 1;
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
                regroup_cells = 0;
            end
        end

        if regroup_cells
            data = handles.data;
            undefined_to_disconnected = ...
                intersect(find(data.design.mean_gamma_undefined<experiment_setup.design.disconnected_threshold),find( data.design.undefined_cells{i}{data.design.iter}));
            undefined_to_connected = ...
                intersect(find(data.design.mean_gamma_undefined>experiment_setup.design.connected_threshold),find( data.design.undefined_cells{i}{data.design.iter}));
            % cells move together with their neighbours
%             undefined_to_disconnected=find(sum(cell_neighbours(undefined_to_disconnected,:),1)>0)';
%             undefined_to_connected =find(sum(cell_neighbours(undefined_to_connected,:),1)>0);
%             % if there are conflicts, move them to the potentially connected cells
%             undefined_to_disconnected=setdiff(undefined_to_disconnected,undefined_to_connected);

            disconnected_to_undefined = intersect(find(data.design.mean_gamma_disconnected>experiment_setup.design.disconnected_confirm_threshold),...
                find(data.design.potentially_disconnected_cells{i}{data.design.iter}));
            disconnected_to_dead = intersect(find(data.design.mean_gamma_disconnected<experiment_setup.design.disconnected_confirm_threshold),...
                find(data.design.potentially_disconnected_cells{i}{data.design.iter}));

%             disconnected_to_undefined=find(sum(cell_neighbours(disconnected_to_undefined,:),1)>0);
%             % if there are conflicts, move them to the potentially connected cells
%             disconnected_to_dead=setdiff(disconnected_to_dead,disconnected_to_undefined);


            connected_to_dead = intersect(find(data.design.mean_gamma_connected<experiment_setup.design.disconnected_confirm_threshold),...
                find(data.design.potentially_connected_cells{i}{data.design.iter}));
            connected_to_alive = intersect(find(data.design.mean_gamma_connected>experiment_setup.design.connected_confirm_threshold),...
                find(data.design.potentially_connected_cells{i}{data.design.iter}));
%             change_gamma =abs(data.design.gamma_path{i}(:,data.design.iter+1)-data.design.gamma_path{i}(:,data.design.iter));
            connected_to_alive = intersect(find(data.design.change_gamma<experiment_setup.design.change_threshold),...
                connected_to_alive);

            % Eliminate the weakly identifiable pairs if they are both assign to a
            % group:
            %moved_cells = [connected_to_dead; connected_to_alive]';
            %cells_and_neighbours=find(sum(cell_neighbours(moved_cells,:),1)>0);
            %neighbours_not_included=intersect(find(data.design.potentially_connected_cells{i}{data.design.iter}), setdiff(cells_and_neighbours,moved_cells));
            %blacklist=find(sum(cell_neighbours(neighbours_not_included,:),1)>0);
            %connected_to_dead=setdiff(connected_to_dead ,blacklist);
            %connected_to_alive=setdiff(connected_to_alive,blacklist);

            % Update the cell lists:
            data.design.undefined_cells{i}{data.design.iter+1}=data.design.undefined_cells{i}{data.design.iter};
            data.design.undefined_cells{i}{data.design.iter+1}(undefined_to_disconnected)=0;data.design.undefined_cells{i}{data.design.iter+1}(undefined_to_connected)=0;
            data.design.undefined_cells{i}{data.design.iter+1}(disconnected_to_undefined)=1;

            data.design.potentially_disconnected_cells{i}{data.design.iter+1}=data.design.potentially_disconnected_cells{i}{data.design.iter};
            data.design.potentially_disconnected_cells{i}{data.design.iter+1}(disconnected_to_dead)=0;data.design.potentially_disconnected_cells{i}{data.design.iter+1}(disconnected_to_undefined)=0;
            data.design.potentially_disconnected_cells{i}{data.design.iter+1}(undefined_to_disconnected)=1;


            data.design.potentially_connected_cells{i}{data.design.iter+1}=data.design.potentially_connected_cells{i}{data.design.iter};
            data.design.potentially_connected_cells{i}{data.design.iter+1}(connected_to_dead)=0;data.design.potentially_connected_cells{i}{data.design.iter+1}(connected_to_alive)=0;
            data.design.potentially_connected_cells{i}{data.design.iter+1}(undefined_to_connected)=1;

            data.design.dead_cells{i}{data.design.iter+1}=data.design.dead_cells{i}{data.design.iter};
            data.design.dead_cells{i}{data.design.iter+1}(disconnected_to_dead)=1;data.design.dead_cells{i}{data.design.iter+1}(connected_to_dead)=1;

            data.design.alive_cells{i}{data.design.iter+1}=data.design.alive_cells{i}{data.design.iter};
            data.design.alive_cells{i}{data.design.iter+1}(connected_to_alive)=1;
            
            assignin('base','undefined_cells',data.design.undefined_cells{i})
            assignin('base','potentially_disconnected_cells',data.design.potentially_disconnected_cells{i})
            assignin('base','potentially_connected_cells',data.design.potentially_connected_cells{i})
            
            %
            if sum(data.design.dead_cells{i}{data.design.iter}+data.design.alive_cells{i}{data.design.iter})==n_cell_this_plane
                data.design.id_continue{i}=0;% terminate
            else
                data.design.id_continue{i}=1;
            end
            data.design.iter = data.design.iter + 1
            handles.data = data;
            guidata(hObject,handles)
            save(handles.data.experiment_setup.fullsavefile,'exp_data')
        end
        
        
        
        % Plot the progress
        fprintf('Number of trials so far: %d; number of cells killed: %d\n',handles.data.design.n_trials{i}, sum(handles.data.design.dead_cells{i}{handles.data.design.iter}+handles.data.design.alive_cells{i}{handles.data.design.iter}))
        
        do_cont = 0;
        choice = questdlg('Continue Plane?', ...
        'Continue Plane?', ...
        'Yes','No','Yes');
        % Handle response
        switch choice
        case 'Yes'
            do_cont = 1;
        case 'No'
            do_cont = 0;
        end

        if ~do_cont   
            handles.data.design.id_continue{i} = 0;
        end
    end
end    

exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')

set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction_slidebook(instruction,handles);
guidata(hObject,handles)    