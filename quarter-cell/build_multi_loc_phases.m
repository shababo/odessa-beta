function [phase_masks,stim_key,pockels_ratio_refs_multi] = ...
    build_multi_loc_phases(multitarg_locs,num_stim,single_spot_locs,targs_per_stim,...
    repeat_target,coarse_disks,disk_key,ratio_map,fine_spots,spot_key,do_target,show_stats)
rng(123566)

tic
% num_nuc = size(nuclear_locs,1);
% num_nearby = size(nearby_locs,1);
num_singles = size(single_spot_locs,1);%num_nuc+num_nearby;
slm_size = size(coarse_disks);
slm_size = slm_size([1 2]);
num_multi_spots = size(multitarg_locs,1);
all_spots = 1:num_multi_spots;
all_targets = zeros(num_stim,targs_per_stim);
all_distances = zeros(num_stim,nchoosek(targs_per_stim,2));
% num_singles_repeats = 3;
if do_target
    phase_masks(num_stim+num_singles).mode = 'Phase';
    phase_masks(num_stim+num_singles).pattern = zeros(slm_size);
else
    phase_masks = zeros([slm_size num_stim+num_singles]);
end
stim_key = zeros(num_stim+num_singles,3,targs_per_stim);
pockels_ratio_refs_multi = Inf*ones(num_stim+num_singles,1);
targets_cov = zeros(num_multi_spots); 
singles_phases = zeros([slm_size num_singles+num_multi_spots]);


for i = 1:num_singles
    this_loc = single_spot_locs(i,:);
    decval = round(this_loc,-1);
    unitval = round(this_loc - decval);
    dec_ind = find(disk_key(:,1) == decval(1) & disk_key(:,2) == decval(2));
    convP = coarse_disks(:,:,dec_ind) + ...
        fine_spots(:,:,spot_key(:,1) == unitval(1) & spot_key(:,2) == unitval(2));
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;

    singles_phases(:,:,i) = convP;

    if do_target
%         for j = 1:num_singles_repeats
            phase_masks(i+num_stim).mode = 'Phase';
            phase_masks(i+num_stim).pattern = convP;
            pockels_ratio_refs_multi(i+num_stim) = ratio_map(dec_ind);
%         end
    else 
%         for j = 1:num_singles_repeats
            phase_masks(:,:,i+num_stim) = convP;
            pockels_ratio_refs_multi(i+num_stim) = ratio_map(dec_ind);
%         end
    end  
    stim_key(i+num_stim,:,1) = round(this_loc);
    for k = 2:targs_per_stim
%         for j = 1:num_singles_repeats
            stim_key(i+num_stim,:,k) = NaN;
%         end
    end
end    

% dec_ind = zeros(num_stim,1);
computed_locs = single_spot_locs;
extra_phase = 1;
max_attempts = 1000;
for i = 1:num_stim
%     i
    fullF = zeros(600,792);
    distances = 0;
    
    attempt_count = 0;
    
    while any(distances <= 1) || pockels_ratio_refs_multi(i) > 6
        
        if attempt_count > max_attempts
            break
        end
        
        these_spots = randsample(all_spots,targs_per_stim);
        distances = pdist(multitarg_locs(these_spots,[1 2]));
        
        if all(distances > 60) 
%             spots_power = zeros(targs_per_stim,1);
            dec_ind = zeros(targs_per_stim,1);
            for k = 1:targs_per_stim
                this_loc = multitarg_locs(these_spots(k),:);
                decval = round(this_loc,-1);
                dec_ind(k) = find(disk_key(:,1) == decval(1) & disk_key(:,2) == decval(2));
            end

            spot_power_ratios = round(ratio_map(dec_ind)*10000);
            pockels_ratio_refs_multi(i) = sum(spot_power_ratios)/10000;
        end
        
        if pockels_ratio_refs_multi(i) > 6
            attempt_count = attempt_count + 1;
            continue
        end
        
        stim_vec = zeros(num_multi_spots,1);
        stim_vec(these_spots) = 1;
        targets_cov_tmp = targets_cov + stim_vec*stim_vec';
        upper_targ = triu(targets_cov_tmp,1);
        if any(upper_targ(:) > 2)
            distances = zeros(targs_per_stim,1);
        end
        attempt_count = attempt_count + 1;
    end
    
    if attempt_count > max_attempts
        break
    end
        
    all_targets(i,:) = these_spots;
    all_distances(i,:) = distances';
    targets_cov = targets_cov_tmp;
    
    for k = 1:targs_per_stim
        this_loc = multitarg_locs(these_spots(k),:);

        precomp_ind = find(this_loc(1) == computed_locs(:,1) & ...
                          this_loc(2) == computed_locs(:,2));
        if ~isempty(precomp_ind)
            fullF = fullF + sqrt(spot_power_ratios(k))*exp(1i*singles_phases(:,:,precomp_ind));
        else
%             disp('not computed')
            decval = round(this_loc,-1);
            unitval = round(this_loc - decval);
%             dec_ind = find();
            convP = coarse_disks(:,:,disk_key(:,1) == decval(1) & disk_key(:,2) == decval(2)) + ...
                fine_spots(:,:,spot_key(:,1) == unitval(1) & spot_key(:,2) == unitval(2));
            convP(convP < -pi) = convP(convP < -pi) + 2*pi;
            convP(convP > pi) = convP(convP > pi) - 2*pi;
            fullF = fullF + sqrt(spot_power_ratios(k))*exp(1i*convP);
            singles_phases(:,:,num_singles+extra_phase) = convP;
            computed_locs(num_singles+extra_phase,:) = this_loc;
            extra_phase = extra_phase + 1;
        end
        stim_key(i,:,k) = round(this_loc);
        stim_key(i,:,k) = round(this_loc);
    end
%     spot_ind = spots_key(these_spots(max_spot_ind),[1 2])/20 + 9;
    
    convP = angle(fullF);% + diskPhase(:,:,2); already starting with disks now
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    phase_masks(i).pattern = convP;
    phase_masks(i).mode = 'Phase';
    
    full_spots = [];
    for m = 1:length(all_spots)
        if sum(all_targets(:) == all_spots(m)) > repeat_target-1
            full_spots = [full_spots m];
        end
    end
    all_spots(full_spots) = [];
%     length(all_spots)
    if length(all_spots) < 5
        break
    end

    
end
num_multi = i - 1;
phase_masks(i:num_stim) = [];
stim_key(i:num_stim,:,:) = [];
pockels_ratio_refs_multi(i:num_stim) = [];
if show_stats
    figure
%     good_stim = num_stim;
    all_targets = all_targets(1:num_multi,:);
    all_distances = all_distances(1:num_multi,:);
%     precomputed_target = precomputed_target(1:good_stim);
%     pockels_ratio_refs_multi = pockels_ratio_refs_multi(1:good_stim);

    % subplot(3,2,[1 2])
    % target_counts = histcounts(all_targets(:),.5:1:(num_spots+.5));
    % plot(target_counts)
    % xlabel('target id')
    % ylabel('times stimulated')
    % title('Target Counts')
    subplot(222)
    histogram(all_distances(:))
    xlabel('pairwise distance (um)')
    ylabel('counts')
    title('Target Distances')
    targets = zeros(num_multi_spots,num_multi);
    for i = 1:num_multi
        targets(all_targets(i,:),i) = targets(all_targets(i,:),i) + 1;
    end
    targets_cov = targets*targets';
    for i = 1:num_multi_spots
        targets_cov(i,i) = 0;
    end
    % figure; imagesc(targets_cov);
    subplot(223); histogram(targets_cov(:))
    xlabel('times paired')
    ylabel('count')
    title('Correlations in Stim Design')
    subplot(224); histogram(pockels_ratio_refs_multi(:))
    xlabel('Power Multiplier')
    ylabel('counts')
    title('Diffraction Loss Relative to Ref')
    stim_count = zeros(num_multi_spots,1);
    for i = 1:num_multi_spots
        stim_count(i) = sum(all_targets(:) == i);
    end
    subplot(221)
    histogram(stim_count)
    title('Target Stim Counts')
end

