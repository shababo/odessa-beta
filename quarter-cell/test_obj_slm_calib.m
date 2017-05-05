
% scale_vec = [1 1];

% slm_obj_notf_tform = tform.T(1:2,1:2)';
this_trans = twophoton_slm_trans;
grid_max = 100

% obj_pos = grid_max*[-1 -1 1 1 -.5 -.5 .5 .5; 1 -1 1 -1 .5 -.5 .5 -.5];
obj_pos = grid_max*[-1 -1 1 1; 1 -1 1 -1];
% slm_pos = rot_scale_mat = bsxfun(@times,rot_mat',scale_vec);(scale_vec,theta,obj_pos);
slm_pos = this_trans*obj_pos;
% base hologram
% target.mode = 'Disks';
% target.wavelength = 1040;
% radius = 3;
% num_targets = size(obj_pos,2);
% target.radius = radius*ones(1,num_targets);
for i = 1:size(slm_pos,2)
    target.spotLocations = repmat([slm_pos(1,i) slm_pos(2,i) 0],3,1);
    isTargetPatternReady = 1;
    pause(1)

    h = warndlg('Image Taken?');
    waitfor(h)
end


isTargetPatternReady = 1;
pause(2)
%%
isSnapImage = 1;
pause(1)

% move in y via objective
deltaY = grid_max*2;
deltaZ = 0;
deltaX = 0;
isMoveStageRelative = 1;
pause(1)

isSnapImage = 1;
pause(1)

deltaY = -grid_max*2;
deltaZ = 0;
deltaX = 0;
isMoveStageRelative = 1;
pause(1)


% move in y via objective
deltaY = 0;
deltaZ = 0;
deltaX = grid_max*2;
isMoveStageRelative = 1;
pause(1)

isSnapImage = 1;
pause(1)

deltaY = 0;
deltaZ = 0;
deltaX = -grid_max*2;
isMoveStageRelative = 1;
pause(1)


%%
% move in y via objective
deltaY = -grid_max*2;
deltaZ = 0;
deltaX = 0;
isMoveStageRelative = 1;
pause(1)

isSnapImage = 1;
pause(1)

%%
theta = 6.4;
scale_vec = [-1.58 1.51];
target.mode = '3D spots';
target.numericalAperature = 1.0;
target.refractiveIndex = 1.33;
% target.radius = 2;
% target.x = 30;
% target.y = 30;
% target.relative_power_density = 1;
target.wavelength = 1040;
starting_point = [20 20];
move1 = [-120 0];
move2 = [0 120];
point2 = [starting_point' + get_slm_position(scale_vec,theta,move1); 0]';
point3 = [starting_point' + get_slm_position(scale_vec,theta,move2); 0]';
starting_point_slm = [starting_point 0];
point2_slm = point2;
point3_slm = point3;
target.spotLocations = [starting_point_slm; point2_slm; point3_slm];
isTargetPatternReady = 1;
pause(10)

isSnapImage = 1;
pause(1)

deltaY = 120;
deltaZ = 0;
deltaX = 0;
isMoveStageRelative = 1;
pause(1)

isSnapImage = 1;
pause(1)

deltaY = -120;
deltaZ = 0;
deltaX = 0;
isMoveStageRelative = 1;
pause(1)

isSnapImage = 1;
pause(1)

deltaY = 0;
deltaZ = 0;
deltaX = -120;
isMoveStageRelative = 1;
pause(1)

isSnapImage = 1;
pause(1)

deltaY = 0;
deltaZ = 0;
deltaX = 120;
isMoveStageRelative = 1;
pause(1)

isSnapImage = 1;
pause(1)