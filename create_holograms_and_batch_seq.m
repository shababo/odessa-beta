function create_holograms_and_batch_seq

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