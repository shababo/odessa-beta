function [measures3D, measures2D, max_proj3D, max_proj2D] = measure_tiff_set(filebase,file_inds,baseline_img,start_point,grid_dim,x1_move,x2_move)

count = 1;
check_fig = figure;

if size(start_point,1) == 1
    for i = 1:grid_dim(1)
        row_start = start_point + (i-1)*x1_move;
        for j = 1:grid_dim(2)
            centers(count,:) = round(row_start + (j-1)*x2_move);
            count = count + 1;
        end
    end
else
    centers = start_point;
end

% load baseline
infoimage = imfinfo(baseline_img);
num_cols = infoimage(1).Width;
num_rows = infoimage(1).Height;
num_images = length(infoimage);
full_baseline_imagemat = zeros(num_rows,num_cols,num_images);

tifflink = Tiff(baseline_img,'r');
for k = 1:num_images
    tifflink.setDirectory(k);
    full_baseline_imagemat(:,:,k) = tifflink.read();
end
tifflink.close();

slice_baseline_imagemat = full_baseline_imagemat(:,:,ceil(num_images/2));
baseline_imagemat = sum(full_baseline_imagemat,3);
num_targets = size(centers,1);

for i = 1:num_targets
    
    this_center = centers(i,:);

    filepath = sprintf(filebase,file_inds(i));
    infoimage = imfinfo(filepath);
    num_cols = infoimage(1).Width;
    num_rows = infoimage(1).Height;
    num_images = length(infoimage);
    full_imagemat = zeros(num_rows,num_cols,num_images);

    tifflink = Tiff(filepath,'r');
    for k = 1:num_images
        tifflink.setDirectory(k);
        full_imagemat(:,:,k) = tifflink.read();
    end
    tifflink.close();
    
    slice_imagemat = full_imagemat(:,:,ceil(num_images/2));
    imagemat = sum(full_imagemat,3);

    x1range = max(1,this_center(1)-49):min(this_center(1)+49,size(imagemat,1));
    x2range = max(1,this_center(2)-49):min(this_center(2)+49,size(imagemat,2));
%             x1range(1)
%             x1range(end)
%             x2range(1)
%             x2range(end)
    measures3D(i) = sum(sum(imagemat(x1range,x2range))) - sum(sum(baseline_imagemat(x1range,x2range)));
    measures2D(i) = sum(sum(slice_imagemat(x1range,x2range))) - sum(sum(slice_baseline_imagemat(x1range,x2range)));
%     measures2D(i) = max(sum(sum(full_imagemat(x1range,x2range,:),1),2)) - max(sum(sum(full_baseline_imagemat(x1range,x2range,:),1),2));
    figure(check_fig)

    min_val = min(full_imagemat(:));
    max_val = max(full_imagemat(:));
    for k = 1:num_images
        subplot(121)
        imagesc(full_imagemat(x1range,x2range,k));
        caxis([min_val max_val]);
        subplot(122)
        imagesc(full_baseline_imagemat(x1range,x2range,k));
        caxis([min_val max_val]);
        pause(.05);
    end

    if i == 1
        
        max_proj2D = slice_imagemat;
        max_proj3D = full_imagemat;

    else
        
        max_proj2D = max(max_proj2D,slice_imagemat);
        max_proj3D = max(max_proj3D,full_imagemat);

    end

end


        
