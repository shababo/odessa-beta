[filename, pathname] = uigetfile({'*'});

obj_image = imread([pathname '\' filename]);

% [filename, pathname] = uigetfile({'*'});
% 
% slm_image = imread([pathname '\' filename]);
slm_image = obj_image;
%%
obj_image = FemtoPhasorR;
%%
obj_image = temp;
%%
% figure; imagesc(calib_image);
% axis image
% obj_image_adj = obj_image - min(obj_image(:));
% slm_image_adj = slm_image - min(slm_image(:));
% obj_image_adj = obj_image_adj/max(obj_image_adj(:))*10000;%adapthisteq(obj_image,'Distribution','rayleigh','numtiles',[32 32]);
% slm_image_adj = slm_image_adj/max(slm_image_adj(:))*10000;%adapthisteq(slm_image,'Distribution','rayleigh','numtiles',[32 32]);
% calib_image_adj = calib_image/max(calib_image(:))*5000;
% [objPoints,slmPoints] = cpselect(obj_image_adj,slm_image_adj,'wait',true);
% points(:,7) = [];
% points(:,end) = [];
figure; imagesc(obj_image)

[x, y] = ginput(size(points,2));
slmPoints = [x y];
slmPointsPointsFlip = slmPoints(:,[2 1]);
% slmPointsPointsFlip = slmPoints(:,[2 1]);

% slmPointsPointsFlipCenter = bsxfun(@minus,slmPointsPointsFlip,slmPointsPointsFlip(1,:))
% slmPointsPointsFlipCenter = bsxfun(@minus,slmPointsPointsFlip,slmPointsPointsFlip(1,:))
% 
%%

slm_to_obj_tform = fitgeotrans(objPointsFlipCenter,slmPointsPointsFlipCenter,'affine');
slm_to_obj_tform.T'

obj_to_slm_tform = slm_to_obj_tform.T(1:2,1:2)';
inv(obj_to_slm_tform)


%%

% core_points = [starting_point; point2; point3; point4]';
% points_click_order = [0 0 0 -150 150;
%           0 -150 150 0 0];
% points(:,end) = [];
points_vec = points(:);
slm_cam_points = [];
% obj_cam_points = [];
for i = 1:num_points
    slm_cam_points = [slm_cam_points;
                      slmPointsPointsFlipCenter(i,1) slmPointsPointsFlipCenter(i,2) 0 0;
                      0 0 slmPointsPointsFlipCenter(i,1) slmPointsPointsFlipCenter(i,2)];


%     obj_cam_points = [obj_cam_points;
%                       objPointsFlipCenter(i,1) objPointsFlipCenter(i,2) 0 0;
%                       0 0 objPointsFlipCenter(i,1) objPointsFlipCenter(i,2)];
              
end
          
slm_cam_trans = pinv(slm_cam_points*1.82) * points_vec;
slm_cam_trans_sq = reshape(slm_cam_trans,2,2)';
slm_cam_trans = inv(slm_cam_trans_sq);

% obj_cam_trans = pinv(obj_cam_points) * points_vec;
% obj_cam_trans_sq = reshape(obj_cam_trans,2,2)';
% obj_cam_trans = inv(obj_cam_trans_sq);



slmPointsPointsFlipCenter*1.82
(slm_cam_trans * points)'

inv(slm_cam_trans)*slm_cam_points(:,1:2)'

% objPointsFlipCenter
% (obj_cam_trans * points)'
% 
% inv(obj_cam_trans)*obj_cam_points(:,1:2)'


full_trans = inv(slm_cam_trans)


%% full affine

% points_offset = [points; zeros(1,size(points,2)];
num_points = size(points,2);
points_vec = points(:);
slmPointsPointsFlip_vec = slmPointsPointsFlip(:);
slm_cam_points = [];
test_mat = [];
% obj_cam_points = [];
for i = 1:num_points
    slm_cam_points = [slm_cam_points;
                      slmPointsPointsFlip(i,1) slmPointsPointsFlip(i,2) 1 0 0 0;
                      0 0 0 slmPointsPointsFlip(i,1) slmPointsPointsFlip(i,2) 1];
    test_mat(i,:) = [slmPointsPointsFlip(i,1) slmPointsPointsFlip(i,2) 1]';

%     obj_cam_points = [obj_cam_points;
%                       objPointsFlipCenter(i,1) objPointsFlipCenter(i,2) 0 0;
%                       0 0 objPointsFlipCenter(i,1) objPointsFlipCenter(i,2)];
              
end

full_trans_bu = full_trans
full_trans = slm_cam_points\points_vec;
full_trans = reshape(full_trans,3,2)'         
image_zero_order_coord_bu = image_zero_order_coord
image_zero_order_coord = inv(full_trans(:,[1 2]))*-full_trans(:,3)
points_zero = [points [0; 0]];
test_mat_zero = [test_mat; image_zero_order_coord' 1];
% full_trans_bu*test_mat' - full_trans*test_mat'

points - full_trans*test_mat'
points - full_trans_bu*test_mat'
% points_zero - full_trans_bu*test_mat_zero'
% points_zero - full_trans*test_mat_zero'

% inv(full_trans)*points
% slm_cam_trans = pinv(slm_cam_points) * points_vec;
% slm_cam_trans_sq = reshape(slm_cam_trans,3,2)';
% slm_cam_trans = inv(slm_cam_trans_sq);

% obj_cam_trans = pinv(obj_cam_points) * points_vec;
% obj_cam_trans_sq = reshape(obj_cam_trans,2,2)';
% obj_cam_trans = inv(obj_cam_trans_sq);



% slmPointsPointsFlipCenter*1.82
% (slm_cam_trans * points)'
% 
% inv(slm_cam_trans)*slm_cam_points(:,1:2)'

% objPointsFlipCenter
% (obj_cam_trans * points)'
% 
% inv(obj_cam_trans)*obj_cam_points(:,1:2)'


% full_trans = inv(slm_cam_trans)

%%
test_spots = test_spots';
num_points = size(test_spots,2);

slm_cam_points = [];
test_mat = [];
% obj_cam_points = [];
for i = 1:num_points
    slm_cam_points = [slm_cam_points;
                      slmPointsPointsFlip(i,1) slmPointsPointsFlip(i,2) 1 0 0 0;
                      0 0 0 slmPointsPointsFlip(i,1) slmPointsPointsFlip(i,2) 1];
    test_mat(i,:) = [slmPointsPointsFlip(i,1) slmPointsPointsFlip(i,2) 1]';

%     obj_cam_points = [obj_cam_points;
%                       objPointsFlipCenter(i,1) objPointsFlipCenter(i,2) 0 0;
%                       0 0 objPointsFlipCenter(i,1) objPointsFlipCenter(i,2)];
              
end

% full_trans_bu = full_trans
% full_trans = slm_cam_points\points_vec;
% full_trans = reshape(full_trans,3,2)'         
% 
% image_zero_order_coord = inv(full_trans(:,[1 2]))*-full_trans(:,3)
% 
% full_trans_bu*test_mat' - full_trans*test_mat'

test_holes_px = bsxfun(@minus,slmPointsPointsFlip,image_zero_order_coord')'
test_holes_um = test_holes_px*1.89

test_spots - test_holes_um'

%%

core_points = [starting_point; point2; point3; point4]';
points_vec = core_points(:);

slm_cam_points = [slmPointsPointsFlipCenter(1,1) slmPointsPointsFlipCenter(1,2);
                slmPointsPointsFlipCenter(1,2) -slmPointsPointsFlipCenter(1,1);
                slmPointsPointsFlipCenter(2,1) slmPointsPointsFlipCenter(2,2);
                slmPointsPointsFlipCenter(2,2) -slmPointsPointsFlipCenter(2,1);
                slmPointsPointsFlipCenter(3,1) slmPointsPointsFlipCenter(3,2);
                slmPointsPointsFlipCenter(3,2) -slmPointsPointsFlipCenter(3,1);
                slmPointsPointsFlipCenter(4,1) slmPointsPointsFlipCenter(4,2);
                slmPointsPointsFlipCenter(4,2) -slmPointsPointsFlipCenter(4,1)];

obj_cam_points = [objPointsFlipCenter(1,1) objPointsFlipCenter(1,2);
                  objPointsFlipCenter(1,2) -objPointsFlipCenter(1,1);
              objPointsFlipCenter(2,1) objPointsFlipCenter(2,2);
              	objPointsFlipCenter(2,2) -objPointsFlipCenter(2,1);
              objPointsFlipCenter(3,1) objPointsFlipCenter(3,2);
              	objPointsFlipCenter(3,2) -objPointsFlipCenter(3,1);
              objPointsFlipCenter(4,1) objPointsFlipCenter(4,2);
              	objPointsFlipCenter(4,2) -objPointsFlipCenter(4,1)];
          
slm_cam_trans = pinv(slm_cam_points) * points_vec;
slm_cam_trans_sq = [slm_cam_trans [-slm_cam_trans(2); slm_cam_trans(1)]];
slm_cam_trans_sq = inv(slm_cam_trans_sq(1:2,1:2))
obj_cam_trans = pinv(obj_cam_points) * points_vec;
obj_cam_trans_sq = reshape(obj_cam_trans,3,2)';
obj_cam_trans_sq = obj_cam_trans_sq(1:2,1:2)

full_trans = slm_cam_trans_sq*obj_cam_trans_sq
full_trans = inv(full_trans)

slmPointsPointsFlipCenter
(slm_cam_trans_sq * core_points)'

objPointsFlipCenter
(obj_cam_trans_sq * core_points)'

%%
[filename, pathname] = uigetfile({'*'});

calib_image = imread([pathname '\' filename]);
figure; imagesc(calib_image);
axis image
[spot_x, spot_y] = ginput(5);
% test_dist = 100;

ref_spot = [spot_x(1); spot_y(1)];
obj_1_spot = [spot_x(2); spot_y(2)];
obj_2_spot = [spot_x(3); spot_y(3)];
slm_1_spot = [spot_x(4); spot_y(4)];
slm_2_spot = [spot_x(5); spot_y(5)];

x_side_a = norm(obj_1_spot - slm_1_spot);
x_side_b = norm(obj_1_spot - ref_spot);
x_side_c = norm(slm_1_spot - ref_spot);

y_side_a = norm(obj_2_spot - slm_2_spot);
y_side_b = norm(obj_2_spot - ref_spot);
y_side_c = norm(slm_2_spot - ref_spot);

% law of cosines, bitches
x_theta_a = acos((x_side_b^2 + x_side_c^2 - x_side_a^2)/(2*x_side_b*x_side_c))
y_theta_a = pi - acos((y_side_b^2 + y_side_c^2 - y_side_a^2)/(2*y_side_b*y_side_c))

x_side_b/x_side_c
y_side_b/y_side_c
