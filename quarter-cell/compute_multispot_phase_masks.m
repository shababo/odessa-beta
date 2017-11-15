function [experiment_query] = compute_multispot_phase_masks(experiment_query, experiment_setup)

% function [phase_masks,stim_key,pockels_ratio_refs_all] = ...
%     build_multi_loc_phases(multi_spot_targs,pockels_refs, pockels_ratios,...
%     single_spot_targs, single_spot_pockels_refs,...
%     coarse_disks,disk_key,fine_spots,spot_key,do_target)


tic

slm_size = size(experiment_setup.coarse_disks);
slm_size = slm_size([1 2]);

% get unique stim
unique_stim_combos = [];
unique_stim_ids = [];

for i = 1:length(group_names)
    
    these_trials = experiment_query.(group_names{i}).trials;
    cell_combos = get_rowmat_from_structarray(these_trials,'cell_IDs')
    [data_unique,~,data_index] = unique(cell_combos, 'rows');
    data_unique = padarray(data_unique,[max(0,experiment_setup.max_spots_per_trial - size(data_unique,2)),NaN);
    
    unique_stim_combos = [unique_stim_combos; data_unique];
    unique_stim_ids = [unique_stim_ids; data_index];
    
end

num_phase_masks = size(unique_stim_combos,1);

if do_target
    phase_masks(num_holograms).mode = 'Phase';
    phase_masks(num_holograms).pattern = zeros(slm_size);
else
    phase_masks = zeros([slm_size num_holograms]);
end

targs_per_stim = size(target_locations,3);
stim_key = NaN*ones(num_holograms,3,targs_per_stim);

pockels_ratio_refs_all = [pockels_refs single_spot_pockels_refs];

for i = 1:num_multi_spots

    fullF = zeros(600,792);

    spot_power_ratios = pockels_ratios(i,:);
    
    dec_ind = zeros(targs_per_stim,1);
    for k = 1:targs_per_stim
        this_loc = target_locations(i,:,k);

        if any(isnan(this_loc))
            continue;
        end
        decval = round(this_loc,-1);
        unitval = round(this_loc - decval);
%             dec_ind = find();
        convP = coarse_disks(:,:,disk_key(:,1) == decval(1) & disk_key(:,2) == decval(2)) + ...
            fine_spots(:,:,spot_key(:,1) == unitval(1) & spot_key(:,2) == unitval(2));
        convP(convP < -pi) = convP(convP < -pi) + 2*pi;
        convP(convP > pi) = convP(convP > pi) - 2*pi;
        fullF = fullF + sqrt(spot_power_ratios(k))*exp(1i*convP);
       
        stim_key(i,:,k) = round(this_loc);
       
    end
%     spot_ind = spots_key(these_spots(max_spot_ind),[1 2])/20 + 9;
    
    convP = angle(fullF);% + diskPhase(:,:,2); already starting with disks now
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    phase_masks(i).pattern = convP;
    phase_masks(i).mode = 'Phase';
    
end

for i = 1:num_singles

    this_loc = single_spot_targs(i,:);
    decval = round(this_loc,-1);
    unitval = round(this_loc - decval);
    dec_ind = find(disk_key(:,1) == decval(1) & disk_key(:,2) == decval(2));
    convP = coarse_disks(:,:,dec_ind) + ...
        fine_spots(:,:,spot_key(:,1) == unitval(1) & spot_key(:,2) == unitval(2));
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;


    if do_target
%         for j = 1:num_singles_repeats
            phase_masks(i+num_multi_spots).mode = 'Phase';
            phase_masks(i+num_multi_spots).pattern = convP;
            
%         end
    else 
%         for j = 1:num_singles_repeats
            phase_masks(:,:,i+num_multi_spots) = convP;
%         end
    end  
    stim_key(i+num_multi_spots,:,1) = round(this_loc);

end    


