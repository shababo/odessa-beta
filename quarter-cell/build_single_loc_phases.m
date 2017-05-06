function [phase_masks,dec_ind] = build_single_loc_phases(locations,coarse_disks,disk_key,fine_spots,spot_key,do_target)
tic
slm_size = size(coarse_disks);
slm_size = slm_size([1 2]);
num_locs = size(locations,1);
if do_target
    phase_masks(num_locs).mode = 'Phase';
    phase_masks(num_locs).pattern = zeros(slm_size);
else
    phase_masks = zeros([slm_size num_locs]);
end
dec_ind = zeros(num_locs,1);
for i = 1:num_locs
    
    this_loc = locations(i,:);
    decval = round(this_loc,-1);
    unitval = round(this_loc - decval);
    dec_ind(i) = find(disk_key(:,1) == decval(1) & disk_key(:,2) == decval(2));
    convP = coarse_disks(:,:,dec_ind(i)) + ...
        fine_spots(:,:,spot_key(:,1) == unitval(1) & spot_key(:,2) == unitval(2));
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    if do_target
        phase_masks(i).mode = 'Phase';
        phase_masks(i).pattern = convP;
    else
        phase_masks(:,:,i) = convP;
    end
    
end
toc
