function [normals, albedo_img] = ...
    computeNormals(light_dirs, img_cell, mask)
S = light_dirs;
S_fact = (S'*S)\S';
[r,c] = size(mask);
normals = zeros(r,c,3);
normals(:,:,3) = ones(r,c);
albedo_img = zeros(r,c);
for i = find(mask~=0)'
    [r_ind,c_ind] = ind2sub([r,c],i);
    I = zeros(length(img_cell),1);
    for j = 1:length(img_cell)
        I(j) = img_cell{j}(r_ind,c_ind);
    end
    N = S_fact*I;
    albedo_img(r_ind,c_ind) = norm(N);
    normals(r_ind,c_ind,[1,2,3]) = N/albedo_img(i);
end
albedo_img = albedo_img/max(albedo_img(:));
end