function [experiment_query] = compute_phase_masks_build_seq(experiment_query, experiment_setup, neighbourhood)


group_names = experiment_setup.group_names;
phase_mask_id = 0;

% build unique phase masks
for i = 1:length(group_names)
    
    
    these_trials = experiment_query.(group_names{i}).trials;
    % signature is cell/location combos
    trial_signature = ...
        [get_rowmat_from_structarray(these_trials,'cell_IDs') ...
        get_rowmat_from_structarray(these_trials,'location_IDs')];
    % for multispot we also need to compute unique phase mask for power
    % combos
    if experiment_setup.(group_names{i}).design_func_params.trials_params.spots_per_trial > 1
        trial_signature = [trial_signature get_rowmat_from_structarray(these_trials,'power_levels')];
    end
    
    [~, unique_trials_ind, trial_index] = ...
        unique(trial_signature, 'rows');
    trials_map = unique_trials_ind(trial_index);
    
    unique_trials = experiment_query.(group_names{i}).trials(unique_trials_ind);
    
    for j = 1:length(unique_trials)
        
        phase_mask_id = phase_mask_id + 1;
        
        fullF = zeros(600,792);            
        for k =  1:experiment_setup.(group_names{i}).design_func_params.trials_params.spots_per_trial
            
            this_loc = unique_trials(j).locations(k,:);
            if any(isnan(this_loc))
                continue;
            end
            
            decval = round(this_loc,-1);
            unitval = round(this_loc - decval);
            
            convP = experiment_setup.disk_grid_phase(:,:,experiment_setup.disk_grid_key(:,1) == decval(1) & ...
                                                         experiment_setup.disk_grid_key(:,2) == decval(2)) + ...
                    experiment_setup.fine_spot_grid(:,:,experiment_setup.fine_spots_grid_key(:,1) == unitval(1) & ...
                                                         experiment_setup.fine_spots_grid_ke(:,2) == unitval(2));
            convP(convP < -pi) = convP(convP < -pi) + 2*pi;
            convP(convP > pi) = convP(convP > pi) - 2*pi;
            fullF = fullF + sqrt(unique_trials(j).adj_power_per_spot(k))*exp(1i*convP);
        end
        convP = angle(fullF);
        convP(convP < -pi) = convP(convP < -pi) + 2*pi;
        convP(convP > pi) = convP(convP > pi) - 2*pi;
        
        if experiment_setup.exp.phase_mask_struct
            phase_masks(phase_mask_id).mode = 'Phase';
            phase_masks(phase_mask_id).pattern = convP;
        else
            phase_masks(:,:,phase_mask_id) = convP;
        end
        
        matching_trials = find(trials_map == unique_trials(j));
        for k = matching_trials
            experiment_query.(group_names{i}).trials(k).precomputed_target_index = phase_mask_id;
            experiment_query.(group_names{i}).trials(k).filter_configuration = 'Femto Phasor';
            experiment_query.(group_names{i}).trials(k).duration = experiment_setup.exp.stim_duration*1000;
            % will be replaced later when we combine groups into one sequence
            experiment_query.(group_names{i}).trials(k).start = 0; 
            % needed later to rebuild
            experiment_query.(group_names{i}).trials(k).trial_ID = k;
            if strcmp(experiment_setup.experiment_type,'experiment') || experiment_setup.sim.use_power_calib
                experiment_query.(group_names{i}).trials(k).power = ...
                    round(100*get_voltage(experiment_setup.exp.pockels_lut,...
                        sum(experiment_query_this_group.trials(i_trial).adj_power_per_spot)));
            else
                experiment_query.(group_names{i}).trials(k).power = 0;
            end
        end
            
    end
    
    trials_per_group(i) = length(these_trials);
    avg_trials_per_cell(i) = trials_per_group(i) * ...
        experiment_setup.(group_names{i}).design_func_params.trials_params.spots_per_trial/...
        length(get_group_inds(neighbourhood,group_names{i}));
      
end

group_max_trial_rate = sum(trials_per_group)/avg_trials_per_cell * experiment_setup.exp.max_spike_freq;
batch_trial_rate = min([experiment_setup.exp.max_stim_freq group_max_trial_rate]);

experiment_query.phase_masks = phase_masks;
experiment_query.batch_trial_rate = batch_trial_rate; % in Hz




