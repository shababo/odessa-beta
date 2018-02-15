%% MAKE DISKS AT CORNERS FOR CALIBRATION
diskRadii = 5*1.5;
clear target
target.radius = diskRadii*ones(1,4);
target.mode = 'Disks';
target.wavelength = 1040;
target.relative_power_density = ones(1,4);
x = 200;
target.x = [-x -x x x]; target.y = [-x x -x x];

for i = 1:length(diskRadii)
    target.radius(i) = diskRadii(i);
    isTargetPatternReady = 1;
%     pause(5)
    diskPhase(:,:,i) = P;
    
end

%% MAKE DISK
diskRadii = [5]*1.5;
clear target
target.radius = 1;
target.mode = 'Disks';
target.wavelength = 1040;
target.relative_power_density = 1;
target.x = 0; target.y = 0;

for i = 1:length(diskRadii)
    target.radius = diskRadii(1);
    isTargetPatternReady = 1;
%     pause(5)
    diskPhase(:,:,i) = P;
    
end

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
diskPhaseLocal = diskPhase;
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

%% keep grid structure - SPOTS ONLY - NO DISK

% tf_phase = tf_x_spots;
% notf_phase = notf_all_spots_phase;
diskPhaseLocal = diskPhase;
tic
target_base_fast.mode = 'Phase';
target_base_fast.pattern = 1040;
% num_spots = size(tf_phase,3);
% clear tf_precomputed_target
% clear tf_disk_grid
% clear notf_precomputed_target
% clear tf_stim_key
% x_pos = -150:10:150;
num_spots = length(x_pos)
tf_spot_grid = zeros(600,792,num_spots*num_spots);
% center = [ceil(sqrt(num_spots)/2) ceil(sqrt(num_spots)/2)];
% steps_from_center = center-1;
% linear_ind = find(tf_spots_key(:,1) == 60 & tf_spots_key(:,2) == 60);
% [center(1), center(2)] = ind2sub([sqrt(size(tf_spots_key,1)) sqrt(size(tf_spots_key,1))],linear_ind);
% steps_from_center = 4;
% spacing = 20;
clear tf_spot_precomputed_target

order = [];
% tf_disk_precomputed_target(size(tf_all_spots_phase,3)) = struct();
tf_spot_key = zeros(num_spots*num_spots,3);
count = 1;

for i = 1:num_spots
    for j = 1:num_spots

    convP = tf_x_spots(:,:,i) + tf_y_spots(:,:,j);
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
%     convP = convP +  + diskPhaseLocal;
%     convP(convP < -pi) = convP(convP < -pi) + 2*pi;
%     convP(convP > pi) = convP(convP > pi) - 2*pi;
    tf_spot_precomputed_target(count).pattern = convP;
    tf_spot_precomputed_target(count).mode = 'Phase';
    tf_spot_grid(:,:,count) = convP;
    tf_spot_key(count,1) = x_pos(i);
    tf_spot_key(count,2) = x_pos(j);
    count = count+1;
    end
end
tf_spot_stim_key = tf_spot_key;

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

%% make disk
clear target
stim_id = find(tf_disk_key(:,1) == 60 & tf_disk_key(:,2) == 0)
target.mode = 'Phase'; target.pattern = tf_disk_grid(:,:,stim_id);

isTargetPatternReady = 1;

%% make spot
clear target
stim_id = find(tf_spot_key(:,1) == 150 & tf_spot_key(:,2) ==30)
target.mode = 'Phase'; target.pattern = tf_spot_grid(:,:,stim_id);

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


%%

spots_to_measure = [0:10:150; ones(size(0:10:150))*80];
% clear precomputed_target
pause(10)
for i = 1:size(spots_to_measure,2)
    spots_to_measure(:,i)
    stim_id = find(tf_disk_key(:,1) == spots_to_measure(1,i) & tf_disk_key(:,2) == spots_to_measure(2,i))
    target.mode = 'Phase'; target.pattern = tf_disk_grid(:,:,stim_id);
    isTargetPatternReady = 1;
    pause(1);
end

% isTargetPatternReady = 1;

%% MAKE ALIGNMENT HOLOGRAM

fullF = single(zeros(600,792)); 
x = 10;
locs = [-x -x 0
%         -x 0 0
%         x 0 0
%         0 -x 0
%         0 x 0
        -x x 0
        x -x 0
        x x 0];
for k =  1:size(locs,1)

    this_loc = locs(k,:);

    decval = round(this_loc,-1);
    unitval = round(this_loc - decval);

    convP = tf_disk_grid(:,:,tf_disk_key(:,1) == decval(1) & ...
                                                 tf_disk_key(:,2) == decval(2));
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    fullF = fullF + exp(1i*convP);
end
convP = angle(fullF);
convP(convP < -pi) = convP(convP < -pi) + 2*pi;
convP(convP > pi) = convP(convP > pi) - 2*pi;

target.mode = 'Phase';
target.pattern = double(convP);

isTargetPatternReady = 1;

%% take image of each holo at z = 0

points = -150:10:150;
for i = 1:length(points)
    for j = 1:length(points)
        
        stim_id = find(tf_disk_key(:,1) == points(i) & tf_disk_key(:,2) == points(j));
        target = precomputed_target(stim_id);
        isTargetPatternReady = 1;
        pause(1)

        isSnapImage = 1;
        pause(1)
    
    end
end

%% take stack of each holo

points = -150:50:150;
for i = 1:length(points)
    for j = 1:length(points)
        
        stim_id = find(tf_disk_key(:,1) == points(i) & tf_disk_key(:,2) == points(j));
        target = precomputed_target(stim_id);
        isTargetPatternReady = 1;
        pause(1)

        take_stack
        pause(13)
    
    end
end

%% take stack of each holo list

loc_inds = [543   537   359   736   224    61];
for i = 1:length(loc_inds)
        
        stim_id = loc_inds(i);
        target = precomputed_target(stim_id);
        isTargetPatternReady = 1;
        pause(1)

        take_stack
        pause(20)
    
    
end

%% take stack of each holo list

loc_inds = [543   537   359   736   224    61];
for i = 4%length(loc_inds)
        
        stim_id = loc_inds(i)
        target.mode = 'Phase'; target.pattern = tf_disk_grid(:,:,stim_id);
        isTargetPatternReady = 1;
        pause(1)
        
        wrndlg = warndlg('Hole made?');
        pos = get(wrndlg,'position');
        set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
        waitfor(wrndlg)
%         take_stack
%         pause(20)
    
    
end
%%
loc_inds = [543   537   359   736   224    61];

for i = 1% 1:length(loc_inds)
    stim_id = loc_inds(i);%find(tf_spot_key(:,1) == -140 & tf_spot_key(:,2) == 140)
    target.mode = 'Phase'; target.pattern = tf_spot_grid(:,:,stim_id);

    isTargetPatternReady = 1;
    
    wrndlg = warndlg('Hole made?');
    pos = get(wrndlg,'position');
    set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
    waitfor(wrndlg)
    isSnapImage = 1
    pause(1)
end

%%

spatial_targets = [
    80    72     0
    53    72     0
   105    71     0
    81    47     0
    81    96     0];

% x = 34;
% spatial_targets = [-x -x 0
% %         -x 0 0
% %         x 0 0
% %         0 -x 0
% %         0 x 0
%         -x x 0
%         x -x 0
%         x x 0];

spatial_targets = [
    -100    100     0
    100    100     0
    100    -100     0
    -100    -100     0];


for i = 1:size(spatial_targets,1)

    fullF = single(zeros(600,792)); 
    
    this_loc = spatial_targets(i,1:2);

    decval = round(this_loc,-1);
    unitval = round(this_loc - decval);

    convP = tf_spot_grid(:,:,tf_spot_key(:,1) == decval(1) & ...
                                                                 tf_spot_key(:,2) == decval(2)) + ...
                            tf_fine_grid_spots_phase(:,:,tf_fine_grid_spots_key(:,1) == unitval(1) & ...
                                                                 tf_fine_grid_spots_key(:,2) == unitval(2));
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    fullF = fullF + exp(1i*convP);

    convP = angle(fullF);
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;

    target.mode = 'Phase';
    target.pattern = double(convP);

    isTargetPatternReady = 1;
    
    wrndlg = warndlg('Hole made?');
    pos = get(wrndlg,'position');
    set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
    waitfor(wrndlg)
    isSnapImage = 1
    pause(1)
end

%% 

first_image = images{end};
second_image = temp;

figure
subplot(131)
imagesc(first_image)
subplot(132)
imagesc(second_image)
subplot(133)
imagesc(first_image - second_image)

%%

% spatial_targets = [
%     80    72     0
%     105    71     0
%     53    72     0
%     81    47     0
%     81    96     0];

spatial_targets = [
    -100    100     0
    100    100     0
    100    -100     0
    -100    -100     0];

clear precomputed_target

for i = 1:size(spatial_targets,1)
        
        this_loc = spatial_targets(i,1:2);
        fullF = single(zeros(600,792)); 
    
    this_loc = spatial_targets(i,1:2);

    decval = round(this_loc,-1);
    unitval = round(this_loc - decval);

    convP = tf_disk_grid(:,:,tf_disk_key(:,1) == decval(1) & ...
                                                                 tf_disk_key(:,2) == decval(2)) + ...
                            tf_fine_grid_spots_phase(:,:,tf_fine_grid_spots_key(:,1) == unitval(1) & ...
                                                                 tf_fine_grid_spots_key(:,2) == unitval(2));
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    fullF = fullF + exp(1i*convP);

    convP = angle(fullF);
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;

    precomputed_target(i).mode = 'Phase';
    precomputed_target(i).pattern = double(convP);

     
end
