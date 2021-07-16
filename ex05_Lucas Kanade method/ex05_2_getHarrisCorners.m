sigma = 2;
kappa = 0.05;
theta = 10e-7;
I = imreadbw("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex05/img1.png");
[score, points] = HarrisCorners(I, sigma, kappa, theta);
drawPts( I, points )

function [score, points] = HarrisCorners(I, sigma, kappa, theta)

[M11, M12, M22] = getM(I, sigma);

% TODO: compute score using det and trace
C = M11.*M22 - M12.^2 - kappa*(M11+M22).^2;

% TODO: display score
figure;
imagesc(sign(C).*(abs(C).^0.25) );

% TODO: find corners (variable points)
index = (C>theta)&islocalmax(C,1)&islocalmax(C,2); %符合条件的值为1，否则为0 480*640
%figure;
%imagesc(index);
%points = find(index>0);
[n, m] = find(index==1);
points = [m n];
score = C(index);
end

function [M11, M12, M22] = getM(img, sigma)

[Gx, Gy] = imgradientxy(img, 'central');
k = double(uint8(4*sigma+1));
kernel = fspecial('gaussian', k, sigma);
M11 = conv2(Gx.^2, kernel, 'same');
M12 = conv2(Gx.*Gy, kernel, 'same');
M22 = conv2(Gy.^2, kernel, 'same');

end