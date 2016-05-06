function surf_img = reconstructSurf(normals, mask)
%-----------------------
% Surface reconstruction using the Frankot-Chellappa algorithm
%-----------------------

% Compute surface gradients (p, q)
p_img = normals(:, :, 1) ./ ((normals(:, :, 3) + eps));
q_img = normals(:, :, 2) ./ ((normals(:, :, 3) + eps));

% Take Fourier Transofrm of p and q
fp_img = fft2(p_img); fq_img = fft2(q_img); 
[cols, rows] = size(fp_img);

% The domains of u and v are important
[u, v] = meshgrid(([0:cols-1]-fix(cols/2)), ...
    ([0:rows-1]-fix(rows/2)));

clear i, j;
u = ifftshift(u); v = ifftshift(v);
fz = (j*u.*fp_img + j*v.*fq_img) ./ (u.^2 + v.^2 + eps);

% Take inverse Fourier Transform back to the spatial domain
ifz = ifft2(fz);
ifz(~mask) = 0;

z = real(ifz);
surf_img = (z - min(z(:)))/(max(z(:)) - min(z(:)));
surf_img(~mask)=0;
