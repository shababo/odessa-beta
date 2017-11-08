%%
this_trans = full_trans;
% generate individual spots
clear target
end_point = 150;
spacing = 10;
x_pos = -end_point:spacing:end_point;
% theta = 5.82;
% scale_vec = [-1.55 1.55 0];
target.mode = '3D spots';
target.wavelength = 1040;
target.numericalAperture = 1;
target.refractiveIndex = 1.33;
target.spotLocations = [];
tf_x_spots = zeros(600,792,length(x_pos));
tf_y_spots = zeros(600,792,length(x_pos));
% tf_fine_grid_spots_key = zeros(length(x_pos)^2,3);
% count = 1;

for i = 1:length(x_pos)
%     for j = 1:length(x_pos)
        this_spot = [x_pos(i)/image_um_per_px+image_zero_order_coord(1) 0/image_um_per_px+image_zero_order_coord(2) 1]'
        this_spot_slm = (this_trans*this_spot)'
        target.spotLocations = repmat([this_spot_slm 0],3,1);
        isTargetPatternReady = 1;
        pause(5)
        tf_x_spots(:,:,i) = P;
        
        this_spot = [0/image_um_per_px+image_zero_order_coord(1) x_pos(i)/image_um_per_px+image_zero_order_coord(2) 1]'
        this_spot_slm = (this_trans*this_spot)'
        target.spotLocations = repmat([this_spot_slm 0],3,1);
        isTargetPatternReady = 1;
        pause(5)
        tf_y_spots(:,:,i) = P;
%         tf_fine_grid_spots_key(count,:) = [x_pos(i) x_pos(j) 0];
%         count = count + 1;
%     end
end

% bad_phase = all(tf_all_spots_phase == 0,3);
% find(bad_phase)

%% 10um shift

this_trans = full_trans;
% generate individual spots
clear target

x_pos_fine = -5:1:5;
% theta = 5.82;
% scale_vec = [-1.55 1.55 0];
target.mode = '3D spots';
target.wavelength = 1040;
target.numericalAperture = 1;
target.refractiveIndex = 1.33;
target.spotLocations = [];
tf_x_spots_fine = zeros(600,792,length(x_pos_fine));
tf_y_spots_fine = zeros(600,792,length(x_pos_fine));
% tf_fine_grid_spots_key = zeros(length(x_pos)^2,3);
% count = 1;

for i = 1:length(x_pos_fine)
%     for j = 1:length(x_pos)
        this_spot = [x_pos_fine(i)/image_um_per_px+image_zero_order_coord(1) 0/image_um_per_px+image_zero_order_coord(2) 1]'
        this_spot_slm = (this_trans*this_spot)'
        target.spotLocations = repmat([this_spot_slm 0],3,1);
        isTargetPatternReady = 1;
        pause(5)
        tf_x_spots_fine(:,:,i) = P;
        
        this_spot = [0/image_um_per_px+image_zero_order_coord(1) x_pos_fine(i)/image_um_per_px+image_zero_order_coord(2) 1]'
        this_spot_slm = (this_trans*this_spot)'
        target.spotLocations = repmat([this_spot_slm 0],3,1);
        isTargetPatternReady = 1;
        pause(5)
        tf_y_spots_fine(:,:,i) = P;
%         tf_fine_grid_spots_key(count,:) = [x_pos(i) x_pos(j) 0];
%         count = count + 1;
%     end
end


%% keep grid structure

% tf_phase = tf_x_spots;
% notf_phase = notf_all_spots_phase;
diskPhaseLocal = diskPhase(:,:,1);
tic
target_base_fast.mode = 'Phase';
target_base_fast.pattern = 1040;
% num_spots = size(tf_phase,3);
clear tf_precomputed_target
clear tf_disk_grid
clear notf_precomputed_target
clear tf_stim_key
% x_pos = -150:10:150;
num_spots = length(x_pos)
tf_disk_grid = zeros(600,792,num_spots*num_spots);
% center = [ceil(sqrt(num_spots)/2) ceil(sqrt(num_spots)/2)];
% steps_from_center = center-1;
% linear_ind = find(tf_spots_key(:,1) == 60 & tf_spots_key(:,2) == 60);
% [center(1), center(2)] = ind2sub([sqrt(size(tf_spots_key,1)) sqrt(size(tf_spots_key,1))],linear_ind);
% steps_from_center = 4;
% spacing = 20;
clear tf_disk_precomputed_target

order = [];
% tf_disk_precomputed_target(size(tf_all_spots_phase,3)) = struct();
tf_disk_key = zeros(num_spots*num_spots,3);
count = 1;

for i = 1:num_spots
    for j = 1:num_spots

    convP = tf_x_spots(:,:,i) + tf_y_spots(:,:,j);
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    convP = convP +  + diskPhaseLocal;
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    tf_disk_precomputed_target(count).pattern = convP;
    tf_disk_precomputed_target(count).mode = 'Phase';
    tf_disk_grid(:,:,count) = convP;
    tf_disk_key(count,1) = x_pos(i);
    tf_disk_key(count,2) = x_pos(j);
    count = count+1;
    end
end
tf_stim_key = tf_disk_key;

toc
clear tf_phase

%%

% diskPhaseLocal = diskPhase(:,:,1);
tic
target_base_fast.mode = 'Phase';
target_base_fast.pattern = 1040;
% num_spots = size(tf_phase,3);
% clear tf_precomputed_target
clear tf_fine_grid_spots_phase
% clear notf_precomputed_target
clear tf_fine_grid_spots_key
% x_pos = -150:10:150;
num_spots = length(x_pos_fine)
tf_fine_grid_spots_phase = zeros(600,792,num_spots*num_spots);
% center = [ceil(sqrt(num_spots)/2) ceil(sqrt(num_spots)/2)];
% steps_from_center = center-1;
% linear_ind = find(tf_spots_key(:,1) == 60 & tf_spots_key(:,2) == 60);
% [center(1), center(2)] = ind2sub([sqrt(size(tf_spots_key,1)) sqrt(size(tf_spots_key,1))],linear_ind);
% steps_from_center = 4;
% spacing = 20;
% clear tf_disk_precomputed_target

order = [];
% tf_disk_precomputed_target(size(tf_all_spots_phase,3)) = struct();
tf_fine_grid_spots_key = zeros(num_spots*num_spots,3);
count = 1;

for i = 1:num_spots
    for j = 1:num_spots

    convP = tf_x_spots_fine(:,:,i) + tf_y_spots_fine(:,:,j);
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
%     convP = convP +  + diskPhaseLocal;
%     convP(convP < -pi) = convP(convP < -pi) + 2*pi;
%     convP(convP > pi) = convP(convP > pi) - 2*pi;
%     tf_disk_precomputed_target(count).pattern = convP;
%     tf_disk_precomputed_target(count).mode = 'Phase';
    tf_fine_grid_spots_phase(:,:,count) = convP;
    tf_fine_grid_spots_key(count,1) = x_pos_fine(i);
    tf_fine_grid_spots_key(count,2) = x_pos_fine(j);
    count = count+1;
    end
end
% tf_stim_key = tf_disk_key;

toc
clear tf_phase

%%
stim_id = find(tf_disk_key(:,1) == 30 & tf_disk_key(:,2) == 30)
target.mode = 'Phase'; target.pattern = tf_disk_grid(:,:,stim_id);

isTargetPatternReady = 1;


%% keep grid structure

% tf_phase = tf_x_spots;
% notf_phase = notf_all_spots_phase;
% diskPhaseLocal = diskPhase(:,:,1);
tic
target_base_fast.mode = 'Phase';
target_base_fast.pattern = 1040;
% num_spots = size(tf_phase,3);
% clear tf_precomputed_target
clear tf_coarse_spot_grid
clear tf_coarse_spot_key
% x_pos = -150:10:150;
num_spots = length(x_pos)
tf_coarse_spot_grid = zeros(600,792,num_spots*num_spots);
% center = [ceil(sqrt(num_spots)/2) ceil(sqrt(num_spots)/2)];
% steps_from_center = center-1;
% linear_ind = find(tf_spots_key(:,1) == 60 & tf_spots_key(:,2) == 60);
% [center(1), center(2)] = ind2sub([sqrt(size(tf_spots_key,1)) sqrt(size(tf_spots_key,1))],linear_ind);
% steps_from_center = 4;
% spacing = 20;


order = [];
% tf_disk_precomputed_target(size(tf_all_spots_phase,3)) = struct();
tf_coarse_spot_key = zeros(num_spots*num_spots,3);
count = 1;

for i = 1:num_spots
    for j = 1:num_spots

    convP = tf_x_spots(:,:,i) + tf_y_spots(:,:,j);
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    tf_coarse_spot_grid(:,:,count) = convP;
    tf_coarse_spot_key(count,1) = x_pos(i);
    tf_coarse_spot_key(count,2) = x_pos(j);
    count = count+1;
    end
end


toc


%%

test_spots = [randi(300,10,1) randi(300,10,1)] - 150


for i = 1:size(test_spots,1)
    
    fullF = zeros(600,792);
    
    this_loc = test_spots(i,:);

    decval = round(this_loc,-1);
    unitval = round(this_loc - decval);
%             dec_ind = find();
    convP = tf_coarse_spot_grid(:,:,tf_coarse_spot_key(:,1) == decval(1) & tf_coarse_spot_key(:,2) == decval(2)) + ...
        tf_fine_grid_spots_phase(:,:,tf_fine_grid_spots_key(:,1) == unitval(1) & tf_fine_grid_spots_key(:,2) == unitval(2));
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;

    target.pattern = convP;
    target.mode = 'Phase';
    
     isTargetPatternReady = 1;
%     pause(3)
%     isSnapImage = 1;
%     pause(1)
    wrndlg = warndlg('Hole made?');
    pos = get(wrndlg,'position');
    set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
    waitfor(wrndlg)
    isSnapImage = 1
    pause(1)
    
end

isTargetPatternReady = 1;

%%

multitarg_locs = [];
single_spot_locs = [10 10 0
                    15 15 0
                    20 20 0
                    25 25 0
                    -10 10 0
                    -15 15 0
                    -20 20 0
                    -25 25 0
                    10 -10 0
                    15 -15 0
                    20 -20 0
                    25 -25 0
                    -10 -10 0
                    -15 -15 0
                    -20 -20 0
                    -25 -25 0];
                
num_rand = 100;
for i = 1:num_rand
    single_spot_locs(end+1,:) = [randi([-150 150],[1 2]) 0];
end

targs_per_stim = 3;
repeat_target = 10;
num_stim = size(multitarg_locs,1)*ceil(repeat_target/targs_per_stim);

% ratio_map = pockels_ratio_refs_tf_full_map;
% coarse_disks = tf_disk_grid;
% tf_disk_key;
% fine_spot_grid = evalin('base','_tf_fine_grid_spots_phase');
% fine_spot_key = evalin('base','tf_fine_grid_spots_key');
do_target = 1;

[phase_masks_target,stim_key,pockels_ratio_refs_multi] = ...
    build_multi_loc_phases(multitarg_locs,num_stim,single_spot_locs,...
    targs_per_stim,repeat_target,tf_disk_grid,tf_disk_key,power_map_upres,...
    tf_fine_grid_spots_phase,tf_fine_grid_spots_key,do_target,1);
pockels_ratio_refs_tf = pockels_ratio_refs_multi;
tf_stim_key = stim_key;
precomputed_target = phase_masks_target;