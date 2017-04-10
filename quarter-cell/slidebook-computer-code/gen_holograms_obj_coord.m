theta = -5.82;
scale_vec = [-1.55 1.55];
% scale_vec = [1 1];

grid_max = 160;
spacing = 5;
x_pos = -grid_max:spacking:grid_max;
y_pos = -grid_max:spacing:grid_max;
key_table = zeros(length(x_pos)*length(y_pos),3);
all_phase_masks = zeros(600,792,size(key_table,1));

% base hologram
target.mode = 'Disks';
target.wavelength = 1040;
radius = 11;
target.relative_power_density = 1;


for i = 1:length(x_pos)
    for j = 1:length(y_pos)
        slm_pos = get_slm_position(scale_vec,theta,[x_pos(i); y_pos(i)]);
        target.x = slm_pos(1); target.y = slm_pos(2);
        target.relative_power_density = 1;
    end
end


num_targets = size(obj_pos,2);
target.radius = radius*ones(1,num_targets);
target.x = slm_pos(1,:);
target.y = slm_pos(2,:);
target.relative_power_density = [1 1 1 1];
