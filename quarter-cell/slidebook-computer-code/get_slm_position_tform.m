function [slm_pos] = get_slm_position_tform(tform,obj_pos)

% rot_mat = rotz(theta);
% rot_mat = rot_mat(1:2,1:2);
% rot_scale_mat = bsxfun(@times,rot_mat',scale_vec);

slm_pos = tform*obj_pos;