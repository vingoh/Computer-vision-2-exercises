img1 = imread("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex07/batinria0.pgm");
img2 = imread("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex07/batinria1.pgm");

% Left camera parameters:
K1 = [844.310547 0 243.413315; 0 1202.508301 281.529236; 0 0 1];
R1 = [0.655133, 0.031153, 0.754871;0.003613, 0.999009, -0.044364;-0.755505, 0.031792, 0.654371];
T1 = [-793.848328; 269.264465; -744.572876];

% Right camera parameters:
K2 = [852.721008 0 252.021805; 0 1215.657349 288.587189; 0 0 1];
R2 = [0.739514, 0.034059, 0.672279;-0.006453, 0.999032, -0.043515;-0.673111, 0.027841, 0.739017];
T2 = [-631.052917; 270.192749; -935.050842];

g1 = [R1 T1; 0 0 0 1];
g2 = [R2 T2; 0 0 0 1];
g12 = g1 \ g2;
R12 = g12(1:3, 1:3);
T12 = g12(1:3, 4);
F = (K2^-1)' * hat(T12) * R12 * K2^-1;


figure;
imshow(img1);
hold on
[x1,y1] = ginput(1);
plot(x1,y1,'r+');



l = F * [x1;y1;1];

figure; imshow(uint8(img2));
hold on;
m = -l(1)/l(2);
b = -l(3)/l(2);
[w,~] = size(img2);
y1 = m * 1 + b;
y2 = m * w + b;
line([1 w],[y1 y2]);


function A = hat(v)
A = [0 -v(3) v(2) ; v(3) 0 -v(1) ; -v(2) v(1) 0];
end


