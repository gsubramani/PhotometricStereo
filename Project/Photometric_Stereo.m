clear;
%% Apply photometric stereo
loaded_data = load('sivam_face_data_good.mat');
fd = loaded_data.face_data;
crop_square = loaded_data.crop_square;
use_images = 1:length(fd);%round(rand(8)*length(fd));
%use_images = use_images(use_images~=11&use_images~=15);

iterations = 4;
camera_dir = [0 0 1];
camera_dir_update = [0 0 0];
for iter = 1:iterations
    camera_dir(1,2) = - 3*camera_dir_update(1,2) + camera_dir(1,2);
    camera_dir = camera_dir/norm(camera_dir);
    index = 1;
    light_dirs = [];
    for ii = use_images
        %crop_square = [787,145,789,789];
        %crop_square = [255,113,261,261];
        %crop_square = [716 190 727 727];
        %camera_dir = [0.1707,0.1770,0.9156];
        %camera_dir = [0.1707 + 0.0609,0.177-0.0453,0.9686];
        %camera_dir = [0.1707 + 0.0609+0.1,0.177-0.0453,0.9686];
        %camera_dir = [-0.2910 - 0.1634,-0.1073 - 0.0857,0.9282];
        s = compLightDirs(fd(ii).l_eye_center,fd(ii).l_highlight ...
            ,fd(ii).l_radius,fd(ii).r_eye_center,fd(ii).r_highlight ...
            ,fd(ii).r_radius,camera_dir);
        if (sum(imag(s)) == 0)
            light_dirs= [light_dirs;s];
            img_cell{index} =imcrop(fd(ii).img,crop_square);
            index = index + 1;
        end
        
        
    end
    %%
    mask = loaded_data.face_mask;
    
    mask = imcrop(mask,crop_square);
    
    [normals, albedo_img] = ...
        computeNormals(light_dirs, img_cell, mask);
    camera_dir_update = mean(mean(normals));
end
normal_map_img = uint8((normals + 1)/2 * 255);
surf_img = reconstructSurf(normals,mask);

imwrite(surf_img, 'surface_img.png');

% Use the surf tool to visualize the 3D reconstruction
%figure, surf(im2double(imresize(surf_img, 0.3)));
figure, surf(im2double(surf_img),'FaceLighting','phong','edgecolor','none');
colormap gray;
light()


