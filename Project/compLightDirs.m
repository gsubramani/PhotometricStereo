function s = compLightDirs(eye_center1,specular_spot1,iris_size1,eye_center2,specular_spot2,iris_size2,v)
%% Assumes eye size is 8 mm radius ball. The iris radius is 12 mm 
R_ball_mm = 8;
R_iris_mm = 12;
R = R_ball_mm*iris_size1/R_iris_mm;

z1 = (R^2 - sum((specular_spot1 - eye_center1).^2))^0.5;
z2 = (R^2 - sum((specular_spot2 - eye_center2).^2))^0.5;
n1 = fliplr([z1 specular_spot1 - eye_center1]);
n1 = n1/norm(n1);
n2 = fliplr([z2 specular_spot2 - eye_center2]);
n2 = n2/norm(n2);
n = (n1 + n2)/2;
% Assume the camera is perpendicular to the incident light direction
angle_ref = acos((dot(n1,[0 0 1])/norm(n1) + dot(n2,[0 0 1])/norm(n2))/2);
angle_ref = angle_ref*2;
%v = [0 0 1];
%v = [0.1707,0.1770,0.9156];
%v = [0.1707 + 0.0609,0.177-0.0453,0.9686];

k = cross(v,n);
s = v*cos(angle_ref) + cross(k,v)*sin(angle_ref) ...
    + k*(dot(k,v))*(1 - cos(angle_ref));
s = s/norm(s);
%s = n;
end