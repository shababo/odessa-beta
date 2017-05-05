all_phase_masks = zeros(600,792,length(all_targets));

for i = 1:length(all_targets)
    i
    target = all_targets(i);
    isTargetPatternReady = 1;
    pause(1.0)
    all_phase_masks(:,:,i) = P;
    
end

%%

precomputed_target = struct();
for i = 1:length(all_targets)
    precomputed_target(i).mode = 'Phase';
    precomputed_target(i).pattern = all_phase_masks(:,:,i);
end

%%

x_pos = -160:5:160;
y_pos = x_pos;

% [X_pos, Y_pos] = meshgrid(x_pos,y_pos);

N = 50;
K = 4;
% compute N disks
radius = 6.67;
target_base_disk.mode = 'Disks';
target_base_disk.wavelength = 1040;
target_base_disk.radius = radius*ones(1,K);
target_base_disk.relative_power_density = ones(1,K);
target_base_disk.x = 0; target_base_disk.y = 0;
clear precomputed_target
for i = 1:N
    
    precomputed_target(i) = target_base_disk;
    precomputed_target(i).x = x_pos(randsample(1:length(x_pos),K));
    precomputed_target(i).y = y_pos(randsample(1:length(y_pos),K));
    
end
% tic
isPrecomputedTargetArrayReady = 1
% pause(2)
% while any(isPrecomputedHologramReady == 0)
% end
% disks_time = toc
 
% compute N disks
clear target_base_spots
target_base_spots.mode = '3D spots';
target_base_spots.wavelength = 1040;
target_base_spots.numericalAperture = 1;
target_base_spots.refractiveIndex = 1.33;
target_base_spots.spotLocations = [];
clear precomputed_target spotLocations
for i = 1:N
    
    precomputed_target(i) = target_base_spots;
    spotLocations(:,1) = x_pos(randsample(1:length(x_pos),K))';
    spotLocations(:,2) = y_pos(randsample(1:length(y_pos),K))';
    spotLocations(:,3) = zeros(K,1);
    precomputed_target(i).spotLocations = spotLocations;
end

% tic
isPrecomputedTargetArrayReady = 1
% disks_time = toc 

%%
this_trans = twophoton_slm_trans_new;
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
tf_all_spots_phase = zeros(600,792,length(x_pos)^2);
tf_spots_key = zeros(length(x_pos)^2,3);
count = 1;
for i = 1:length(x_pos)
    for j = 1:length(x_pos)
        this_spot = [x_pos(i) x_pos(j)]';
        this_spot_slm = (this_trans*this_spot)';
        target.spotLocations = repmat([this_spot_slm 0],3,1);
        isTargetPatternReady = 1;
        pause(5)
        tf_all_spots_phase(:,:,count) = P;
        tf_spots_key(count,:) = [x_pos(i) x_pos(j) 0];
        count = count + 1;
    end
end

%% MAKE DISK
diskRadii = [5 7.5 10]*1.5;

target.radius = 1;
target.mode = 'Disks';
target.wavelength = 1040;
target.relative_power_density = 1;
target.x = 0; target.y = 0;

for i = 1:length(diskRadii)
    target.radius = diskRadii(i);
    isTargetPatternReady = 1;
    pause(5)
    diskPhase(:,:,i) = P;
    
end

%%
        
testP = angle(exp(1i*all_spots_phase(:,:,1)) + exp(1i*all_spots_phase(:,:,end)));

%% 
rng(123566)
tic
target_base_fast.mode = 'Phase';
target_base_fast.pattern = 1040;
% num_spots = size(all_spots_phase,3);
clear precomputed_target
N = 500;
K = 1;
max_use = 1;
% all_targets = zeros(N,3);
% all_distances = zeros(N,3);
% all_spots = 1:num_spots;
pockels_ratio_refs = Inf*ones(N,1);
% targets_cov = zeros(size(all_spots_phase,3)); 
for i = 1:N
    i
%     precomputed_target(i) = tf_precomputed_target(i);
    fullF = zeros(600,792);
    distances = 0;
    
    while any(distances <= 40) || pockels_ratio_refs(i) > 6
        these_spots = randsample(all_spots,K);
        distances = pdist(tf_spots_key(these_spots,:));
        
        if all(distances > 40) 
            spots_power = zeros(K,1);
            for k = 1:K
                spot_ind = tf_spots_key(these_spots(k),[1 2])/5 + ceil(size(power_map_tf,1)/2);
                spots_power(k) = power_map_tf(spot_ind(1),spot_ind(2));
            end
%             [max_pow,max_spot_ind] = max(spots_power);
            spot_power_ratios = round(power_map_tf(10,10)./spots_power*10000);
            pockels_ratio_refs(i) = sum(spot_power_ratios)/10000;
        end
        
        stim_vec = zeros(num_spots,1);
        stim_vec(these_spots) = 1;
        targets_cov_tmp = targets_cov + stim_vec*stim_vec';
        upper_targ = triu(targets_cov_tmp,1);
        if any(upper_targ(:) > 2)
            distances = zeros(K,1);
        end
    end
        
    all_targets(i,:) = these_spots;
    all_distances(i,:) = distances;
    targets_cov = targets_cov_tmp;
    for k = 1:K
        fullF = fullF + sqrt(spot_power_ratios(k))*exp(1i*all_spots_phase(:,:,these_spots(k)));
    end
%     spot_ind = spots_key(these_spots(max_spot_ind),[1 2])/20 + 9;
    
    convP = angle(fullF) + diskPhase;
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    precomputed_target(i).pattern = convP;
    
    full_spots = [];
    for m = 1:length(all_spots)
        if sum(all_targets(:) == all_spots(m)) > max_use
            full_spots = [full_spots m];
        end
    end
    all_spots(full_spots) = [];
    length(all_spots)
    
end
%%


%% compute fast holograms - USE THIS ONE 04/10/2017 BS
rng(123566)
tic
target_base_fast.mode = 'Phase';
target_base_fast.pattern = 1040;
num_spots = size(tf_disk_grid,3);
clear precomputed_target
N = 800;
K = 3;
max_use = 6;
all_targets = zeros(N,K);
all_distances = zeros(N,nchoosek(K,2));
all_spots = 1:num_spots;
pockels_ratio_refs_multi = Inf*ones(N,1);
targets_cov = zeros(num_spots); 
power_map_ref = 49;
precomputed_target(N) = target_base_fast;
for i = 1:N
    i
    precomputed_target(i) = target_base_fast;
    fullF = zeros(600,792);
    distances = 0;
    
    while any(distances <= 1) || pockels_ratio_refs_multi(i) > 6
        these_spots = randsample(all_spots,K);
        distances = pdist(tf_stim_key(these_spots,:));
        
        if all(distances > 40) 
            spots_power = zeros(K,1);
            for k = 1:K
%                 spot_ind = tf_spots_key(these_spots(k),[1 2])/5 + ceil(size(power_map_tf,1)/2);
                spots_power(k) = power_map(these_spots(k)); %power_map(spot_ind(1),spot_ind(2));
            end
%             [max_pow,max_spot_ind] = max(spots_power);
            spot_power_ratios = round(power_map(power_map_ref)./spots_power*10000);
            pockels_ratio_refs_multi(i) = sum(spot_power_ratios)/10000;
        end
        
        stim_vec = zeros(num_spots,1);
        stim_vec(these_spots) = 1;
        targets_cov_tmp = targets_cov + stim_vec*stim_vec';
        upper_targ = triu(targets_cov_tmp,1);
        if any(upper_targ(:) > 2)
            distances = zeros(K,1);
        end
    end
        
    all_targets(i,:) = these_spots;
    all_distances(i,:) = distances;
    targets_cov = targets_cov_tmp;
    for k = 1:K
        fullF = fullF + sqrt(spot_power_ratios(k))*exp(1i*tf_disk_grid(:,:,these_spots(k)));
    end
%     spot_ind = spots_key(these_spots(max_spot_ind),[1 2])/20 + 9;
    
    convP = angle(fullF);% + diskPhase(:,:,2); already starting with disks now
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
    precomputed_target(i).pattern = convP;
    
    full_spots = [];
    for m = 1:length(all_spots)
        if sum(all_targets(:) == all_spots(m)) > max_use-1
            full_spots = [full_spots m];
        end
    end
    all_spots(full_spots) = [];
    length(all_spots)
    
end
toc
pockels_ratio_refs_tf = pockels_ratio_refs_multi;
isPrecomputedTargetArrayReady = 1
% isTargetPatternReady = 1;
% pockels_value = get_voltage(lut,pockels_ratio_refs(N)*55)

%%
figure
good_stim = 800;
all_targets = all_targets(1:good_stim,:);
all_distances = all_distances(1:good_stim,:);
precomputed_target = precomputed_target(1:good_stim);
pockels_ratio_refs_multi = pockels_ratio_refs_multi(1:good_stim);

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
targets = zeros(num_spots,good_stim);
for i = 1:good_stim
    targets(all_targets(i,:),i) = targets(all_targets(i,:),i) + 1;
end
targets_cov = targets*targets';
for i = 1:num_spots
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
stim_count_map = zeros(sqrt(num_spots),sqrt(num_spots));
for i = 1:good_stim
    for k = 1:K
        inds = tf_stim_key(i,[1 2],k)/spacing + ceil(length(x_pos)/2);
        stim_count_map(inds(1),inds(2)) = stim_count_map(inds(1),inds(2)) + 1;
    end
end
subplot(221)
imagesc(stim_count_map)
colorbar
title('Target Stim Counts')

%%
tf_disk_key = tf_stim_key;
tf_stim_key = zeros(size(all_targets,1),3,size(all_targets,2));
for i = 1:size(all_targets,1)
    for k = 1:size(all_targets,2)
        tf_stim_key(i,:,k) = tf_disk_key(all_targets(i,k),:);
    end
end

%%
% tic
isPrecomputedTargetArrayReady = 1
pause(.5)
while any(isPrecomputedHologramReady == 0)
    pause(.1)
end
toc
%%

for i = 1:length(precomputed_target);
    target = precomputed_target(i);
    isTargetPatternReady = 1;
    pause(2)
%     isSnapImage = 1;
%     pause(2)
end

%%

% tf = memmapfile('tf_80x80a5_phase.mat','Format',{'double',[600 792 (80/5*2 + 1)^2],'phase'});
% notf = memmapfile('notf_80x80a5_phase.mat','Format',{'double',[600 792 (80/5*2 + 1)^2],'phase'});
% tf_phase = tf.Data.phase;
% notf_phase = notf.Data.phase;

tf_phase = tf_all_spots_phase;
notf_phase = notf_all_spots_phase;
% diskPhase = diskPhase
tic
target_base_fast.mode = 'Phase';
target_base_fast.pattern = 1040;
num_spots = size(tf_phase,3);
clear tf_precomputed_target
clear notf_precomputed_target
for i = 1:num_spots
    
%     tf_precomputed_target(i) = target_base_fast;
    tf_precomputed_target(i).mode = 'Phase';
    fullF = zeros(600,792);
    these_spots = i;
    for n = 1:1
        fullF = fullF + exp(1i*tf_phase(:,:,these_spots(n)));
    end
    convP = angle(fullF) + diskPhase(:,:,2);
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
%     convP = tf_phase(:,:,i);
    tf_precomputed_target(i).pattern = convP;
    
    notf_precomputed_target(i) = target_base_fast;
    fullF = zeros(600,792);
    these_spots = i;
    for n = 1:1
        fullF = fullF + exp(1i*notf_phase(:,:,these_spots(n)));
    end
    convP = angle(fullF) + diskPhase(:,:,2);
    convP(convP < -pi) = convP(convP < -pi) + 2*pi;
    convP(convP > pi) = convP(convP > pi) - 2*pi;
%     convP = notf_phase(:,:,i);
    notf_precomputed_target(i).pattern = convP;
end
% tic
% isPrecomputedTargetArrayReady = 1
% pause(.5)
% while any(isPrecomputedHologramReady == 0)
%     pause(.1)
% end
toc
%    

%%
precomputed_target = tf_precomputed_target;
isPrecomputedTargetArrayReady = 1

%%

stim_id = find(tf_stim_key(:,1) == 150 & tf_stim_key(:,2) == 40);
target = precomputed_target(stim_id);

stim_id = find(tf_spots_key(:,1) == 100 & tf_spots_key(:,2) == 100);
target = precomputed_target(1); target.pattern = tf_all_spots_phase(:,:,stim_id);
isTargetPatternReady = 1;


stim_id = find(tf_disk_key(:,1) == 60 & tf_disk_key(:,2) == -60);
target = precomputed_target(1); target.pattern = tf_disk_grid(:,:,stim_id);

isTargetPatternReady = 1;

%%
pockels_ratio_refs_tf = power_map_tf';
pockels_ratio_refs_tf = pockels_ratio_refs_tf(:);
pockels_ratio_refs_tf = pockels_ratio_refs_tf(tf_spots_key(:,1) == 30 & tf_spots_key(:,2) == 30)./pockels_ratio_refs_tf;

pockels_ratio_refs_notf = power_map_no_tf';
pockels_ratio_refs_notf = pockels_ratio_refs_notf(:);
pockels_ratio_refs_notf = pockels_ratio_refs_notf(tf_spots_key(:,1) == 30 & tf_spots_key(:,2) == 30)./pockels_ratio_refs_notf;
%%
target.mode = '3D spots';
target.wavelength = 1040;
target.numericalAperture = 1;
target.refractiveIndex = 1.33;
target.spotLocations = [];
% all_spots_phase = zeros(600,792,length(x_pos)^2);
% spots_key = zeros(length(x_pos)^2,3);
count = 1;
for i = 8
    for j = 10
        this_spot = [x_pos(i) x_pos(j)]';
        this_spot_slm = get_slm_position(scale_vec,theta,this_spot)';
        target.spotLocations = repmat([this_spot_slm 0],3,1);
        isTargetPatternReady = 1;
        pause(5)
%         all_spots_phase(:,:,count) = P;
%         spots_key(count,:) = [x_pos(i) x_pos(j) 0];
        count = count + 1;
    end
end

%%
tf_less_targets = tf_precomputed_target(1);
notf_less_targets = notf_precomputed_target(1);
spots_key_less = zeros(0,3);
count = 1;
for i = 1:length(tf_precomputed_target)
    if ~any(tf_spots_key(i,:) < 0 | mod(tf_spots_key(i,:),10))
        i
        notf_less_targets(count) = notf_precomputed_target(i);
        tf_less_targets(count) = tf_precomputed_target(i);
        spots_key_less(count,:) = tf_spots_key(i,:);
        count = count + 1;
    end
end

%% spiral out

tf_phase = tf_all_spots_phase;
% notf_phase = notf_all_spots_phase;
diskPhaseLocal = diskPhase(:,:,2);
tic
target_base_fast.mode = 'Phase';
target_base_fast.pattern = 1040;
num_spots = size(tf_phase,3);
clear tf_precomputed_target
clear tf_disk_grid
clear notf_precomputed_target
clear tf_stim_key
tf_disk_grid = zeros(600,792,size(tf_all_spots_phase,3));
% center = [ceil(sqrt(num_spots)/2) ceil(sqrt(num_spots)/2)];
linear_ind = find(tf_spots_key(:,1) == 60 & tf_spots_key(:,2) == 60);
[center(1), center(2)] = ind2sub([sqrt(size(tf_spots_key,1)) sqrt(size(tf_spots_key,1))],linear_ind);
steps_from_center = 4;
% spacing = 20;
avail = 1:num_spots;
count = 1;
order = [];
tf_precomputed_target(size(tf_all_spots_phase,3)) = struct();
for i = 0:steps_from_center
    
    for j = -i:i
        for k = -i:i
            this_ind = center +[j k];
            linear_ind = sub2ind([sqrt(num_spots) sqrt(num_spots)],...
                    this_ind(1),this_ind(2));
            if any(avail == linear_ind)
                order(count) = linear_ind;
%                 tf_precomputed_target(count) = target_base_fast;
                fullF = zeros(600,792);
                this_spot = linear_ind;

                fullF = fullF + exp(1i*tf_phase(:,:,this_spot));
                convP = angle(fullF) + diskPhaseLocal;
                convP(convP < -pi) = convP(convP < -pi) + 2*pi;
                convP(convP > pi) = convP(convP > pi) - 2*pi;
                tf_precomputed_target(count).pattern = convP;
                tf_precomputed_target(count).mode = 'Phase';
                tf_disk_grid(:,:,count) = convP;
                tf_stim_key(count,:) = tf_spots_key(linear_ind,:);
                
%                 notf_precomputed_target(count) = target_base_fast;
%                 fullF = zeros(600,792);
%                 fullF = fullF + exp(1i*notf_phase(:,:,this_spot));
%                 convP = angle(fullF) + diskPhaseLocal;
%                 convP(convP < -pi) = convP(convP < -pi) + 2*pi;
%                 convP(convP > pi) = convP(convP > pi) - 2*pi;
%                 notf_precomputed_target(count).pattern = convP;
%                 notf_stim_key(count,:) = notf_spots_key(linear_ind,:);
                
                avail = setdiff(avail,linear_ind);
                count = count + 1;
            end
        end
    end

end

tf_disk_grid(:,:,count:end) = [];
tf_precomputed_target(count:end) = [];
toc
clear tf_phase

%%

target_base.mode = 'Phase';
target_base.pattern = [];
phases_to_load = tf_disk_grid;
num_phases = size(phases_to_load,3);
precomputed_target(num_phases) = target_base;
for i = 1:size(phases_to_load,3)
    precomputed_target(i).mode = 'Phase';
    precomputed_target(i).pattern = phases_to_load(:,:,i);
end
clear phases_to_load

%%

target = target_base_fast;
fullF = zeros(600,792);
distances = 0;
these_spots(1) = find(tf_disk_key(:,1) == 150 & tf_disk_key(:,2) == 150);
these_spots(2) = find(tf_disk_key(:,1) == -150 & tf_disk_key(:,2) == 150);
these_spots(3) = find(tf_disk_key(:,1) == 150 & tf_disk_key(:,2) == -150);
these_spots(4) = find(tf_disk_key(:,1) == -150 & tf_disk_key(:,2) == -150);



spots_power = zeros(K,1);
for k = 1:length(these_spots)
%                 spot_ind = tf_spots_key(these_spots(k),[1 2])/5 + ceil(size(power_map_tf,1)/2);
    spots_power(k) = power_map(these_spots(k)); %power_map(spot_ind(1),spot_ind(2));
end
%             [max_pow,max_spot_ind] = max(spots_power);
spot_power_ratios = round(power_map(power_map_ref)./spots_power*10000);
pockels_ratio_refs_multi(i) = sum(spot_power_ratios)/10000;
spot_power_ratios = ones(size(these_spots));
for k = 1:length(these_spots)
    fullF = fullF + sqrt(spot_power_ratios(k))*exp(1i*tf_disk_grid(:,:,these_spots(k)));
end
%     spot_ind = spots_key(these_spots(max_spot_ind),[1 2])/20 + 9;

convP = angle(fullF);% + diskPhase(:,:,2); already starting with disks now
convP(convP < -pi) = convP(convP < -pi) + 2*pi;
convP(convP > pi) = convP(convP > pi) - 2*pi;
target.pattern = convP;

isTargetPatternReady = 1