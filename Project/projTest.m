fig = figure(10);
img=imread('./Yale-Faces/yaleB11_P00A+010E+00.pgm');
imshow(img);
%%
rect = getrect(fig);
[x_face, y_face] = getpts(fig);
%%
figure(11)
eye_img = imcrop(img,rect);
imshow(eye_img);
R_range = [4 rect(end)];
BW_eye_img = im2bw(imsharpen(eye_img,'Amount',5), 0.1);
%BW_eye_img = im2bw(eye_img, 0.1);
[centersDark, radiiDark] = imfindcircles(BW_eye_img,R_range,'ObjectPolarity','dark');
imshow(eye_img)
%imshow(BW_eye_img)
viscircles(centersDark, radiiDark,'EdgeColor','b');
% Find center of Specular Highlight on eye
[inten,ind] = max(eye_img(:));
[x,y] = ind2sub(size(eye_img),ind);
hold on;
plot(y,x,'+');
plot(centersDark(1),centersDark(2),'+r')
%%
figure(12)
face_mask = magicwand(cat(3,img, img, img), floor(y_face), floor(x_face), 30);
face_mask = imfill(face_mask,'holes');
imshow(uint8(img).*uint8(face_mask))








