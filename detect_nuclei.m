function [nuclear_locs,fluor_vals,nuclear_locs_image_coord,plane_fit] = detect_nuclei(filename,varargin)

if ~isempty(varargin) && ~isempty(varargin{1})
    image_um_per_px = varargin{1};
else
    image_um_per_px = 1.89;
end

if length(varargin) > 1 && ~isempty(varargin{2})
    image_zero_order_coord = varargin{2};
else
    image_zero_order_coord = [147 145]';
end

if length(varargin) > 2 && ~isempty(varargin{3})
    stack_um_per_slice = varargin{3};
else
    stack_um_per_slice = 2.0;
end

if length(varargin) > 3 && ~isempty(varargin{4})
    do_detect = varargin{4};
else
    do_detect = 1;
end

if length(varargin) > 4 && ~isempty(varargin{5})
    fluor_min = varargin{5};
else
    fluor_min = 150;
end

if do_detect
    peak_detection_12(filename);
end

load([filename '.mat'])

params_em_reduce = filter_nuclear_detection(params_em,fluor_min);
% params_em_reduce = params_em;
nuclear_locs = params_em_reduce([3 2 4],:); % flip from image coord order
fluor_vals = params_em_reduce(1,:);
nuclear_locs_image_coord = nuclear_locs([2 1 3],:);
nuclear_locs([1 2],:) = ...
    bsxfun(@minus,nuclear_locs([1 2],:),image_zero_order_coord)*image_um_per_px;
nuclear_locs([3],:) = nuclear_locs([3],:)*stack_um_per_slice;

out_of_range = find(abs(nuclear_locs(1,:)) > 160 | ...
                    abs(nuclear_locs(2,:)) > 160);
nuclear_locs(:,out_of_range) = [];
nuclear_locs = nuclear_locs';
% nuclear_locs(:,[1 2]) = nuclear_locs(:,[2 1]);

nuclear_locs_image_coord(:,out_of_range) = [];
fluor_vals(out_of_range) = [];


% if ~isempty(fluor_vals)

% fluor_cut = .90;
% plane_fit_points = nuclear_locs(fluor_vals > quantile(fluor_vals,fluor_cut),:);
% [min_z,min_z_cell] = min(nuclear_locs(fluor_vals > quantile(fluor_vals,fluor_cut),3));
% % offset_cells = nuclear_locs(fluor_vals > quantile(fluor_vals,fluor_cut),:);
% % plane_fit_points(:,3) = plane_fit_points(:,3) - min_z;
% 
% plane_fit = [];
% A = [plane_fit_points(:,1) plane_fit_points(:,2) ones(size(plane_fit_points,1),1)];
% b = plane_fit_points(:,3);
% 
% [X,Y] = meshgrid(-150:10:150);
% 
% 
% plane_fit = inv(A'*A)*A'*b;
% Z = plane_fit(1)*X + plane_fit(2)*Y + plane_fit(3);
% % detect_img
% res = b - A*plane_fit;
% [min_z, min_z_cell] = max(-res)
% Z_offset = min_z;%plane_fit(1)*offset_cells(min_z_cell,1) + plane_fit(2)*offset_cells(min_z_cell,2) + plane_fit(3) 
% Z = Z - Z_offset;
% plane_fit(3) = plane_fit(3) - Z_offset;
% 
% nuclear_locs(:,4) = nuclear_locs(:,3) - (plane_fit(1)*nuclear_locs(:,1) + plane_fit(2)*nuclear_locs(:,2) + plane_fit(3));

figure; 
% subplot(121)
% mesh(X,Y,-Z,'facealpha',0,'Cdata',repmat(reshape([0 0 1],1,1,3),31,31,1));
% hold on; 
scatter3(nuclear_locs(:,1),nuclear_locs(:,2),-nuclear_locs(:,3),5,'filled')
xlabel('x (um)'); ylabel('y (um)'); zlabel('depth (um)')
% subplot(122)
% mesh(X,Y,Z,'facealpha',0,'Cdata',repmat(reshape([0 0 1],1,1,3),31,31,1));
% hold on; 
% scatter3(nuclear_locs(:,1),nuclear_locs(:,2),-nuclear_locs(:,4),min(fluor_vals/6),'filled')


% end

% detect_img = [];

detect_img = plot_nuclear_detect_3D([filename '.tif'],nuclear_locs_image_coord);%,[],ceil(fluor_vals/10) + 1,fluor_vals);

