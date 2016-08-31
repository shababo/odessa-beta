%%
target.mode = 'Disks';



target.radius = [5];



wait_time = 5;

for i = 1:10
    pause(wait_time)
    target.x = [50 -50];
    target.y = [50 50]
    target.relative_power_density = [2 4];
    isTargetPatternReady = 1;
    
    pause(wait_time)
    target.x = [50 -50];
    target.y = [50 50]
    target.relative_power_density = [4 2];
    isTargetPatternReady = 1;
    
    pause(wait_time)
    target.x = [-50 50];
    target.y = [-50 -50]
    target.relative_power_density = [2 4];
    isTargetPatternReady = 1;
    
    pause(wait_time)
    target.x = [-50 50];
    target.y = [-50 -50]
    target.relative_power_density = [4 2];
    isTargetPatternReady = 1;
end

%%
precomputed_target(1).mode = 'Disks';
precomputed_target(1).radius = [10 10];
precomputed_target(1).x = [50 -50];
precomputed_target(1).y = [50 50];
precomputed_target(1).relative_power_density = [2 4];
precomputed_target(1).wavelength = 1040;

precomputed_target(2) = precomputed_target(1);
precomputed_target(2).relative_power_density = [4 2];

precomputed_target(3) = precomputed_target(1);
precomputed_target(3).x = [-50 50];
precomputed_target(3).y = [-50 -50];

precomputed_target(4) = precomputed_target(3);
precomputed_target(4).relative_power_density = [4 2];

isPrecomputedTargetArrayReady = 1;

%%

wait_time = .5;
target.mode = 'Precomputed Hologram';

for i = 1:10
    pause(wait_time)
    target.index = 1;
    isTargetPatternReady = 1;
    
    pause(wait_time)
    target.index = 2;
    isTargetPatternReady = 1;
    
    pause(wait_time)
    target.index = 3;
    isTargetPatternReady = 1;
    
    pause(wait_time)
    target.index = 4;
    isTargetPatternReady = 1;
end

%%
target.mode = 'Disks';
target.relative_power_density = [1];
target.radius = [5];
target.x = -140; target.y = -140;
isTargetPatternReady = 1;

%%

x = 100;
target.x = [-x x -x x];
target.y = [-x x x -x];
target.relative_power_density = [2 2 2 2];
target.radius = [5 5 5 5];
isTargetPatternReady = 1;
%%
count = 1;
precomputed_target_base.mode = 'Disks';
precomputed_target_base.radius = 5;
precomputed_target_base.x = 0;
precomputed_target_base.y = 0;
precomputed_target_base.relative_power_density = 1;
precomputed_target_base.wavelength = 1040;

num_repeats = 1;
clear precomputed_target
for k = 1:num_repeats
for i = -140:35:140;
    for j = -140:35:140
        precomputed_target(count) = precomputed_target_base;
        precomputed_target(count).x = i;
        precomputed_target(count).y = j;
        count = count + 1;
    end
end
end
        
% order = randperm(count - 1);
order = 1:length(precomputed_target);

precomputed_target = precomputed_target(order);
% precomputed_target = precomputed_target(1);
% precomputed_target(1).x = -280;
% precomputed_target(1).y = -280;

% isPrecomputedTargetArrayReady = 1;

%%


%%

target_wattage = 5;
pockels_in = zeros(9,9);
power_predict = zeros(9,9);
power_error = zeros(9,9);

positions = -140:35:140;

for x = 1:length(positions)
    for y = 1:length(positions)
        
        %target_ind = find(power_curves_fit(:,x,y) > target_wattage,1,'first');
        [error, target_ind] = min(abs(power_curves_fit(:,x,y) - target_wattage));
        pockels_in(x,y) = voltages(target_ind);
        power_predict(x,y) = power_curves_fit(target_ind,x,y);
        power_error(x,y) = error;
    end
end
%%
figure;
subplot(131)
imagesc(pockels_in)
colorbar
subplot(132)
imagesc(power_predict)
colorbar
subplot(133)
imagesc(power_error)
colorbar

%%
sequence_base.start = 0;
sequence_base.duration = 2500;
sequence_base.power = 150;
sequence_base.filter_configuration = 'Femto Phasor';

start_time = 1000;
iti = 3000;
clear sequence
count = 1;
for k = 1:num_repeats
for x = 1:9
    for y = 1:9
        sequence(count) = sequence_base;
        sequence(count).start = start_time + (count-1)*iti;
%         sequence(count).power = floor(pockels_in(x,y)*100);
        count = count + 1;
    end
end
end

sequence = sequence(1)
isSequenceReady = 1
    
%%
%%
count = 1;
precomputed_target_base.mode = 'Disks';
precomputed_target_base.radius = [5 5 5];
precomputed_target_base.x = [0 50 100];
precomputed_target_base.y = [0 50 100];
precomputed_target_base.relative_power_density = [1 1 1];
precomputed_target_base.wavelength = 1040;

num_stims = 500;
positions = -140:35:140;

for k = 1:num_stims

        precomputed_target(count) = precomputed_target_base;
        precomputed_target(count).x = randsample(positions,3);
        precomputed_target(count).y = randsample(positions,3);
        count = count + 1;

end
        
order = randperm(count - 1);

precomputed_target = precomputed_target(order);

isPrecomputedTargetArrayReady = 1;



%%

sequence_base.start = 0;
sequence_base.duration = 5;
sequence_base.power = 100;
sequence_base.filter_configuration = 'Femto Phasor';

start_time = 1000;
iti = 100;

for i = 1:(count-1)
    sequence(i) = sequence_base;
    sequence(i).start = start_time + (i-1)*iti;
end

isSequenceReady = 1

