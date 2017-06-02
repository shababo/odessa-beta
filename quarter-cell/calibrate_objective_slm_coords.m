
% base hologram
target.mode = '3D spots';
target.refractiveIndex = 1.33;
target.numericalAperature = 1.0;
% target.radius = 2;
% target.x = 30;
% target.y = 30;
% target.relative_power_density = 1;
target.wavelength = 1040;

% target.theoretical_diffraction_correction = 0;
% starting_point = [0 0];
% move1 = [-120 40];
% move2 = [-50 -90];
% move3 = [100 -125];
% points = [0 0;
%           -120 40;
%           -50 -90;
%           100 -125;
%           150 130;
%           -175 -105;
%           25 50]';
points = [0 0;
          280 175;
          130 135;
          50 35;
          260 -155
          135 -140;
          80 -65;
          -280 -175;
          -130 -125;
          -50 -65;
          -260 155;
          -130 135;
          -75 55]';
% points = [130 135;
%           50 35;
%           135 -140;
%           80 -65;
%           -130 -125;
%           -50 -65;
%           -130 135;
%           -75 55]';
safety_point = [-500 -500 -500];

%       points = tf_obj_to_slm_trans*points;
% points = [0 0;
%           130 135;
%           0 0;
%           135 -140;
%           0 0;
%           -130 -125;
%           0 0;
%           -130 135;
%           0 0]';
% point2 = starting_point + move1;
% point3 = starting_point + move2;
% point4 = starting_point + move3;
% target.spotLocations = [starting_point; point2; point3];
% target.x = [starting_point(1) point2(1) point3(1)  point4(1)];
% target.y = [starting_point(2) point2(2) point3(2)  point4(2)];
% target.x = points(1,:);
% target.y = points(2,:);
% num_points = length(target.x);
% target.radius = 1*ones(1,num_points);
% target.relative_power_density = ones(1,num_points);

num_points = size(points,2);
for i = 11:num_points
%     this_spot = [x_pos(i) x_pos(j)]';
%     this_spot_slm = (this_trans*this_spot)';
    target.spotLocations = repmat([points(:,i)' 0],3,1);
    isTargetPatternReady = 1;
%     pause(3)
%     isSnapImage = 1;
%     pause(1)
    wrndlg = warndlg('Hole made?');
    waitfor(wrndlg)
    isSnapImage = 1
    pause(1)
end

%%
target.spotLocations = repmat([0 0 0],3,1);
isTargetPatternReady = 1;
pause(1)
% % test distance in um
% test_dist = 140;

% load reference point
% isTargetPatternReady = 1;
% pause(2)

% image ref point
% isSnapImage = 1;
% pause(1)


% target.radius = 1.5;
% target.relative_power_density = 1;
% target.x = 0;
% target.y = 0;
% isTargetPatternReady = 1;
% pause(2)
% move test_dist in y via slm
% target.y = target.y+test_dist;
% isTargetPatternReady = 1;
% pause(2)

% image new hologram
% isSnapImage = 1;
% pause(1)

% move back to ref point
% target.y = target.y-test_dist;
% isTargetPatternReady = 1;
% pause(2)

% image ref point
% isSnapImage = 1;
% pause(1);
% points = points';

points = [0 0;
          130 135;
          50 35;
          135 -140;
          80 -65;
          -130 -125;
          -50 -65;
          -130 135;
          -75 55
          0 0]';
      
x = -50:10:50;
count = 1;
for i = 1:length(x)
    for j = 1:length(x)
        points(1,count) = x(i);
        points(2,count) = x(j);
        count = count + 1;
    end
end
isGetStageLocation = 1;
pause(1)
curr_pos = [currentStageX currentStageY currentStageZ];
safety_point_rel = curr_pos + safety_point;

points_rel = bsxfun(@plus, points,curr_pos(1:2)');

% theNewX = curr_pos(1);
% theNewY = curr_pos(2);
% theNewZ = curr_pos(3);
% isMoveStageAbsolute = 1;
%     pause(5)
loc_order = randperm(size(points_rel,2));
% loc_order = 1:size(points_rel,2);

for ii = 1:10%size(points_rel,2)
% move in y via objective

    i = loc_order(ii);

    theNewX = safety_point_rel(1);
    theNewY = safety_point_rel(2);
    theNewZ = safety_point_rel(3);
    
    
    isMoveStageAbsolute = 1;
    pause(5)

    theNewY = curr_pos(2);
    theNewZ = curr_pos(3);
    theNewX = curr_pos(1);
    isMoveStageAbsolute = 1;
    pause(5)

%     deltaY = points(2,i);
%     deltaZ = 0;
%     deltaX = points(1,i);
%     isMoveStageRelative = 1;
%     pause(1)

    % image point
    isSnapImage = 1;
    pause(1)

    % move back to ref
%     deltaY = -points(2,i);
%     deltaZ = 0;
%     deltaX = -points(1,i);
%     isMoveStageRelative = 1;
%     % and image
%     pause(1)
% isSnapImage = 1;
end
% move in x via slm
% target.x = target.x+test_dist;
% isTargetPatternReady = 1;
% pause(2)

% image point
% isSnapImage = 1;
% pause(1)

% move back to ref
% target.x = target.x-test_dist;
% isTargetPatternReady = 1;
% pause(2)

% image ref
% isSnapImage = 1;
% pause(1);
% 
% % move in x via objective
% deltaY = move2(2);
% deltaZ = 0;
% deltaX = move2(1);
% isMoveStageRelative = 1;
% pause(1)
% % image it
% isSnapImage = 1;
% pause(1)
% 
% % move back
% deltaY = -move2(2);
% deltaZ = 0;
% deltaX = -move2(1);
% isMoveStageRelative = 1;
% pause(1)
% % image it
% % isSnapImage = 1;
% 
% % move in x via objective
% deltaY = move3(2);
% deltaZ = 0;
% deltaX = move3(1);
% isMoveStageRelative = 1;
% pause(1)
% % image it
% isSnapImage = 1;
% pause(1)
% 
% % move back
% deltaY = -move3(2);
% deltaZ = 0;
% deltaX = -move3(1);
% isMoveStageRelative = 1;
% pause(1)
% % image it
% isSnapImage = 1;
% 
% 
