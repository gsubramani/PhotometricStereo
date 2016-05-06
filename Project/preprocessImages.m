%% Process images
folder_name = './FaceSubset2/';
file_type = '*.png';


files = dir([folder_name file_type]);
start = 1;
%% Find rectangular region
fig=figure;
rgbimg = imread([folder_name files(1).name]);
imshow(rgbimg);
crop_square = getrect;
close all;
%% compute mask
mask_img_ids = [5];
for ii = mask_img_ids
fig=figure;

rgbimg = imread([folder_name files(ii).name]);
if 3 == size(rgbimg,3)
    img = rgb2gray(rgbimg);
else
    img = rgbimg;
end
imshow(rgbimg);
[x_face, y_face] = getpts(fig);
face_mask = magicwand(cat(3,img, img, img), floor(y_face), floor(x_face), 40);
face_mask = ~imfill(face_mask,'holes');
face_mask = ~face_mask;
imshow(uint8(img).*uint8(face_mask));
face_mask = face_mask | face_mask;
end
imshow(uint8(img).*uint8(face_mask));

%%
    fig = figure;
    img = imread([folder_name files(ii).name]);
    imshow(img);
    l_rect = getrect(fig);
    r_rect = getrect(fig);
for ii = start:length(files)
    face_data(ii).name = files(ii).name;
    fig = figure;
    img = imread([folder_name files(ii).name]);
    if size(img,3) == 3
        img = rgb2gray(img);
    end
    imshow(img);
    face_data(ii).img = img;
    face_data(ii).img_masked = uint8(double(face_data(ii).img).*double(face_mask));
    %% get eye locations
    eye_img = imcrop(img,l_rect);
    imshow(eye_img);
    rect = l_rect;
    %R_range = round([15 rect(end)]);
    R_range = round([3 rect(end)]);
    BW_eye_img = im2bw(imsharpen(eye_img,'Amount',5), 0.1);
    imshow(BW_eye_img)
    [centersDark, radiiDark] = imfindcircles(BW_eye_img,R_range,'ObjectPolarity','dark');
    viscircles(centersDark, radiiDark,'EdgeColor','b');
    %%
    % Find center of Specular Highlight on eye
    iris_rect = [centersDark - [radiiDark,radiiDark],2*radiiDark,2*radiiDark];
    iris_img = imcrop(eye_img,iris_rect);
    imshow(iris_img);
    [inten,ind] = max(iris_img(:));
    [y_hightlight,x_hightlight] = ind2sub(size(iris_img),ind);
    highlight_dist = floor(((radiiDark - y_hightlight)^2 + (radiiDark - x_hightlight)^2)^0.5);
    while highlight_dist>radiiDark
        iris_img(y_hightlight,x_hightlight) = 0;
        [inten,ind] = max(iris_img(:));
        [y_hightlight,x_hightlight] = ind2sub(size(iris_img),ind);
        highlight_dist = floor(((radiiDark - y_hightlight)^2 + (radiiDark - x_hightlight)^2)^0.5);
    end
    hold on;
    plot(x_hightlight,y_hightlight,'+');
    plot(radiiDark,radiiDark,'+r')
    %%
    face_data(ii).l_eye_center = [radiiDark,radiiDark];
    face_data(ii).l_radius = radiiDark;
    face_data(ii).l_highlight = [y_hightlight,x_hightlight];
    face_data(ii).l_eye_Img = eye_img;
    face_data(ii).l_iris_img = iris_img;
    face_data(ii).l_rect = rect;
    %pause;
    %%%%%
    eye_img = imcrop(img,r_rect);
    imshow(eye_img);
    rect = r_rect;
    %R_range = round([15 rect(end)]);
    %BW_eye_img = im2bw(imsharpen(eye_img,'Amount',5), 0.4);
    R_range = round([3 rect(end)]);
    BW_eye_img = im2bw(imsharpen(eye_img,'Amount',5), 0.1);
    imshow(BW_eye_img)
    [centersDark, radiiDark] = imfindcircles(BW_eye_img,R_range,'ObjectPolarity','dark');
    imshow(eye_img)
    viscircles(centersDark, radiiDark,'EdgeColor','b');
    %%
    % Find center of Specular Highlight on eye
    iris_rect = [centersDark - [radiiDark,radiiDark],2*radiiDark,2*radiiDark];
    iris_img = imcrop(eye_img,iris_rect);
    imshow(iris_img);
    [inten,ind] = max(iris_img(:));
    [y_hightlight,x_hightlight] = ind2sub(size(iris_img),ind);
    highlight_dist = floor(((radiiDark - y_hightlight)^2 + (radiiDark - x_hightlight)^2)^0.5);
    while highlight_dist>radiiDark
        iris_img(y_hightlight,x_hightlight) = 0;
        [inten,ind] = max(iris_img(:));
        [y_hightlight,x_hightlight] = ind2sub(size(iris_img),ind);
        highlight_dist = floor(((radiiDark - y_hightlight)^2 + (radiiDark - x_hightlight)^2)^0.5);
    end
    hold on;
    plot(x_hightlight,y_hightlight,'+');
    plot(radiiDark,radiiDark,'+r')
    %%
    face_data(ii).r_eye_center = [radiiDark,radiiDark];
    face_data(ii).r_radius = radiiDark;
    face_data(ii).r_highlight = [y_hightlight,x_hightlight];
    face_data(ii).r_eye_Img = eye_img;
    face_data(ii).r_iris_img = iris_img;
    face_data(ii).r_rect = rect;
    %pause;
    
end
save('default.mat','face_data','face_mask','crop_square');
close all;